const std = @import("std");
pub const PAGE_SIZE:usize = 4096;
const HEADER_SIZE:usize = @sizeOf(PageHeader);
const DATA_SIZE:usize = PAGE_SIZE-HEADER_SIZE;
const PageInitErrors = error {OutOfMemory,InvalidPageId,AllocationError};
pub const PageHeader = struct {
    page_id: u32, //unique id identifying a page
    next_page: u32,  // For linked pages
    free_space_offset: u16, //free ptr
    record_count: u16,
    checksum: u32,   // For data integrity
    flags: u16,
};

pub const Page = struct {
    header: PageHeader,
    allocator: std.mem.Allocator,
    data: []u8,  // Fixed size data buffer
    
    const Self = @This();
    
    pub fn init(allocator: std.mem.Allocator, page_id: u32) !Self {
        // Implementation hint: 
        // - Allocate fixed size page (e.g. 4KB)
        // - Initialize header
        //checks for valid page id
        if (page_id == 0)
        {
            return PageInitErrors.InvalidPageId;
        }

        //allocate byte buffer for data
        const data = try allocator.alloc(u8, DATA_SIZE);
        const page_header = PageHeader{
            .page_id = page_id,
            .next_page = 0,
            .checksum = 0,
            .free_space_offset = DATA_SIZE,
            .record_count = 0,
            .flags = 0
        };
        return Self{
            .header = page_header,
            .data = data,
            .allocator = allocator
        };

        //create page header instance
        //initialize header fields
        //return page struct


    }
    pub fn deinit(self: *Self) void
    {
        self.allocator.free(self.data);
    }

    


}; 