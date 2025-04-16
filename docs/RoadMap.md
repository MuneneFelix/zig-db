# Database Project Roadmap

## **Phase 1: Core Functionality (Completed)**
### Goals:
- Implement page-based storage.
- Add page headers and metadata tracking.
- Create a `Page` structure with insert, delete, and retrieve operations.

### Status:
- ✅ Completed.

---

## **Phase 2: Persistence (Ongoing)**
### Goals:
- Implement `PageManager` to manage multiple pages in memory and on disk.
- Add disk I/O functionality for saving and loading pages.
- Write tests for persistence and data integrity.

### Status:
- `PageManager` implemented with basic functionality.
- Disk I/O functions (`savePage` and `loadPage`) under development.

---

## **Phase 3: Garbage Collection**
### Goals:
- Reclaim space from deleted records and compact pages.

### Tasks:
1. Implement a `Page.compact` function to remove tombstoned records and defragment the page.
2. Add a garbage collection mechanism to periodically compact pages.
3. Write tests to verify the correctness of the compaction process.

---

## **Milestones**
1. **Milestone 1**: Core functionality completed and tested. ✅
2. **Milestone 2**: Persistence implemented with disk I/O tests. (In Progress)
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