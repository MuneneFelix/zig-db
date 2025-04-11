const std = @import("std");
const Page = @import("page.zig").Page;

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
test "deleteRecord deletes a valid record" {}
