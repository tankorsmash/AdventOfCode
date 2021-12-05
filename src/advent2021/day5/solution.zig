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
pub fn parse_u32(bytes: []const u8) std.fmt.ParseIntError!u32 {
    var value: u32 = std.fmt.parseUnsigned(u32, bytes, 10) catch |err| {
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
    const rows: i32 = 990;
    const cols: i32 = 990;
    _ = cols;

    return rows * y + x;
}

pub const LocalMaxes = struct {
    min_x: u32,
    max_x: u32,
    min_y: u32,
    max_y: u32,

    pub fn is_horizontal(self: *LocalMaxes) void {
        return self.min_x == self.max_x;
    }
    pub fn is_vertical(self: *LocalMaxes) void {
        return self.min_y == self.max_y;
    }
};

pub fn get_max_x_y_for_line(line: std.ArrayList(u8)) anyerror!LocalMaxes {
    var split_line = std.mem.split(u8, line.items, " -> ");
    var start_split = split_line.next().?;
    var end_split = split_line.next().?;

    var start_splitter = std.mem.split(u8, start_split, ",");
    var raw_start_x = start_splitter.next().?;
    _ = raw_start_x;
    var raw_start_y = start_splitter.next().?;
    _ = raw_start_y;

    var end_splitter = std.mem.split(u8, end_split, ",");
    var raw_end_x = end_splitter.next().?;
    _ = raw_end_x;
    var raw_end_y = end_splitter.next().?;
    _ = raw_end_y;

    return LocalMaxes{
        .min_x = std.math.min(try parse_u32(raw_start_x), try parse_u32(raw_end_x)),
        .max_x = std.math.max(try parse_u32(raw_start_x), try parse_u32(raw_end_x)),
        .min_y = std.math.min(try parse_u32(raw_start_y), try parse_u32(raw_end_y)),
        .max_y = std.math.max(try parse_u32(raw_start_y), try parse_u32(raw_end_y)),
    };
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

        var local_maxes = try get_max_x_y_for_line(line);
        max_x = std.math.max(max_x, local_maxes.max_x);
        max_y = std.math.max(max_y, local_maxes.max_y);
    }

    std.log.info("max x: {d}, max_y: {d}", .{ max_x, max_y });

    //mark boards by grouping nums into groups of 5 nums
    // std.log.info("Advent 2021 Day {d} Part 1:: {d}", .{ day, part1_solved_board.? });
    // std.log.info("Advent 2021 Day {d} Part 2:: {d}", .{ day, part2_solved_board});

    std.log.info("done", .{});
}