const std = @import("std");
const PageManager = @import("storage/page_manager.zig").PageManager;

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    // Initialize the PageManager
    var page_manager = PageManager.init(allocator);
    defer page_manager.deinit();

    // Create a new page
    const page_id = try page_manager.createPage();
    std.debug.print("Created page with ID: {}\n", .{page_id});

    // Perform operations on the page
    // Example: Write data to the page, read it back, etc.

    // Flush any buffered data
    //try page_manager.flush();
}

test "storage engine integration test" {
    const allocator = std.testing.allocator;

    // Initialize the PageManager
    var page_manager = PageManager.init(allocator);
    defer page_manager.deinit();

    // Test creating a page
    const page_id = try page_manager.createPage();
    try std.testing.expect(page_id != 0);

    // Additional tests for reading/writing data
}
