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
    const page_id = try page_manager.createPage();
    const page = try page_manager.getPage(page_id);
    const record_data = "Hello World!!";
    const record_offset = try page.insertRecord(record_data);

    try page_manager.savePage();

    try page_manager.deinit();

    page_manager = try PageManager.init(allocator);
    const page_loaded = page_manager.loadPage(page_id);
    //const page_loaded = try page_manager.getPage(page_id);

    const retrieved_data = try page_loaded.getRecord(record_offset);
    std.testing.expectEqual(record_data, retrieved_data);
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
