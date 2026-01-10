const std = @import("std");
const Page = @import("page.zig").Page;
const PageStorage = @import("page_storage.zig").PageStorage;

pub const BufferPool = struct {
    disk_manager: PageStorage,

    allocator: std.mem.Allocator,

    //1. The fixed array of frames
    frames: []Frame,
    //2. The lookup for pages page_table
    page_table: std.AutoHashMap(u32, usize),
    //3. list of frea frames
    free_list: std.ArrayList(usize),

    //4. The clock hand
    clock_hand: usize = 0,

    const Self = @This();

    pub fn init(allocator: std.mem.Allocator, capacity: usize, diskmanager: PageStorage) !Self {
        const frames = try allocator.alloc(Frame, capacity);
        const pagetable = std.AutoHashMap(u32, usize).init(allocator);
        const freelist = try std.ArrayList(usize).initCapacity(allocator, capacity);

        for (0..capacity) |i| {
            frames[i] = try Frame.init(allocator);
            try freelist.append(allocator, i);
        }

        return Self{ .frames = frames, .page_table = pagetable, .free_list = freelist, .clock_hand = 0, .allocator = allocator, .disk_manager = diskmanager };
    }
    pub fn deinit(self: *Self) void {
        // We will need to flush dirty pages here later

        for (self.frames) |*frame| {
            if (frame.is_dirty) {
                self.disk_manager.writePageToDisk(frame.page) catch |err|
                    {
                        std.debug.print("Failed to flush page {}: {}\n", .{ frame.page.header.page_id, err });
                    };
            }
            frame.deinit(); // You'll need to implement this in Frame
        }
        self.allocator.free(self.frames);
        self.page_table.deinit();
        self.free_list.deinit();
        //disk manager was passed in so we do not deinit it here
    }
};

pub const Frame = struct {
    page: Page,
    allocator: std.mem.Allocator,
    pin_count: u32,
    is_dirty: bool,
    ref_bit: bool,
    const Self = @This();

    pub fn init(allocator: std.mem.Allocator) !Self {
        const emptyPage = try Page.initEmpty(allocator);
        const ref_bit = false;
        const is_dirty = false;
        const pin_count = 0;

        return Self{ .page = emptyPage, .ref_bit = ref_bit, .allocator = allocator, .pin_count = pin_count, .is_dirty = is_dirty };
    }

    pub fn deinit(self: *Self) void {
        //This should destroy memory, it assumes dirty frames have been flushed by the bufferpool manager itself

        self.page.deinit();
    }
};
