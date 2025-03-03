const std = @import("std");
const Page = @import("page.zig").Page;
const PageModule = @import("page.zig");
const DATA_PATH = "pages.dat";
const PageError = error{
    InvalidPageId,
    PageNotFound,
    InvalidPageSize,
    ChecksumMismatch,
};
pub const PageManager = struct {
    pages: std.AutoHashMap(u32, *Page),
    next_page_id: u32,
    allocator: std.mem.Allocator,
    
    const Self = @This();
    pub fn init(allocator: std.mem.Allocator) Self {
        // Implementation hint:
        // - Initialize pages hashmap
        // - Set initial page_id counter
        const pages =  std.AutoHashMap(u32, *Page).init(allocator);
        const nextpageid = 1;
        return Self {
           .pages =pages,
           .next_page_id = nextpageid ,
           .allocator = allocator
        };
    }
    pub fn deinit(self: *Self) void
    {
        self.pages.clearAndFree();
    }

    pub fn getPage(self: *Self, page_id: u32) !*Page {
        // Implementation hint:
        // - Check if page exists in memory
        // - If not, load from disk
        if  (self.pages.get(page_id)) |page|
        {
            return page;

        } else 
        {
          return try self.loadPage(page_id);

        }

    }
    pub fn createPage(self: *Self) !u32
    {
        // Allocate the page struct on the heap
        var new_page = try self.allocator.create(Page);
        errdefer self.allocator.destroy(new_page);  // Clean up if initialization fails

        // Initialize the page
        new_page.* = try Page.init(self.allocator, self.next_page_id);
        errdefer new_page.deinit();  // Clean up if later steps fail

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
    pub fn deletePage(self: *Self,page_id:u32) !void
    {
        if (self.pages.remove(page_id)) |page|
        {
            //deallocate memory
            page.deinit();
        } else {
            return error.PageNotFound;
        }
    }

    pub fn savePage(self: *Self) !void
    {
        const file = try std.fs.cwd().createFile(
            DATA_PATH,
            .{ .write = true, .truncate = true },
        );
        defer file.close();

        var writer = file.writer();

        var iterator = self.pages.iterator();
        while (iterator.next()) |entry|
        {
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
    pub fn loadPage(self: *Self, page_id: u32) !*Page
    {
            const file = try std.fs.cwd().openFile(DATA_PATH, .{.read = true});
            defer file.close();

            //calculate the offset
            const offset = page_id * PageModule.PAGE_SIZE;
            try file.seekTo(offset);

            //allocate buffer for page data
            var buffer:[PageModule.PAGE_SIZE]u8 = undefined;

            //read page data
            try file.readAll(&buffer);

            //desearilize the page
            var new_page = try Page.init(self.allocator, page_id);
            errdefer new_page.deinit();
            new_page.header =  @as(*PageModule.PageHeader,@ptrCast(&buffer[0])).*;

            // Allocate memory for the data buffer
            new_page.data = try self.allocator.alloc(u8, PageModule.DATA_SIZE);
            // Copy the data from the buffer
            std.mem.copy(u8, new_page.data, buffer[PageModule.HEADER_SIZE..]);

            // Insert the new page into the HashMap
            try self.pages.put(page_id, &new_page);

            return &new_page;
 
    } 
 
}; 