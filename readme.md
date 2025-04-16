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
Error Handling:

Comprehensive error sets for operations (DeleteRecordError, PageInitErrors).
Validation for invalid offsets, corrupted records, and out-of-memory conditions.
Testing:

Unit tests for Page and PageManager components.
Validation of edge cases, such as invalid offsets and oversized records.
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

Ensures free_space_offset is updated correctly after insertions and deletions.
Next Steps
1. PageManager Implementation
Develop the PageManager component to handle multiple pages.
Implement page allocation, deallocation, and garbage collection.
2. Advanced Features
Add support for record compaction and garbage collection.
Implement checksums for record integrity validation.
3. Performance Testing
Benchmark insertion, retrieval, and deletion operations.
Optimize memory usage and access patterns.
4. Documentation
Expand documentation for each module (Page, PageManager, etc.).
Add usage examples and API references.
5. Integration Testing
Test interactions between Page and PageManager.
Simulate real-world scenarios with multiple pages and concurrent operations.
How to Run Tests
To run the tests, use the Zig test runner:

Contributors
Felix Munene: Core development and testing.
