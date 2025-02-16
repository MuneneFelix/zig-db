# Database Implementation Lessons

## Part 1: Storage Engine Basics
Starting from our current TodoApp file I/O:

### Lesson 1: From Files to Pages
Current:
- Simple file serialization
- Line-based storage
- Direct file I/O

Goals:
- [ ] Implement page-based storage
- [ ] Add page headers
- [ ] Create page manager

### Lesson 2: Buffer Management
Current:
- Direct memory allocation
- Basic array management

Goals:
- [ ] Implement buffer pool
- [ ] Add page replacement (LRU)
- [ ] Handle dirty pages

### Lesson 3: Record Storage
Current:
- Fixed Todo structure
- String-based serialization

Goals:
- [ ] Variable-length records
- [ ] Record headers
- [ ] Slotted pages

## Part 2: Tree Structures & Indexing
Current:
- Linear array storage
- Sequential search

### Lesson 4: B-tree Basics
Goals:
- [ ] B-tree node structure
- [ ] Basic operations
- [ ] Page splits/merges

### Lesson 5: Index Management
Goals:
- [ ] Primary index (ID)
- [ ] Secondary indexes
- [ ] Index maintenance

## Part 3: Transaction Processing
Current:
- Single operation atomicity
- No recovery mechanism

### Lesson 6: ACID Properties
Goals:
- [ ] Transaction boundaries
- [ ] Rollback support
- [ ] Durability guarantees

### Lesson 7: Write-Ahead Logging
Goals:
- [ ] WAL implementation
- [ ] Recovery protocol
- [ ] Checkpoint mechanism

## Part 4: Query Processing
Current:
- Basic CRUD operations
- Simple filtering

### Lesson 8: Query Execution
Goals:
- [ ] Query planning
- [ ] Join operations
- [ ] Optimization basics

## Learning Approach
1. Each lesson will:
   - Explain theory
   - Show current limitations
   - Implement improvements
   - Include exercises

2. We'll evolve the TodoApp to use:
   - Page-based storage
   - Proper indexing
   - Transaction support
   - Query optimization

+-------------------+
|   Fusion Database |
+-------------------+
        |
        v
+-------------------+     +-------------------+
|   Disk Storage    |     |   In-Memory Cache |
+-------------------+     +-------------------+
| - PageManager     |     | - Key-Value Store |
| - B-Tree Index    |     | - Expiry Manager  |
| - WAL (Logging)   |     | - Pub/Sub System  |
+-------------------+     +-------------------+
        |                         |
        v                         v
+-------------------+     +-------------------+
|   Page            |     |   Cache Entry     |
+-------------------+     +-------------------+
| - PageHeader      |     | - Key             |
| - Data Buffer     |     | - Value           |
+-------------------+     +-------------------+
        |                         |
        v                         v
+-------------------+     +-------------------+
|   Record          |     |   Expiry Timer    |
+-------------------+     +-------------------+
| - Fields          |     | - Expiry Time     |
| - Offsets         |     | - Callback        |
+-------------------+     +-------------------+

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