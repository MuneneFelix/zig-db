const std = @import("std");
pub const PAGE_SIZE: usize = 4096;
pub const HEADER_SIZE: usize = @sizeOf(PageHeader);
pub const DATA_SIZE: usize = PAGE_SIZE - HEADER_SIZE;
const PageInitErrors = error{ OutOfMemory, InvalidPageId, AllocationError, InvalidRecordSize };
const DeleteRecordError = error{
    InvalidOffset, // Offset out of bounds
    RecordNotFound, // No record at offset
    AlreadyDeleted, // Record already marked as deleted
    InvalidRecord,
};
pub const PageHeader = struct {
    page_id: u32, //unique id identifying a page
    next_page: u32, // For linked pages
    free_space_offset: u16, //free ptr
    record_count: u16,
    checksum: u32, // For data integrity
    flags: u16,
};

pub const RecordHeader = struct {
    size: u16, //size of the record
    offset: u16, //offset within the page
    is_deleted: bool, //Tombstone for deleted records
};

pub const Record = struct {
    header: RecordHeader,
    data: []const u8,

    const Self = @This();

    // Helper functions for the record
    pub fn size(self: Self) u16 {
        const sizeofrec: u16 = @intCast(self.data.len);

        return @sizeOf(RecordHeader) + sizeofrec;
    }

    // Serialize the record for storage
    pub fn serialize(self: Self, buffer: []u8) void {
        // Copy header
        const header_bytes = std.mem.asBytes(&self.header);
        std.mem.copy(u8, buffer[0..@sizeOf(RecordHeader)], header_bytes);

        // Copy data
        std.mem.copy(u8, buffer[@sizeOf(RecordHeader)..], self.data);
    }

    // Deserialize from storage
    pub fn deserialize(buffer: []const u8) Self {
        const header = @as(*const RecordHeader, @ptrCast(buffer[0..@sizeOf(RecordHeader)])).*;
        const data = buffer[@sizeOf(RecordHeader)..header.size];

        return Self{
            .header = header,
            .data = data,
        };
    }
};

pub const Page = struct {
    header: PageHeader,
    allocator: std.mem.Allocator,
    data: []u8, // Fixed size data buffer

    const Self = @This();

    pub fn init(allocator: std.mem.Allocator, page_id: u32) !Self {
        // Implementation hint:
        // - Allocate fixed size page (e.g. 4KB)
        // - Initialize header
        //checks for valid page id
        if (page_id == 0) {
            return PageInitErrors.InvalidPageId;
        }

        //allocate byte buffer for data
        const data = try allocator.alloc(u8, DATA_SIZE);

        const page_header = PageHeader{ .page_id = page_id, .next_page = 0, .checksum = 0, .free_space_offset = DATA_SIZE, .record_count = 0, .flags = 0 };
        return Self{ .header = page_header, .data = data, .allocator = allocator };

        //create page header instance
        //initialize header fields
        //return page struct

    }
    pub fn deinit(self: *Self) void {
        self.allocator.free(self.data);
    }

    pub fn insertRecord(self: *Self, data: []const u8) !u16 {
        // First validate record size
        if (!isValidRecordSize(data.len)) {
            return PageInitErrors.InvalidRecordSize;
        }

        // Then check available space
        if (!self.hasEnoughSpace(data.len)) {
            return PageInitErrors.OutOfMemory;
        }
        const recHeadersize: u16 = @intCast(@sizeOf(RecordHeader));
        const datalength: u16 = @intCast(data.len);
        const total_record_size: u16 = recHeadersize + datalength;

        std.debug.print("\n Print Total Record Size {any} \n", .{total_record_size});
        // 2. Find location to insert (using free_space_offset)
        const new_offset = self.header.free_space_offset - total_record_size;

        // 3. Write record header and data
        const record_header = RecordHeader{
            .size = @intCast(data.len),
            .offset = @intCast(new_offset),
            .is_deleted = false,
        };
        std.debug.print("\n Print Record Header Before Insertion {any}\n", .{record_header});

        //cast record header into a slice []u8
        const recHeader_bytes: []const u8 = std.mem.asBytes(&record_header);
        std.mem.copyForwards(u8, self.data[new_offset..(new_offset + @sizeOf(RecordHeader))], recHeader_bytes);
        std.mem.copyForwards(u8, self.data[(new_offset + @sizeOf(RecordHeader))..(new_offset + total_record_size)], data);
        // 4. Update page header (free_space_offset, record_count)
        self.header.free_space_offset = new_offset;
        self.header.record_count = self.header.record_count + 1;
        // 5. Return record offset or ID
        return new_offset;
    }

    pub fn deleteRecord(self: *Self, offset: u16) !void {
        // 1. Validate offset
        if ((offset < 0) or (self.header.free_space_offset > offset)) {
            return DeleteRecordError.InvalidOffset;
        }

        // 2. Mark record as deleted
        const buffer: []u8 = self.data[offset..];
        var recHeader: RecordHeader = @as(*RecordHeader, @ptrCast(&buffer[0])).*;
        if (recHeader.size <= 0) {
            DeleteRecordError.InvalidRecord;
        }
        recHeader.is_deleted = true;

        const header_bytes = std.mem.asBytes(&recHeader);
        std.mem.copy(u8, self.data[offset..(offset + @sizeOf(RecordHeader))], header_bytes[0..@sizeOf(RecordHeader)]);

        // 3. Update page metadata
        self.header.record_count = self.header.record_count - 1;
        // 4. Optional: Compact page ->we chose a tombstone approach coupled with a garbage collector
    }

    //create a getrecords function

    pub fn getRecord(self: *Self, offset: u16) ![]const u8 {
        // 1. Validate offset
        if ((offset < 0) or (self.header.free_space_offset > offset)) {
            return DeleteRecordError.InvalidOffset;
        }
        if (offset >= DATA_SIZE) {
            return DeleteRecordError.InvalidOffset;
        }
        // 2. Check if record is deleted
        const buffer: []u8 = self.data[offset..];
        const recHeaderptr: *RecordHeader = @ptrCast(@alignCast(&buffer[0]));

        const recHeader = recHeaderptr.*;
        // const recHeader: *RecordHeader = @as(*RecordHeader, @ptrCast(&buffer[0])).*;
        if (recHeader.is_deleted == true) {
            return DeleteRecordError.AlreadyDeleted;
        }

        //validate recheader.size
        if (recHeader.size == 0) {
            return DeleteRecordError.InvalidRecord;
        }

        if ((offset + @sizeOf(RecordHeader) + recHeader.size) > DATA_SIZE) {
            return DeleteRecordError.InvalidRecord;
        }
        // 3. Return record data
        const data = self.data[offset + @sizeOf(RecordHeader) .. offset + recHeader.size + @sizeOf(RecordHeader)];

        //4. Error handling for corrupted records

        return data;
    }

    fn hasEnoughSpace(self: *Self, data_size: usize) bool {
        // Calculate total space needed (record header + data)
        const needed_space = @sizeOf(RecordHeader) + data_size;

        //message std memory
        // std.debug.print("DATA SIZE {any}, FREE SPACE OFFSET {any}", .{ DATA_SIZE, self.header.free_space_offset });
        // Calculate available space
        const available_space = self.header.free_space_offset;

        // Compare and return
        return available_space >= needed_space;
    }

    fn isValidRecordSize(data_size: usize) bool {
        //std.debug.print("record size check {any}", .{data_size});
        // 1. Check minimum size
        if (data_size == 0) return false;

        // 2. Check maximum size

        if (data_size > DATA_SIZE) return false;

        return true;
    }
};
