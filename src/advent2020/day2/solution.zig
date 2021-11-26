const std = @import("std");
const File = std.fs.File;
const fmt = std.fmt;

pub fn solve() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = &arena.allocator;

    var all_values = try load_input.load_input(allocator, 1);
}
