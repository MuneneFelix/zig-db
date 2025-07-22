# Implementation Patterns: Buffer Pool and Page Compaction

## Buffer Pool Implementation

### 1. Frame-based Buffer Pool

```zig
const Frame = struct {
    page: *Page,
    is_dirty: bool,
    pin_count: u32,
    last_used: i64,  // timestamp
};

const BufferPool = struct {
    frames: []Frame,
    page_table: std.AutoHashMap(u32, *Frame),
    free_list: std.SinglyLinkedList(Frame),
    replacement_strategy: ReplacementStrategy,
};
```

### 2. Clock Algorithm Implementation
```
   [Frame 0] → [Frame 1] → [Frame 2]
       ↑          (ref=0)     (ref=1)
     (ref=1)         ↓          ↓
   [Frame 5] ← [Frame 4] ← [Frame 3]
     (ref=0)     (ref=1)     (ref=0)
```

Key Operations:
1. On page access: Set reference bit to 1
2. On replacement: 
   - If reference bit is 1, set to 0 and move to next
   - If reference bit is 0, use this frame

### 3. Pre-fetching Strategy
```zig
const PrefetchQueue = struct {
    const MAX_PREFETCH = 8;
    queue: std.ArrayList(u32),
    
    fn predictNextPages(page_id: u32) []u32 {
        // Sequential prediction
        var next_pages: [MAX_PREFETCH]u32 = undefined;
        for (0..MAX_PREFETCH) |i| {
            next_pages[i] = page_id + i + 1;
        }
        return &next_pages;
    }
};
```

## Page Compaction Implementation

### 1. Record Movement Tracking
```zig
const RecordMove = struct {
    old_offset: u16,
    new_offset: u16,
    size: u16,
};

const CompactionMap = struct {
    moves: std.ArrayList(RecordMove),
    
    fn trackMove(self: *@This(), old: u16, new: u16, size: u16) !void {
        try self.moves.append(.{
            .old_offset = old,
            .new_offset = new,
            .size = size,
        });
    }
};
```

### 2. Incremental Compaction
```zig
pub fn compactIncrementally(page: *Page) !void {
    var current_offset: u16 = 0;
    var move_count: u16 = 0;
    const MAX_MOVES_PER_CYCLE = 5;

    while (current_offset < page.header.free_space_offset) {
        if (move_count >= MAX_MOVES_PER_CYCLE) {
            // Pause compaction until next cycle
            break;
        }
        // Move records
        // Update offsets
        move_count += 1;
    }
}
```

### 3. Copy Compaction with Shadow Paging
```zig
const ShadowPage = struct {
    original: *Page,
    shadow: *Page,
    
    fn applyChanges(self: *@This()) !void {
        // Copy compacted data back to original
        @memcpy(self.original.data, self.shadow.data);
        // Update header
        self.original.header.free_space_offset = self.shadow.header.free_space_offset;
    }
};
```

## Monitoring and Statistics

### 1. Buffer Pool Statistics
```zig
const BufferStats = struct {
    hits: u64,
    misses: u64,
    evictions: u64,
    
    fn hitRatio(self: @This()) f64 {
        const total = self.hits + self.misses;
        return @intToFloat(f64, self.hits) / @intToFloat(f64, total);
    }
};
```

### 2. Compaction Metrics
```zig
const CompactionStats = struct {
    spaces_reclaimed: u64,
    moves_performed: u64,
    time_spent: u64,
    
    fn efficiency(self: @This()) f64 {
        return @intToFloat(f64, self.spaces_reclaimed) / 
               @intToFloat(f64, self.moves_performed);
    }
};
```

## Testing Strategies

### 1. Buffer Pool Tests
```zig
test "buffer pool replacement policy" {
    var pool = try BufferPool.init(allocator, 3); // 3 frames
    defer pool.deinit();
    
    // Fill pool
    _ = try pool.getPage(1);
    _ = try pool.getPage(2);
    _ = try pool.getPage(3);
    
    // Force eviction
    _ = try pool.getPage(4);
    
    // Verify LRU page was evicted
    try testing.expectError(error.PageNotInMemory, pool.getPageIfExists(1));
}
```

### 2. Compaction Tests
```zig
test "page compaction maintains data integrity" {
    var page = try Page.init(allocator, 1);
    defer page.deinit();
    
    // Insert records
    const r1 = try page.insertRecord("Hello");
    _ = try page.deleteRecord(r1);
    const r2 = try page.insertRecord("World");
    
    // Compact
    try page.compact();
    
    // Verify data
    const data = try page.getRecord(r2);
    try testing.expectEqualStrings("World", data);
}
```

## Performance Tuning

### 1. Buffer Pool Sizing
```zig
fn calculateOptimalPoolSize() usize {
    const total_memory = std.os.system.getTotalSystemMemory();
    const reserved_memory = total_memory * 25 / 100; // Reserve 25%
    return @divFloor(reserved_memory, PAGE_SIZE);
}
```

### 2. Compaction Thresholds
```zig
const CompactionThresholds = struct {
    // Start compaction when free space is this fragmented
    min_fragmentation: f32 = 0.3,
    
    // Don't compact if utilization is below this
    min_utilization: f32 = 0.4,
    
    // Maximum time allowed for compaction
    max_duration_ms: u64 = 100,
};
```

## Error Handling

### 1. Buffer Pool Errors
```zig
const BufferPoolError = error{
    PoolFull,
    PageLocked,
    InvalidFrame,
    ConcurrentModification,
};
```

### 2. Compaction Errors
```zig
const CompactionError = error{
    InsufficientSpace,
    DataCorruption,
    Timeout,
    ConcurrentAccess,
};
```

Remember:
1. Start with simple implementations
2. Add complexity gradually
3. Measure everything
4. Test edge cases thoroughly
5. Document design decisions