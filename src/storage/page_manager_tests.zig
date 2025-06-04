const std = @import("std");
const PageManager = @import("page_manager.zig").PageManager;

const PageError = error{
    InvalidPageId,
    PageNotFound,
    InvalidPageSize,
    ChecksumMismatch,
};

test "loadPage loads a valid page" {
    //steps
    //1. init page manager
    //2. create a page
    //3. insert a record into page
    //4. save the page
    //5. deinitialize page manager
    //6. reinitialize page manager then call load page with saved page id
    //7. validate that the loaded record contains the same data as before
    const allocator = std.testing.allocator;
    var page_manager = try PageManager.init(allocator);
    errdefer page_manager.deinit();
    const page_id = try page_manager.createPage();
    const page = try page_manager.getPage(page_id);
    //std.debug.print("Page information {any} ", .{page});
    const record_data = "Hello World!!";
    const record_offset = try page.insertRecord(record_data);
    //std.debug.print("print record offset information {d}", .{record_offset});
    try page_manager.savePage();
    page_manager.deinit();
    page_manager = try PageManager.init(allocator);
    errdefer page_manager.deinit();
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
    }
}
test "savePage saves a page to disk" {
    // Goal: Ensure that savePage writes a page to disk correctly.
    // Steps:
    // Initialize a PageManager.
    // Create a page and insert a record.
    // Call savePage to save the page to disk.
    // Optionally, validate that the file exists or contains the expected data .
    // Ensure no errors are returned during the save operation.
}

test "deletePage deletes a valid page" {
    // Goal: Ensure that deletePage removes a page from memory and prevents further access.
    // Steps:
    // Initialize a PageManager.
    // Create a page and retrieve its ID.
    // Call deletePage with the page's ID.
    // Attempt to retrieve the deleted page using getPage and ensure it returns an error (e.g., PageError.PageNotFound).
}
test "createPage created a valid page" {
    // Goal: Ensure that createPage initializes a new page correctly.
    // Steps:
    // Initialize a PageManager.
    // Call createPage to create a new page and retrieve its ID.
    // Retrieve the page using getPage and validate its metadata:
    // free_space_offset should equal the page's data size.
    // record_count should be 0.
}
test "getPage returns  a valid page" {
    // Goal: Ensure that getPage retrieves a page by its ID, whether it is in memory or loaded from disk.
    // Steps:
    // Initialize a PageManager.
    // Create a page and retrieve its ID.
    // Retrieve the page using getPage and validate its metadata.
    // Optionally, save the page to disk, deinitialize the PageManager, and reinitialize it to test loading the page from disk.
}
test "validate page manager initialization" {}
