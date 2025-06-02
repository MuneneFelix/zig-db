const std = @import("std");
const testing = std.testing;

//storage tests
//1. Page Manager tests
const PageManager = @import("storage/page_manager.zig").PageManager;

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

    var page_manager = PageManager.init(allocator);
    const page_id = try page_manager.createPage();
    const page = try page_manager.getPage(page_id);
    const record_data = "Hello World!!";
    const record_offset = try page.insertRecord(record_data);

    try page_manager.savePage();

    try page_manager.deinit();

    page_manager = PageManager.init(allocator);
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

//2. page tests
const Page = @import("storage/page.zig").Page;
const Page_Module = @import("storage/page.zig");
const DeleteRecordError = error{
    AlreadyDeleted,
    InvalidRecord,
    InvalidOffset,
};
const PageInitErrors = error{ OutOfMemory, InvalidPageId, AllocationError, InvalidRecordSize };
test "getRecord retrieved a valid record" {
    const allocator = std.testing.allocator;

    //1. initialize a Page

    var page = try Page.init(allocator, 1);

    //2. Insert a record
    const record_data = "Hello, World";
    const offset = try page.insertRecord(record_data);
    //3. retrieve the record
    const retrieved_data = try page.getRecord(offset);
    //4. Assert that the retrieved data matches the inserted data
    try std.testing.expectEqualStrings(record_data, retrieved_data);

    //5. Cleanup
    page.deinit();
}
test "deleteRecord deletes a valid record" {
    const allocator = std.testing.allocator;

    //1. initialize a Page

    var page = try Page.init(allocator, 1);

    //2. Insert a record
    const record_data = "Hello, World";
    const offset = try page.insertRecord(record_data);
    //3. delete the record
    try page.deleteRecord(offset);

    //4. attempt to get record and expect an error

    try std.testing.expectError(DeleteRecordError.AlreadyDeleted, page.getRecord(offset));

    //5. clean up memory
    page.deinit();
}

test "insertRecord inserts several valid records" {
    const allocator = std.testing.allocator;

    //1. initialize a Page

    var page = try Page.init(allocator, 1);

    //2. Insert a record
    const record_data = "Hello, World";
    const record_data1 = "Second Record is Longer and Complex";
    const offset = try page.insertRecord(record_data);
    const offset2 = try page.insertRecord(record_data1);
    //3. retrieve the record
    const retrieved_data = try page.getRecord(offset);
    const retrieved_data1 = try page.getRecord(offset2);
    //4. Assert that the retrieved data matches the inserted data
    try std.testing.expectEqualStrings(record_data, retrieved_data);
    try std.testing.expectEqualStrings(record_data1, retrieved_data1);
    //5. Cleanup
    page.deinit();
}

test "getRecord with invalid offset within data range" {
    const allocator = std.testing.allocator;

    //1. initialize a Page

    var page = try Page.init(allocator, 1);

    //2. Insert a record
    const record_data = "Hello, World";

    const offset = try page.insertRecord(record_data);

    //assert error
    try std.testing.expectError(DeleteRecordError.InvalidOffset, page.getRecord(offset + 1));
    //cleanup
    page.deinit();
}

test "getRecord with invalid offset outside data range" {
    const allocator = std.testing.allocator;

    //1. initialize a Page

    var page = try Page.init(allocator, 1);
    try std.testing.expectError(DeleteRecordError.InvalidOffset, page.getRecord(4097));

    //cleanup
    page.deinit();
}

