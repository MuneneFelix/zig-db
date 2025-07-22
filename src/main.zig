const std = @import("std");
const PageManager = @import("storage/page_manager.zig").PageManager;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{ .verbose_log = true }){};
    errdefer _ = gpa.deinit();
    //defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    var page_manager = try PageManager.init(allocator);
    defer page_manager.deinit();
    const page_id = try page_manager.createPage();

    try page_manager.deletePage(page_id);

    //try std.testing.expectError(PageError.PageNotFound, page_manager.getPage(page_id));
}
pub fn testLoadData() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{ .verbose_log = true }){};
    errdefer _ = gpa.deinit();
    //defer _ = gpa.deinit();
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

    const are_equal = std.mem.eql(u8, record_data, retrieved_data);
    if (!are_equal) {
        std.debug.print("Error: Strings do not match!\nRecord Data: {s}\nRetrieved Data: {s}\n", .{ record_data, retrieved_data });
        return error.StringMismatch;
    } else {
        std.debug.print("Strings match successfully!\n", .{});
    }
    //try std.testing.expectEqual(record_data, retrieved_data);
    // std.debug.print("retrieved data {any} vs the record data {any}", .{ retrieved_data, record_data });

}
