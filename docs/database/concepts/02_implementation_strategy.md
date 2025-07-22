# Implementation Strategy: Page Compaction and Space Reclamation

## Phase 1: Basic Page Compaction

### Stage 1: Fragmentation Analysis
1. **Metrics Collection**
   ```zig
   const FragmentationMetrics = struct {
       total_space: usize,
       used_space: usize,
       deleted_space: usize,
       largest_contiguous: usize,
       
       fn fragmentation_ratio(self: @This()) f64 {
           return @intToFloat(f64, self.deleted_space) / 
                  @intToFloat(f64, self.total_space);
       }
   };
   ```

2. **Threshold Definition**
   ```zig
   const CompactionThresholds = struct {
       min_fragmentation: f32 = 0.3,     // 30% fragmentation
       min_deleted_records: u32 = 5,     // At least 5 deleted records
       min_space_savings: usize = 1024,  // At least 1KB recoverable
   };
   ```

### Stage 2: Copy Compaction Implementation
1. **Shadow Page Creation**
   - Allocate new page
   - Copy valid records
   - Update offsets
   - Atomic swap

2. **Record Movement Tracking**
   ```zig
   const RecordMove = struct {
       old_offset: u16,
       new_offset: u16,
       size: u16,
   };
   ```

### Stage 3: Recovery Support
1. **Checkpoint System**
   ```zig
   const CompactionCheckpoint = struct {
       page_id: u32,
       timestamp: i64,
       is_complete: bool,
       moved_records: std.ArrayList(RecordMove),
   };
   ```

## Phase 2: Incremental Compaction

### Stage 1: State Management
1. **Compaction State**
   ```zig
   const CompactionState = struct {
       current_offset: u16,
       remaining_moves: u16,
       last_checkpoint: i64,
       
       fn save(self: *@This()) !void {
           // Persist state to disk
       }
       
       fn restore(self: *@This()) !void {
           // Restore state after crash
       }
   };
   ```

2. **Progress Tracking**
   ```zig
   const CompactionProgress = struct {
       total_records: u32,
       moved_records: u32,
       reclaimed_space: usize,
       
       fn completion_percentage(self: @This()) f64 {
           return (@intToFloat(f64, self.moved_records) / 
                   @intToFloat(f64, self.total_records)) * 100.0;
       }
   };
   ```

### Stage 2: Background Processing
1. **Work Queue**
   ```zig
   const CompactionTask = struct {
       page_id: u32,
       priority: u8,
       max_runtime_ms: u64,
       
       fn shouldYield(self: @This(), start_time: i64) bool {
           return (std.time.milliTimestamp() - start_time) >= 
                  self.max_runtime_ms;
       }
   };
   ```

2. **Scheduler**
   ```zig
   const CompactionScheduler = struct {
       tasks: std.PriorityQueue(CompactionTask),
       current_task: ?CompactionTask,
       
       fn schedule(self: *@This()) !void {
           // Schedule next compaction task
       }
   };
   ```

## Phase 3: Multi-Page Compaction

### Stage 1: Page Selection
1. **Page Scoring**
   ```zig
   const PageScore = struct {
       fragmentation_score: f64,
       access_frequency: u64,
       last_compaction: i64,
       
       fn total_score(self: @This()) f64 {
           // Weighted scoring algorithm
       }
   };
   ```

2. **Batch Processing**
   ```zig
   const CompactionBatch = struct {
       pages: std.ArrayList(u32),
       total_space: usize,
       estimated_time: u64,
   };
   ```

### Stage 2: Space Management
1. **Free Space Map**
   ```zig
   const FreeSpaceMap = struct {
       segments: []Segment,
       total_free: usize,
       largest_contiguous: usize,
       
       fn findBestFit(self: @This(), size: usize) ?usize {
           // Find best segment for given size
       }
   };
   ```

## Testing Strategy

### 1. Unit Tests
```zig
test "compaction preserves record order" {
    // Setup
    var page = try Page.init(allocator, 1);
    defer page.deinit();
    
    // Insert records with some deletions
    const r1 = try page.insertRecord("First");
    const r2 = try page.insertRecord("Second");
    try page.deleteRecord(r1);
    const r3 = try page.insertRecord("Third");
    
    // Compact
    try page.compact();
    
    // Verify order preserved
    const data = try page.getRecord(r2);
    try testing.expectEqualStrings("Second", data);
}
```

### 2. Property Tests
```zig
test "compaction maintains invariants" {
    // Properties to verify:
    // 1. No data loss
    // 2. Space reclaimed
    // 3. Records still accessible
    // 4. Offsets valid
}
```

### 3. Stress Tests
```zig
test "concurrent compaction stress" {
    // Setup multiple threads
    // Perform mixed operations
    // Verify consistency
}
```

## Monitoring

### 1. Metrics
```zig
const CompactionMetrics = struct {
    compactions_performed: u64,
    space_reclaimed: usize,
    avg_duration_ms: f64,
    failure_count: u64,
};
```

### 2. Health Checks
```zig
const CompactionHealth = struct {
    fn checkFragmentation(page: *Page) !void {
        // Verify fragmentation levels
    }
    
    fn verifyRecordIntegrity(page: *Page) !void {
        // Verify all records accessible
    }
};
```

## Implementation Order

1. Basic Copy Compaction
   - [x] Fragmentation analysis
   - [ ] Simple copy implementation
   - [ ] Basic testing

2. Incremental Processing
   - [ ] State management
   - [ ] Background processing
   - [ ] Recovery handling

3. Advanced Features
   - [ ] Multi-page compaction
   - [ ] Adaptive scheduling
   - [ ] Performance optimization

## Success Criteria

1. **Performance**
   - Compaction completes within specified time
   - Minimal impact on concurrent operations
   - Space reclamation meets targets

2. **Reliability**
   - No data loss
   - Recovery works after crashes
   - Concurrent operations safe

3. **Maintainability**
   - Clear state management
   - Good monitoring
   - Easy debugging

## Next Steps

1. Implement basic fragmentation analysis
2. Add simple copy compaction
3. Build test framework
4. Add monitoring
5. Implement incremental processing