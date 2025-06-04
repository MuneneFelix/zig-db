# Data Organization

This document describes the hierarchical structure and data layout used in the zig-db project, from individual records up to the file storage format.

---

## 1. Record

A **Record** is the smallest unit of data stored in a page. Each record consists of a header and the actual data.

- **RecordHeader**: Contains metadata such as size, offset, and deletion status.
- **Record Data**: The actual bytes representing the record's value.

```
+-------------------+-------------------+
| RecordHeader      | Record Data       |
+-------------------+-------------------+
```

---

## 2. Page

A **Page** is a fixed-size block (typically 4KB) that contains multiple records.

- **PageHeader**: Metadata about the page (page ID, free space offset, record count, etc.).
- **Data Buffer**: A byte array where records are packed.

```
+-------------------+---------------------------------------+
| PageHeader        | Data Area (records, free space, etc.) |
+-------------------+---------------------------------------+
```

---

## 3. PageManager

The **PageManager** manages all pages in memory and coordinates reading/writing pages to disk.

- **pages**: A hashmap mapping page IDs to pointers to Page structs.
- **next_page_id**: The next available page ID.
- **allocator**: Memory allocator for dynamic allocations.

```
PageManager
|
+-- pages: HashMap<u32, *Page>
|      +-- page_id: 1 -> *Page
|      +-- page_id: 2 -> *Page
|      ...
+-- next_page_id: u32
+-- allocator
```

---

## 4. File Layout (`pages.dat`)

On disk, all pages are serialized into a single file (`pages.dat`). Each page is written at an offset calculated as `page_id * PAGE_SIZE`.

```
+-------------------+-------------------+-------------------+---
| Page 1            | Page 2            | Page 3            | ...
| [PageHeader][Data]| [PageHeader][Data]| [PageHeader][Data]|
+-------------------+-------------------+-------------------+---
```

- Each page is a contiguous block of bytes: `[PageHeader][Data]`
- The file is a sequence of such pages.

---

## Summary Table

| Level         | Structure/Field         | Description/Contents                                  |
|---------------|------------------------|-------------------------------------------------------|
| Record        | RecordHeader, data      | Metadata + actual record bytes                        |
| Page          | PageHeader, data        | Metadata + packed records (as bytes)                  |
| PageManager   | HashMap<u32, *Page>    | Maps page IDs to in-memory pages                      |
| File          | [PageHeader][Data]...  | Sequence of serialized pages, each PAGE_SIZE bytes    |

---

## Visualization

```
File (pages.dat)
└── [Page 0][Page 1][Page 2]...
      │
      └─ Page
         ├─ PageHeader
         └─ Data (records packed as [RecordHeader][RecordData]...)
               │
               └─ Record
                  ├─ RecordHeader
                  └─ RecordData
```

---

This structure ensures efficient storage, retrieval, and management of records, pages, and the overall database file.