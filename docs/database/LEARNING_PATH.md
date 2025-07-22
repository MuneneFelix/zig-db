# Database Engineering Learning Path

This document provides a structured path to understand both the theoretical concepts and their implementation in our codebase.

## 1. Foundational Concepts (Week 1-2)

### Memory & Storage
1. Read: "Advanced Programming in the UNIX Environment" Ch.7
2. Study: [`src/storage/page.zig`](src/storage/page.zig) implementation
3. Practice: Implement a simple record manager

### Data Structures
1. Study: HashMaps and B-trees fundamentals
2. Review: Our HashMap usage in PageManager
3. Practice: Implement a basic B-tree (preparation for indexing)

## 2. Page Management (Week 3-4)

### Basic Concepts
1. Read: "Database Management Systems" Ch.9
2. Study: [`src/storage/page_manager.zig`](src/storage/page_manager.zig)
3. Practice: Add features to PageManager

### Advanced Topics
1. Study: Buffer pool management
2. Read: "The Design of the POSTGRES Storage System"
3. Practice: Implement page replacement strategies

## 3. File Organization (Week 5-6)

### Storage Engine
1. Read: "Database System Concepts" Ch.10
2. Study: Our page-based storage implementation
3. Practice: Enhance file I/O operations

### Data Integrity
1. Study: Checksums and error detection
2. Review: Our page validation methods
3. Practice: Implement recovery mechanisms

## 4. Advanced Topics (Week 7-8)

### Transaction Management
1. Read: "ARIES: A Transaction Recovery Method"
2. Study: ACID properties implementation
3. Practice: Implement basic transaction support

### Indexing
1. Read: "The Ubiquitous B-Tree"
2. Study: B-tree implementation techniques
3. Practice: Start implementing B-tree index

## Practical Exercises

### Week 1-2
- Modify record layout
- Add record compression
- Implement record iteration

### Week 3-4
- Add page compression
- Implement page splitting
- Add buffer pool management

### Week 5-6
- Enhance file format
- Add page recovery
- Implement WAL

### Week 7-8
- Add basic transactions
- Implement B-tree nodes
- Add concurrent access

## Additional Resources

### Tools
- LLDB for debugging
- Valgrind for memory analysis
- perf for performance profiling

### Documentation
- See REFERENCES.md for detailed sources
- Review GLOSSARY.md for terminology
- Study inline code documentation

## Contribution Path

1. Start with simple bug fixes
2. Add test cases
3. Implement small features
4. Work on larger components

## Code Review Checklist

- Memory management correct?
- Error handling comprehensive?
- Tests included?
- Documentation updated?
- Performance considered?