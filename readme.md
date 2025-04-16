Zig-DB
Overview
Zig-DB is a lightweight database implementation written in Zig. It provides efficient storage and retrieval of records using a page-based storage system. The project is designed to be modular, with components such as Page, PageManager, and RecordHeader handling specific responsibilities.

Progress
1. Core Features Implemented
Page Management:

Insert, retrieve, and delete records within a page.
Tombstone-based deletion with optional garbage collection.
Validation of record sizes and offsets.
Metadata tracking (free_space_offset, record_count).
PageManager:

Manages multiple pages in memory and on disk.
Supports creating, deleting, saving, and loading pages.
Uses a std.AutoHashMap to store pages by their IDs.
Implements disk persistence with savePage and loadPage functions.
Error Handling:

Comprehensive error sets for operations (DeleteRecordError, PageInitErrors, PageError).
Validation for invalid offsets, corrupted records, and out-of-memory conditions.
Testing:

Unit tests for Page and PageManager components.
Validation of edge cases, such as invalid offsets and oversized records.
PageManager Implementation
The PageManager is responsible for managing multiple pages in memory and on disk. It provides the following functionality:

Key Functions
init:

Initializes the PageManager with an allocator and sets up the pages hashmap and next_page_id.
deinit:

Frees all resources, including clearing and deallocating the pages hashmap.
getPage:

Retrieves a page by its ID.
If the page is not in memory, it attempts to load it from disk.
createPage:

Creates a new page, initializes it, and stores it in the pages hashmap.
Returns the ID of the newly created page.
deletePage:

Deletes a page by its ID.
Deallocates the memory associated with the page.
savePage:

Saves all pages in memory to a file (pages.dat).
Writes both the page header and data to disk.
loadPage:

Loads a page from disk into memory.
Deserializes the page header and data, and stores the page in the pages hashmap.
Tests Implemented
Page Tests
Insert and Retrieve Records:

Validates that records can be inserted and retrieved correctly.
Ensures data integrity after retrieval.
Delete Records:

Tests deletion of single and multiple records.
Ensures deleted records cannot be retrieved.
Invalid Offset Handling:

Tests getRecord with invalid offsets (both within and outside the data range).
Ensures proper error handling for invalid offsets.
Oversized Record Handling:

Tests insertion of records exceeding the page capacity.
Ensures PageInitErrors.InvalidRecordSize is returned.
Edge Cases for getRecord:

Tests retrieval from an empty page.
Tests retrieval at the maximum valid offset.
Page Initialization:

Validates that a Page is initialized with correct metadata (free_space_offset, record_count).
hasEnoughSpace Validation:

Ensures hasEnoughSpace correctly determines if there is enough space for a new record.
isValidRecordSize Validation:

Tests validation of record sizes, including zero-sized and oversized records.
free_space_offset Behavior:

Ensures that free_space_offset is updated correctly after insertions and deletions.
PageManager Tests
Create and Retrieve Pages:

Validates that pages can be created and retrieved by their IDs.
Ensures that newly created pages are initialized correctly.
Delete Pages:

Tests deletion of pages by their IDs.
Ensures that deleted pages are removed from memory and their resources are deallocated.
Save and Load Pages:

Validates that pages can be saved to disk and loaded back into memory.
Ensures data integrity after saving and loading.
Handle Missing Pages:

Tests getPage with invalid or non-existent page IDs.
Ensures that PageError.PageNotFound is returned.
Next Steps
1. Advanced Features
Add support for record compaction and garbage collection.
Implement checksums for record integrity validation.
2. Performance Testing
Benchmark insertion, retrieval, and deletion operations.
Optimize memory usage and access patterns.
3. Documentation
Expand documentation for each module (Page, PageManager, etc.).
Add usage examples and API references.
4. Integration Testing
Test interactions between Page and PageManager.
Simulate real-world scenarios with multiple pages and concurrent operations.
How to Run Tests
To run the tests, use the Zig test runner:
zig test src/storage/page_tests.zig
zig test src/storage/page_manager_tests.zig
Contributors
[Felix Munene]: Core development and testing.
