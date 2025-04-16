# Storage Engine Fundamentals

## Overview
The storage engine is responsible for managing data on disk and in memory. It organizes data into pages and provides efficient mechanisms for accessing, modifying, and persisting data.

---

## Key Concepts
1. Disk-based Storage
   - Page organization
   - Sector alignment
   - Block management

2. Memory Hierarchy
   - Cache levels
   - Memory-disk interaction
   - Access patterns

3. File Organization
   - Heap files
   - Sequential files
   - Indexed files

---

## Deep Dive Topics
### Page Layout
- Header structure
- Record placement
- Free space management

### PageManager
- Manages multiple pages in memory and on disk.
- Uses `std.AutoHashMap` to store pages by ID.
- Provides disk I/O functionality for saving and loading pages.

---

## Common Challenges
1. Fragmentation
2. I/O optimization
3. Space efficiency