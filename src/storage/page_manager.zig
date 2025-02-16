const std = @import("std");
const Page = @import("page.zig").Page;
const PageModule = @import("page.zig");
pub const PageManager = struct {
    pages: std.AutoHashMap(u32, *Page),
    next_page_id: u32,
    allocator: std.mem.Allocator,
    
    const Self = @This();
    pub fn init(allocator: std.mem.Allocator) Self {
        // Implementation hint:
        // - Initialize pages hashmap
        // - Set initial page_id counter
        const pages = try std.AutoHashMap(u32, *Page).init(allocator);
        const nextpageid = 1;
        return Self {
           .pages =pages,
           .next_page_id = nextpageid ,
           .allocator = allocator
        };
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
            const file = try std.fs.cwd().openFile("pages.dat", .{.read = true});
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

            new_page.header =  @ptrCast(*PageModule.PageHeader,buffer[0]).*;

            // Allocate memory for the data buffer
            new_page.data = try self.allocator.alloc(u8, PageModule.DATA_SIZE);
            // Copy the data from the buffer
            std.mem.copy(u8, new_page.data, buffer[PageModule.HEADER_SIZE..]);

            // Insert the new page into the HashMap
            try self.pages.put(page_id, &new_page);

            return &new_page;




        }
    }
 
}; 