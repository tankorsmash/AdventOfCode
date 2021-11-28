const std = @import("std");
const File = std.fs.File;
const fmt = std.fmt;

const load_input = @import("../shared/load_input.zig");

pub fn solve() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = &arena.allocator;

    const day = 4;
    var all_values = load_input.load_input_line_bytes(allocator, day) catch |err| {
        std.log.err("error loading input for Day {d}! {any}", .{ day, err });
        return;
    };

    var part1_solution: i32 = 0;

    for (all_values.items) |arr_bytes, row_idx| {
        _ = row_idx;
        var bytes: []u8 = arr_bytes.items;
        _ = bytes;

    }


    std.log.info("Advent Day {d} Part 1:: {d}", .{ day, part1_solution });
}
