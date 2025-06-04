const std = @import("std");
const PageManager = @import("storage/page_manager.zig").PageManager;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    errdefer _ = gpa.deinit();
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var page_manager = try PageManager.init(allocator);

    const page_id = try page_manager.createPage();
    const page = try page_manager.getPage(page_id);
    //std.debug.print("Page information {any} ", .{page});
    const record_data = "Hello World!!";
    const record_offset = try page.insertRecord(record_data);
    //std.debug.print("print record offset information {d}", .{record_offset});
    try page_manager.savePage();
    page_manager.deinit();
    page_manager = try PageManager.init(allocator);
    defer page_manager.deinit();
    const page_loaded = try page_manager.loadPage(page_id);
    //std.debug.print("Page loaded data {any} ", .{page_loaded});
    std.debug.print("Record Offset: {}\n", .{record_offset});
    std.debug.print("Data Length: {}\n", .{page_loaded.data.len});
    std.debug.print("Offset: {}\n", .{record_offset});
    const retrieved_data = try page_loaded.getRecord(record_offset);
    try std.testing.expectEqual(record_data, retrieved_data);
    // std.debug.print("retrieved data {any} vs the record data {any}", .{ retrieved_data, record_data });

}
