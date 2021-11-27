const std = @import("std");
const File = std.fs.File;
const fmt = std.fmt;

const load_input = @import("../shared/load_input.zig");

pub fn solve() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = &arena.allocator;

    const day = 3;
    var all_values = load_input.load_input_line_bytes(allocator, day) catch |err| {
        std.log.err("error loading input for Day {d}! {any}", .{ day, err });
        return;
    };
    var str: *const [3:0]u8 = "asd";
    _ = str;

    var num_valid_part1_passwords: u32 = 0;
    // var num_valid_part2_passwords: u32 = 0;
    const col_width = std.mem.len(all_values.items[0].items);
    std.log.info("col_width {}", .{col_width});

    var col: u32 = 0;

    var row:u32 = 0;
    for (all_values.items) |arr_bytes| {
        var bytes: []u8 = arr_bytes.items;

        var cell = bytes[col % col_width..(col % col_width)+1];
        // var is_tree = cell[0] == "#";
        var is_tree = std.mem.eql(u8, cell, "#");
        if (is_tree) {
            num_valid_part1_passwords += 1;
        }

        col += 3;
        row += 1;
        // std.log.info("len {}", .{std.mem.len(bytes)});
    }

    std.log.info("Advent Day {d} Part 1:: {d}", .{day, num_valid_part1_passwords});
    // std.log.info("Advent Day {d} Part 2:: {d}", .{day, num_valid_part2_passwords});
}
