# Database Concepts References

This document provides references to academic papers, books, and online resources for the core concepts implemented in zig-db.

## Core Concepts

### 1. Page & Record Management
- **Slotted Page Architecture**
  - Book: "Database Management Systems" (3rd Ed.) by Ramakrishnan and Gehrke
    - Chapter 9: Storage and File Structure
  - Paper: "The Design and Implementation of Modern Column-Oriented Database Systems" (2012)
    - Section 3: Storage Models and Compression

### 2. Buffer Management
- **Buffer Pool & Page Replacement**
  - Paper: "The Design of the POSTGRES Storage System" by Michael Stonebraker
  - Book: "Transaction Processing: Concepts and Techniques" by Jim Gray
    - Chapter 7: Buffer Management
  - Paper: "An Analysis of Buffer Management Strategies in DBMS" - ACM SIGMOD

### 3. Memory Management
- **Dynamic Memory Allocation**
  - Book: "Advanced Programming in the UNIX Environment"
    - Chapter 7: Memory Allocation
  - Paper: "Memory Management in Database Systems" - ACM Computing Surveys

### 4. File Organization
- **Page-based Storage**
  - Book: "Database System Concepts" (6th Ed.) by Silberschatz, Korth, and Sudarshan
    - Chapter 10: Storage and File Structure
  - Paper: "The Design and Implementation of Modern Column-Oriented Database Systems"

## Future Implementation References

### 1. B-tree Indexing
- Paper: "The Ubiquitous B-Tree" by Douglas Comer
- Book: "Database Management Systems" 
  - Chapter 12: Indexing and Hashing

### 2. Transaction Management
- Paper: "ARIES: A Transaction Recovery Method" by C. Mohan
- Book: "Principles of Transaction Processing" by Philip Bernstein
  - Chapter 7: Recovery

### 3. Page Compaction & Garbage Collection
- Paper: "On Garbage Collection in Log-Structured File Systems"
- Book: "The Art of Computer Programming, Volume 1" by Donald Knuth
  - Section 2.5: Dynamic Storage Allocation

## Online Resources

1. [CMU Database Group Papers](https://db.cs.cmu.edu/papers/)
2. [MIT OpenCourseWare - Database Systems](https://ocw.mit.edu/courses/6-830-database-systems-fall-2010/)
3. [Berkeley CS186 Database Systems](https://cs186berkeley.net/)

## Blogs and Articles

1. [System Design - Databases](https://github.com/donnemartin/system-design-primer#database)
2. [The Internals of PostgreSQL](https://www.interdb.jp/pg/)
3. [SQLite Database System Design](https://www.sqlite.org/arch.html)

## Implementation Examples

1. [SQLite Source Code](https://github.com/sqlite/sqlite)
2. [LevelDB Design](https://github.com/google/leveldb/blob/main/doc/impl.md)
3. [PostgreSQL Buffer Manager Implementation](https://github.com/postgres/postgres/tree/master/src/backend/storage/buffer)

## Related Research Papers

1. "Architecture of a Database System" by Joseph M. Hellerstein, Michael Stonebraker
2. "The Five-Minute Rule Twenty Years Later" by Goetz Graefe
3. "Making B+ Trees Cache Conscious in Main Memory" by Jun Rao, Kenneth A. Ross

## Best Practices and Design Patterns

1. "Patterns of Enterprise Application Architecture" by Martin Fowler
   - Chapter: Database Patterns
2. "Database Design Best Practices" - Oracle Documentation
3. "PostgreSQL Performance Best Practices" - EnterpriseDB