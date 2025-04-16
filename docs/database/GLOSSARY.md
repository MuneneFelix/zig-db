# Database Concepts Glossary

## A
- **ACID**: Atomicity, Consistency, Isolation, Durability
- **Atomicity**: All or nothing property of transactions

## B
- **Buffer Pool**: Memory area that holds database pages
- **B-tree**: Self-balancing tree data structure

## C
- **Concurrency Control**: Managing simultaneous access to data
- **Checkpoint**: Synchronization point between memory and disk

## D
- **Durability**: Persistence of committed transactions
- **Dead Lock**: Circular wait condition between transactions

## I
- **Index**: Data structure to speed up data retrieval
- **Isolation**: Transaction separation property

## L
- **LSN**: Log Sequence Number
- **Latch**: Short-term lock for physical operations


## P
- **Page**: Basic unit of storage in databases.
- **PageManager**: Component responsible for managing pages in memory and on disk.
  - Tracks pages using a hashmap.
  - Provides disk I/O functionality for persistence.
  - Handles page creation, deletion, and retrieval.

## T
- **Transaction**: Unit of work in a database
- **Two-Phase Commit**: Distributed transaction protocol

## W
- **WAL**: Write-Ahead Logging
- **Working Set**: Frequently accessed pages 

+-------------------+
|   Database System |
+-------------------+
        |
        v
+-------------------+
|   PageManager     |  <--- Manages pages in memory and on disk
+-------------------+
| - pages: HashMap  |  <--- Stores pages by ID
| - next_page_id    |  <--- Tracks next available page ID
| - allocator       |  <--- Memory allocator
+-------------------+
| + init()          |  <--- Initializes the manager
| + getPage()       |  <--- Retrieves a page by ID
| + createPage()    |  <--- Creates a new page
| + deletePage()    |  <--- Deletes a page
| + savePage()      |  <--- Saves a page to disk
| + loadPage()      |  <--- Loads a page from disk
| + deinit()        |  <--- Cleans up resources
+-------------------+
        |
        v
+-------------------+
|       Page        |  <--- Represents a single page
+-------------------+
| - header: PageHeader |  <--- Metadata for the page
| - data: []u8         |  <--- Data buffer
| - allocator          |  <--- Memory allocator
+-------------------+
| + init()          |  <--- Initializes the page
| + deinit()        |  <--- Cleans up resources
| + insertRecord()  |  <--- Inserts a record
| + deleteRecord()  |  <--- Deletes a record
| + getRecord()     |  <--- Retrieves a record
+-------------------+
        |
        v
+-------------------+
|   PageHeader      |  <--- Metadata for a page
+-------------------+
| - page_id         |  <--- Unique identifier
| - next_page       |  <--- Link to next page
| - free_space_offset |  <--- Pointer to free space
| - record_count    |  <--- Number of records
| - checksum        |  <--- Data integrity check
| - flags           |  <--- Page state
+-------------------+ 

# Fusion Database Learning Path

## Part 1: Disk Storage
- [ ] Implement PageManager
- [ ] Develop B-Tree Index
- [ ] Set Up WAL

## Part 2: In-Memory Cache
- [ ] Build Key-Value Store
- [ ] Create Expiry Manager
- [ ] Develop Pub/Sub System

## Part 3: Shared Components
- [ ] Design Transaction Manager
- [ ] Implement Query Processor

## Learning Approach
1. Each part will:
   - Explain theory
   - Show current limitations
   - Implement improvements
   - Include exercises 