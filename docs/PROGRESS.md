# Progress Document

## **Project Overview**
- **Project**: Custom database implementation in Zig.
- **Goal**: Build a performant, memory-safe, and ACID-compliant database engine.
- **Current Phase**: Core Functionality.

---

## **Progress Summary**

### **Phase 1: Core Functionality**
- **Completed**:
  - Implemented `Page` structure with:
    - `init` and `deinit` for memory allocation and cleanup.
    - `insertRecord` for adding records to a page.
    - `deleteRecord` for marking records as deleted.
  - Defined `PageHeader`, `Record`, and `RecordHeader` structures.
  - Added serialization and deserialization for `Record`.
  - Implemented error handling for invalid page IDs, out-of-memory conditions, and invalid offsets.
  - Established fixed-size pages (e.g., 4KB) for efficient memory management.

- **In Progress**:
  - Finalizing helper functions:
    - `getRecord` for retrieving records by offset.
    - `hasEnoughSpace` for checking available space.
    - `isValidRecordSize` for validating record sizes.
  - Writing unit tests for:
    - `Page.init` and `Page.deinit`.
    - `Page.insertRecord` and `Page.deleteRecord`.
    - `Record.serialize` and `Record.deserialize`.

- **Next Tasks**:
  1. Complete the `getRecord` function to validate offsets and handle deleted records.
  2. Implement and test `hasEnoughSpace` and `isValidRecordSize`.
  3. Write unit tests for all completed functions in the `Page` and `Record` structures.

---

### **Phase 2: Persistence**
- **Planned**:
  - Implement disk I/O for saving and loading pages.
  - Add checksum validation for data integrity.
- **Next Tasks**:
  1. Design the `Page.saveToDisk` and `Page.loadFromDisk` functions.
  2. Research and plan checksum validation for persisted data.

---

### **Phase 3: Garbage Collection**
- **Planned**:
  - Implement a compaction mechanism to reclaim space from deleted records.
- **Next Tasks**:
  1. Design the `Page.compact` function.
  2. Plan a garbage collection strategy for periodic compaction.

---

### **Phase 4: Indexing**
- **Planned**:
  - Design and implement indexing (e.g., B-trees or hash indexes) for efficient lookups.
- **Next Tasks**:
  1. Research indexing strategies suitable for your database.
  2. Draft a design for integrating indexes with the `Page` structure.

---

### **Phase 5: Transactions and ACID Compliance**
- **Planned**:
  - Add transaction support with commit and rollback functionality.
  - Implement a write-ahead logging (WAL) mechanism for crash recovery.
- **Next Tasks**:
  1. Research transaction models (e.g., MVCC or locking).
  2. Plan the structure of the WAL.

---

### **Phase 6: Concurrency**
- **Planned**:
  - Add thread safety and support for concurrent transactions.
- **Next Tasks**:
  1. Research concurrency models (e.g., locks, atomic operations, or MVCC).
  2. Plan thread-safe access to pages and records.

---

### **Phase 7: Optimization and Finalization**
- **Planned**:
  - Profile and optimize memory usage and disk I/O.
  - Write comprehensive documentation for the database.
- **Next Tasks**:
  1. Identify potential performance bottlenecks during earlier phases.
  2. Plan documentation structure for the final release.

---

## **Immediate Next Steps**
1. **Complete Phase 1**:
   - Finalize and test `getRecord`, `hasEnoughSpace`, and `isValidRecordSize`.
   - Write unit tests for all core functions.
2. **Prepare for Phase 2**:
   - Design disk I/O functions (`saveToDisk` and `loadFromDisk`).
   - Research checksum validation techniques.

---