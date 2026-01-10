//this should the following functions only
//1. Create page on disk
//2. Load page from disk
//3. Delete page from disk
//4. Save page updates to disk

//This will therefore abstract over all of the disk handling e.t.c and allow buffer pool to act as true memory manager
//The page manager will then combine the buffer pool but no memory/file handling
const std = @import("std");
const File = @import("std").fs.File;
const Page = @import("page.zig").Page;
const DATA_PATH = "pages.dat";
const PageError = error{
    InvalidPageId,
    PageNotFound,
    InvalidPageSize,
    ChecksumMismatch,
    PageDeleted,
};
const CreateFileError = error{
    PathAlreadyExists,
};
pub const PageStorage = struct {
    allocator: std.mem.Allocator,
    file_path: []const u8,

    const Self = @This();
    //declare init function
    pub fn init(allocator: std.mem.Allocator, file_path: []const u8) !Self {
        const fpath = if (file_path.len == 0) DATA_PATH else file_path;
        return Self{ .file_path = fpath, .allocator = allocator };
    }
    pub fn deinit(self: *Self) void {
        self.allocator.free(self.file_path);
    }

    //declare LoadPageFromDisk function
    pub fn loadPageFromDisk(self: *Self, page_id: u32, include_deleted: ?bool) !*Page {
        const should_include_deleted = include_deleted orelse false;
        // Step 1: Open or create the data file
        const file = try createDataFile(self.file_path);
        defer file.close(); // Ensure the file is closed even if an error occurs

        // Step 2: Calculate the offset for the page
        const offset = page_id * Page.PAGE_SIZE;

        try file.seekTo(offset);

        // Step 4: Allocate a buffer for reading the page data
        var buffer: [Page.PAGE_SIZE]u8 = undefined;

        _ = try file.readAll(&buffer);

        // Step 6: Deserialize the page
        var new_page = try self.allocator.create(Page);
        try new_page.initPtr(self.allocator, page_id);
        errdefer {
            new_page.deinit();
            self.allocator.destroy(new_page);
        }

        std.mem.copyForwards(u8, std.mem.asBytes(&new_page.header), buffer[0..@sizeOf(Page.PageHeader)]);

        // Step 8: Copy the data from the buffer into the page's data buffer
        std.mem.copyForwards(u8, new_page.data, buffer[Page.HEADER_SIZE..]);

        // Step 10: Return the new page
        if (!should_include_deleted and new_page.header.is_deleted) {
            //new_page.deinit();
            return PageError.PageDeleted;
        } else {
            return new_page;
        }
    }

    //delcare SavePageToDisk function
    pub fn savePageToDisk(self: *Self, page: Page) !void {
        const file = try std.fs.cwd().createFile(
            self.file_path,
            .{},
        );
        defer file.close();

        var writer = file.writer();
        const offset = (page.header.page_id * Page.PAGE_SIZE);
        try file.seekTo(offset);

        // Write header
        const header_bytes = std.mem.asBytes(&page.header);
        try writer.writeAll(header_bytes);

        // Write data
        try writer.writeAll(page.data);

        // Verify written size
        if (header_bytes.len + page.data.len != Page.PAGE_SIZE) {
            return error.InvalidPageSize;
        }
    }

    //delcare writePageToDisk, this assumes file exists and opens seeks and writes
    pub fn writePageToDisk(self: *Self, page: Page) !void {
        const file = try std.fs.cwd().openFile(
            self.file_path,
            .{},
        );
        defer file.close();

        var writer = file.writer();
        const offset = (page.header.page_id * Page.PAGE_SIZE);
        try file.seekTo(offset);

        // Write header
        const header_bytes = std.mem.asBytes(&page.header);
        try writer.writeAll(header_bytes);

        // Write data
        try writer.writeAll(page.data);

        // Verify written size
        if (header_bytes.len + page.data.len != Page.PAGE_SIZE) {
            return error.InvalidPageSize;
        }
    }
    //declare deletepagefromdisk function
    pub fn deletePageFromDisk(page_id: u32) !void {
        var page = try loadPageFromDisk(page_id, false);
        page.is_deleted = true;
        try savePageToDisk(page);
    }
    pub fn createDataFile(self: *Self) !File {
        const file = std.fs.cwd().createFile(self.file_path, .{ .exclusive = true }) catch |e|
            switch (e) {
                error.PathAlreadyExists => {
                    std.debug.print("\n file already exists \n", .{});
                    return std.fs.cwd().openFile(self.file_path, .{});
                },
                else => {
                    std.debug.print("\n file creation error {any} \n", .{e});
                    return e;
                },
            };
        return file;
    }
};
