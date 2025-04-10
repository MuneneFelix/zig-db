# Database Project Roadmap

## **Phase 1: Core Functionality (Current Phase)**
### Goals:
- Finalize the `Page` and `Record` structures.
- Ensure robust memory management and error handling.

### Tasks:
1. Complete the `getRecord` function in `Page` to validate offsets and handle deleted records.
2. Add helper functions for checking available space (`hasEnoughSpace`) and validating record sizes (`isValidRecordSize`).
3. Write unit tests for:
   - `Page.init` and `Page.deinit`.
   - `Page.insertRecord` and `Page.deleteRecord`.
   - `Record.serialize` and `Record.deserialize`.

---

## **Phase 2: Persistence**
### Goals:
- Enable saving pages to disk and loading them back into memory.

### Tasks:
1. Implement a `Page.saveToDisk` function to write a page to a file.
2. Implement a `Page.loadFromDisk` function to read a page from a file.
3. Add checksum validation to ensure data integrity during persistence.
4. Write tests for disk I/O operations.

---

## **Phase 3: Garbage Collection**
### Goals:
- Reclaim space from deleted records and compact pages.

### Tasks:
1. Implement a `Page.compact` function to remove tombstoned records and defragment the page.
2. Add a garbage collection mechanism to periodically compact pages.
3. Write tests to verify the correctness of the compaction process.

---

## **Phase 4: Indexing**
### Goals:
- Improve data retrieval performance with indexing.

### Tasks:
1. Design and implement a B-tree or hash index structure.
2. Integrate the index with the `Page` structure to support indexed lookups.
3. Write tests for index creation, updates, and lookups.

---

## **Phase 5: Transactions and ACID Compliance**
### Goals:
- Ensure atomicity, consistency, isolation, and durability.

### Tasks:
1. Implement a write-ahead logging (WAL) mechanism for crash recovery.
2. Add transaction support with commit and rollback functionality.
3. Write tests for transaction scenarios (e.g., concurrent transactions, crash recovery).

---

## **Phase 6: Concurrency**
### Goals:
- Support concurrent access to pages and records.

### Tasks:
1. Add thread safety to the `Page` structure using locks or atomic operations.
2. Implement a mechanism for concurrent transactions (e.g., MVCC or locking).
3. Write stress tests to evaluate performance under concurrent access.

---

## **Phase 7: Optimization and Finalization**
### Goals:
- Optimize performance and finalize the database implementation.

### Tasks:
1. Profile the database to identify bottlenecks.
2. Optimize memory usage and disk I/O operations.
3. Write comprehensive documentation for the database.
4. Prepare a release version with examples and usage guides.

---

## **Milestones**
1. **Milestone 1**: Core functionality completed and tested.
2. **Milestone 2**: Persistence implemented with disk I/O tests.
3. **Milestone 3**: Garbage collection and compaction working.
4. **Milestone 4**: Indexing integrated and tested.
5. **Milestone 5**: Transactions and ACID compliance achieved.
6. **Milestone 6**: Concurrency support added.
7. **Milestone 7**: Final optimization and release.

---

## **Notes**
- Prioritize memory safety and error handling at every phase.
- Write tests for all new features before moving to the next phase.
- Document complex logic to ensure maintainability.
