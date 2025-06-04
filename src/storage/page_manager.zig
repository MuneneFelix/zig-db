const std = @import("std");
const File = @import("std").fs.File;

const Page = @import("page.zig").Page;
const PageModule = @import("page.zig");
const DATA_PATH = "pages.dat";
const PageError = error{
    InvalidPageId,
    PageNotFound,
    InvalidPageSize,
    ChecksumMismatch,
};
const CreateFileError = error{
    PathAlreadyExists,
};
pub const PageManager = struct {
    pages: std.AutoHashMap(u32, *Page),
    next_page_id: u32,
    allocator: std.mem.Allocator,

    const Self = @This();

    pub fn init(allocator: std.mem.Allocator) !Self {
        // Implementation hint:
        // - Initialize pages hashmap
        // - Set initial page_id counter
        const pages = std.AutoHashMap(u32, *Page).init(allocator);
        const nextpageid = 1;
        return Self{ .pages = pages, .next_page_id = nextpageid, .allocator = allocator };
    }

    pub fn deinit(self: *Self) void {
        var it = self.pages.iterator();
        while (it.next()) |entry| {
            entry.value_ptr.*.deinit();
            self.allocator.destroy(entry.value_ptr.*);
        }
        self.pages.clearAndFree();
    }

    pub fn getPage(self: *Self, page_id: u32) !*Page {
        // Implementation hint:
        // - Check if page exists in memory
        // - If not, load from disk

        //std.debug.print("\n Page Manager Struct {any}\n", .{self});

        if (self.pages.get(page_id)) |page| {
            return page;
        } else {
            return try self.loadPage(page_id);
        }
    }

    pub fn createPage(self: *Self) !u32 {
        // Allocate the page struct on the heap
        var new_page = try self.allocator.create(Page);
        errdefer self.allocator.destroy(new_page); // Clean up if initialization fails

        // Initialize the page
        new_page.* = try Page.init(self.allocator, self.next_page_id);
        errdefer new_page.deinit(); // Clean up if later steps fail

        // Initialize the page header
        new_page.header.page_id = self.next_page_id;
        new_page.header.next_page = 0;
        new_page.header.free_space_offset = PageModule.DATA_SIZE;
        new_page.header.checksum = 0;
        new_page.header.flags = 0;
        new_page.header.record_count = 0;

        // Store the heap-allocated page in the hashmap
        try self.pages.put(self.next_page_id, new_page);

        // Update the page ID counter
        const page_id = self.next_page_id;
        self.next_page_id += 1;

        return page_id;
    }
    pub fn deletePage(self: *Self, page_id: u32) !void {
        if (self.pages.remove(page_id)) |page| {
            //deallocate memory
            page.deinit();
            self.allocator.destroy(page);
        } else {
            return error.PageNotFound;
        }
    }

    pub fn savePage(self: *Self) !void {
        const file = try std.fs.cwd().createFile(
            DATA_PATH,
            .{},
        );
        defer file.close();

        var writer = file.writer();

        var iterator = self.pages.iterator();
        while (iterator.next()) |entry| {
            const page = entry.value_ptr.*;

            // Seek to correct position based on page_id
            const offset = page.header.page_id * PageModule.PAGE_SIZE;
            try file.seekTo(offset);

            // Write header
            const header_bytes = std.mem.asBytes(&page.header);
            try writer.writeAll(header_bytes);

            // Write data
            try writer.writeAll(page.data);

            // Verify written size
            if (header_bytes.len + page.data.len != PageModule.PAGE_SIZE) {
                return error.InvalidPageSize;
            }
        }
    }
    pub fn createDataFile() !File {
        const file = std.fs.cwd().createFile(DATA_PATH, .{ .exclusive = true }) catch |e|
            switch (e) {
                error.PathAlreadyExists => {
                    std.debug.print("\n file already exists \n", .{});
                    return std.fs.cwd().openFile(DATA_PATH, .{});
                },
                else => {
                    std.debug.print("\n file creation error {any} \n", .{e});
                    return e;
                },
            };
        return file;
    }

    pub fn loadPage(self: *Self, page_id: u32) !*Page {
        // Step 1: Open or create the data file
        const file = try createDataFile();
        defer file.close(); // Ensure the file is closed even if an error occurs

        // Step 2: Calculate the offset for the page
        const offset = page_id * PageModule.PAGE_SIZE;

        // Step 3: Seek to the correct position in the file
        // try file.seekTo(offset) catch |e| {
        //     std.debug.print("Error seeking to offset {}: {}\n", .{ offset, e });
        //     return e; // Propagate the error
        // };
        try file.seekTo(offset);

        // Step 4: Allocate a buffer for reading the page data
        var buffer: [PageModule.PAGE_SIZE]u8 = undefined;

        // Step 5: Read the page data into the buffer
        // _ = try file.readAll(&buffer) catch |e| {
        //     std.debug.print("Error reading page data: {}\n", .{e});
        //     return e; // Propagate the error
        // };
        _ = try file.readAll(&buffer);

        // Step 6: Deserialize the page
        var new_page = try self.allocator.create(Page);
        try new_page.initPtr(self.allocator, page_id);
        errdefer new_page.deinit();

        //const pageHeaderptr: *PageModule.PageHeader = @ptrCast(@alignCast(&buffer[0]));
        //var header: PageModule.PageHeader = undefined;
        std.mem.copyForwards(u8, std.mem.asBytes(&new_page.header), buffer[0..@sizeOf(PageModule.PageHeader)]);
        //new_page.header = header;

        // Step 7: Allocate memory for the page's data buffer
        // new_page.data = try self.allocator.alloc(u8, PageModule.DATA_SIZE) catch |e| {
        //     std.debug.print("Error allocating memory for page data: {}\n", .{e});
        //     return e; // Propagate the error
        // };
        //was double allocated within the initPtr function and on the next line
        //new_page.data = try self.allocator.alloc(u8, PageModule.DATA_SIZE);

        // Step 8: Copy the data from the buffer into the page's data buffer
        std.mem.copyForwards(u8, new_page.data, buffer[PageModule.HEADER_SIZE..]);

        // Step 9: Insert the new page into the HashMap
        // try self.pages.put(page_id, &new_page) catch |e| {
        //     std.debug.print("Error inserting page into HashMap: {}\n", .{e});
        //     return e; // Propagate the error
        // };
        try self.pages.put(page_id, new_page);
        // Step 10: Return the new page
        return new_page;
    }

    test "createDataFile creates a new file" {
        // const allocator = std.testing.allocator;

        // Ensure the file does not exist before the test
        const fs = std.fs.cwd();
        if (fs.exists(DATA_PATH)) {
            try fs.deleteFile(DATA_PATH);
        }

        // Call createDataFile
        const file = try PageManager.createDataFile();
        defer file.close();

        // Verify that the file now exists
        try std.testing.expect(fs.exists(DATA_PATH));
    }
};