test "insertRecord with record exceeding valid data size" {
    const allocator = std.testing.allocator;

    // 1. Initialize a Page
    var page = try Page.init(allocator, 1);

    // 2. Create a record larger than the page capacity
    const repeated_string = "Hello, World";
    var slices: [1000][]const u8 = undefined;
    for (&slices) |*slice| {
        slice.* = repeated_string;
    }
    const record_data = try std.mem.concat(allocator, u8, &slices);

    // 3. Attempt to insert the record and expect an error
    try std.testing.expectError(PageInitErrors.InvalidRecordSize, page.insertRecord(record_data));

    // 4. Free the memory
    allocator.free(record_data);

    // 5. Cleanup
    page.deinit();
}
test "insertRecord with record exceeding page size" {
    const allocator = std.testing.allocator;

    // 1. Initialize a Page
    var page = try Page.init(allocator, 1);

    // 2. Create a record larger than the page capacity
    const repeated_string = "Hello, World";
    //3 insert record until page remains smaller
    while (page.header.free_space_offset > repeated_string.len) {
        //insert into page
        _ = try page.insertRecord(repeated_string);
    }
    // 3. Attempt to insert the record and expect an error
    try std.testing.expectError(PageInitErrors.OutOfMemory, page.insertRecord(repeated_string));

    // 5. Cleanup
    page.deinit();
}
test "getRecord retriving a corrupted record" {
    //a corrupted record has a bad offset
    const allocator = std.testing.allocator;

    // 1. Initialize a Page
    var page = try Page.init(allocator, 1);

    // 2. Create a record larger than the page capacity
    const repeated_string = "Hello, World";
    var offset: u16 = 0;
    while (page.header.free_space_offset > repeated_string.len) {
        //insert into page
        offset = try page.insertRecord(repeated_string);
    }
    //std.debug.print("\n valid offset {any} \n", .{offset});
    offset = offset + 3;
    try std.testing.expectError(DeleteRecordError.InvalidRecord, try page.getRecord(offset + 1));
    //cleaunp memory
    page.deinit();
}
test "deleteRecord deletes multiple records" {
    const allocator = std.testing.allocator;

    //1. initialize a Page

    var page = try Page.init(allocator, 1);

    //2. Insert a record
    const record_data = "Hello, World";
    const record_data1 = "Second Record is Longer and Complex";
    const offset = try page.insertRecord(record_data);
    const offset2 = try page.insertRecord(record_data1);

    try page.deleteRecord(offset);
    try page.deleteRecord(offset2);

    page.deinit();
}

test "validate page initialization" {
    const allocator = std.testing.allocator;

    // 1. Initialize a Page
    var page = try Page.init(allocator, 1);

    // 2. Assert that `free_space_offset` is set to `DATA_SIZE`
    const data_size: u16 = @intCast(Page_Module.DATA_SIZE);
    try std.testing.expectEqual(data_size, page.header.free_space_offset);

    // 3. Assert that `record_count` is 0
    try std.testing.expectEqual(0, page.header.record_count);

    // 4. Cleanup
    page.deinit();
}
test "validate free_space_offset" {
    const allocator = std.testing.allocator;

    // 1. Initialize a Page
    var page = try Page.init(allocator, 1);

    // 2. Insert a record and check `free_space_offset`
    const record_data = "Hello, World";
    const initial_offset = page.header.free_space_offset;
    const offset = try page.insertRecord(record_data);
    try std.testing.expectEqual(initial_offset - (@sizeOf(Page_Module.RecordHeader) + record_data.len), page.header.free_space_offset);

    // 3. Delete the record and ensure `free_space_offset` does not increase
    try page.deleteRecord(offset);
    try std.testing.expectEqual(initial_offset - (@sizeOf(Page_Module.RecordHeader) + record_data.len), page.header.free_space_offset);

    // 4. Cleanup
    page.deinit();
}
test "edge cases for getRecord" {
    const allocator = std.testing.allocator;

    // 1. Initialize a Page
    var page = try Page.init(allocator, 1);

    // 2. Attempt to retrieve a record when the page is empty
    try std.testing.expectError(DeleteRecordError.InvalidOffset, page.getRecord(0));

    // 3. Insert a record and retrieve it
    const record_data = "Hello, World";
    const offset = try page.insertRecord(record_data);
    const retrieved_data = try page.getRecord(offset);
    try std.testing.expectEqualStrings(record_data, retrieved_data);

    // 4. Attempt to retrieve a record at the maximum valid offset
    const max_offset = page.header.free_space_offset - 1;
    try std.testing.expectError(DeleteRecordError.InvalidOffset, page.getRecord(max_offset));

    // 5. Cleanup
    page.deinit();
}
