const std = @import("std");
const File = std.fs.File;
const fmt = std.fmt;

const load_input = @import("../shared/load_input.zig");

pub fn solve() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = &arena.allocator;

    var all_values = try load_input.load_input(allocator, 1);

    var found_part_one = false;
    var found_part_two = false;

    for (all_values.items) |val, idx| {
        for (all_values.items) |other_val, other_idx| {
            if (other_idx == idx) {
                continue;
            }

            if (val + other_val == 2020 and !found_part_one) {
                std.log.info("Advent Day 1 Part 1:: {d}", .{val * other_val});
                found_part_one = true;
            }

            for (all_values.items) |third_val, third_idx| {
                if (third_idx == idx or third_idx == other_idx) {
                    continue;
                }

                if (val + other_val + third_val == 2020 and !found_part_two) {
                    std.log.info("Advent Day 1 Part 2:: {d}", .{val * other_val * third_val});
                    found_part_two = true;
                }
            }
        }
    }
}
