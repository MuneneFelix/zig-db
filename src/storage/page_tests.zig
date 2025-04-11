const std = @import("std");
const Page = @import("page.zig").Page;
const DeleteRecordError = error{
    AlreadyDeleted,
    InvalidRecord,
    InvalidOffset,
};
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
