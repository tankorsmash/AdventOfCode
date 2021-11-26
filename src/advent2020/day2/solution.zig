const std = @import("std");
const File = std.fs.File;
const fmt = std.fmt;

const load_input = @import("../shared/load_input.zig");

pub fn solve() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = &arena.allocator;

    var all_values = try load_input.load_input_raw(allocator, 1);

    for (all_values.items) |line| {
        std.log.info("Line: {any}", .{line.items});
    }
}
