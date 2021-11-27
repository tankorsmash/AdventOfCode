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

    var part1_tree_num: u32 = 0;
    var part2_tree_num: u32 = 0;
    const col_width = std.mem.len(all_values.items[0].items);
    std.log.info("col_width {}", .{col_width});

    var col_idx: u32 = 0;
    var p1_col: u32 = 0;

    const Path = struct { down: u32, right: u32 };

    const paths_dirs = [5]Path{
        Path{ .right = 1, .down = 1 },
        Path{ .right = 3, .down = 1 },
        Path{ .right = 5, .down = 1 },
        Path{ .right = 7, .down = 1 },
        Path{ .right = 1, .down = 2 },
    };
    _ = paths_dirs;

    var path_trees = [5]u32{ 0, 0, 0, 0, 0 };
    _ = path_trees;

    for (all_values.items) |arr_bytes, row_idx| {
        var bytes: []u8 = arr_bytes.items;

        //part1
        {
            var cell = bytes[p1_col % col_width .. (p1_col % col_width) + 1];
            var is_tree = std.mem.eql(u8, cell, "#");
            if (is_tree) {
                part1_tree_num += 1;
            }
        }

        for (paths_dirs) |path, path_idx| {
            if (row_idx % path.down == 0) {
                const col: u32 = col_idx * path.right;
                var cell = bytes[col % col_width .. (col % col_width) + 1];
                var is_tree = std.mem.eql(u8, cell, "#");
                if (is_tree) {
                    path_trees[path_idx] += 1;
                }
            }
        }

        p1_col += 3;
        col_idx += 1;

        // std.log.info("len {}", .{std.mem.len(bytes)});
    }

    std.log.info("path_trees {any}", .{path_trees});
    part2_tree_num = path_trees[0] * path_trees[1] * path_trees[2] * path_trees[3] * path_trees[4];

    std.log.info("Advent Day {d} Part 1:: {d}", .{ day, part1_tree_num });
    std.log.info("Advent Day {d} Part 2:: {d}", .{ day, part2_tree_num });
}
