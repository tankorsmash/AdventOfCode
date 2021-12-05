const std = @import("std");
const File = std.fs.File;
const fmt = std.fmt;

const load_input = @import("./../../advent2020/shared/load_input.zig");

pub fn parse_int(bytes: []const u8) std.fmt.ParseIntError!i32 {
    var value: i32 = std.fmt.parseUnsigned(i32, bytes, 10) catch |err| {
        if (err == error.InvalidCharacter) {
            std.log.err("err: Invalid Character: '{s}' -- '{d}'", .{ bytes, bytes });
            return 0;
        }

        std.log.err("err {}: Unknown error parsing int: {any}", .{ err, bytes });

        return 0;
    };

    return value;
}

pub fn lookup(x: i32, y: i32) i32 {
    const rows: i32 = 5;
    const cols: i32 = 5;
    _ = cols;

    return rows * y + x;
}

pub const LocalMaxes = struct { x: i32, y: i32 };

pub fn get_max_x_y_for_line(line: std.ArrayList(u8)) LocalMaxes {
    var split_line = std.mem.split(u8, line.items, " -> ");
    var start_split = split_line.next().?;
    _ = start_split;

    return LocalMaxes{ .x = 0, .y = 0 };
}

pub fn solve() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = &arena.allocator;
    const day = 5;

    var all_values = load_input.load_input_line_bytes_2021(allocator, day) catch |err| {
        std.log.err("error loading input for Day {d}! {any}", .{ day, err });
        return;
    };

    var max_x: u32 = 0;
    _ = max_x;
    var max_y: u32 = 0;
    _ = max_y;

    for (all_values.items) |line| {
        _ = line;

        var local_maxes = get_max_x_y_for_line(line);
        _ = local_maxes;
    }

    //mark boards by grouping nums into groups of 5 nums
    // std.log.info("Advent 2021 Day {d} Part 1:: {d}", .{ day, part1_solved_board.? });
    // std.log.info("Advent 2021 Day {d} Part 2:: {d}", .{ day, part2_solved_board});

    std.log.info("done", .{});
}
