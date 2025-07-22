# Database Concepts Glossary

## Currently Implemented

### Record Management
- **Record**: Smallest unit of data storage, consisting of a header and payload
- **Record Header**: Metadata structure containing size, offset, and deletion status
- **Tombstone**: A marker indicating a deleted record without physically removing it
- **Variable-Length Records**: Records that can store different amounts of data

### Page Management
- **Page**: Fixed-size block of memory (4KB) containing multiple records
- **Page Header**: Metadata structure tracking page state (free space, record count, etc.)
- **Free Space Offset**: Pointer to the next available space in a page
- **Page Alignment**: Memory alignment requirements for efficient access

### Buffer Management
- **Buffer Pool**: In-memory cache of disk pages
- **Page Table**: HashMap mapping page IDs to memory locations
- **Dirty Page**: A page that has been modified but not yet written to disk
- **Page Eviction**: Process of removing a page from memory to make room for others

### File Organization
- **Page-Based Storage**: Organizing disk storage as fixed-size pages
- **File Format**: On-disk structure of pages and their metadata
- **Page Offset**: Location of a page in the data file (page_id * PAGE_SIZE)

## To Be Implemented

### B-tree Index
- **B-tree**: Self-balancing tree structure for efficient data access
- **Node**: Basic unit of B-tree containing keys and pointers
- **Split Operation**: Dividing a full node into two
- **Merge Operation**: Combining two under-utilized nodes

### Transaction Management
- **Transaction**: Atomic unit of work that maintains database consistency
- **ACID**: Atomicity, Consistency, Isolation, Durability
- **Write-Ahead Logging (WAL)**: Recording changes before applying them
- **Recovery**: Process of restoring database state after failure

### Page Compaction
- **Fragmentation**: Inefficient space usage due to deleted records
- **Compaction**: Reorganizing pages to reclaim fragmented space
- **Garbage Collection**: Process of reclaiming space from deleted records
- **Page Split**: Creating a new page when current page is full

### Memory Management
- **Allocation**: Process of reserving memory for database objects
- **Deallocation**: Returning memory to the system
- **Memory Leak**: Failure to properly free allocated memory
- **Double Free**: Attempting to free already freed memory

## Design Patterns

### Currently Used
- **RAII (Resource Acquisition Is Initialization)**: Managing resources through initialization
- **Factory Method**: Creating objects without specifying exact class
- **Iterator**: Accessing elements sequentially without exposing underlying structure

### To Be Implemented
- **Observer**: Notifying components of state changes
- **Strategy**: Selecting algorithms at runtime
- **Command**: Encapsulating database operations as objects