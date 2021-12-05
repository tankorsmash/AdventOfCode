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

pub fn lookup(x: u32, y: u32) u32 {
    const rows: u32 = 990;
    const cols: u32 = 990;
    _ = cols;

    return rows * y + x;
}

pub const LocalMaxes = struct {
    min_x: u32,
    max_x: u32,
    min_y: u32,
    max_y: u32,

    pub fn is_horizontal(this: *LocalMaxes) bool {
        return this.min_x == this.max_x;
    }
    pub fn is_vertical(this: *LocalMaxes) bool {
        return this.min_y == this.max_y;
    }

    pub fn get_points(this: *LocalMaxes, allocator: *std.mem.Allocator) anyerror!std.ArrayList([2]u32) {
        var result = std.ArrayList([2]u32).init(allocator);
        var x: u32 = this.min_x;
        var y: u32 = this.min_y;
        while (x <= this.max_x) : (x += 1) {
            while (y <= this.max_y) : (y += 1) {
                try result.append([2]u32{ x, y });
            }
        }

        return result;
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

    var map = std.ArrayList(u32).init(allocator);

    //build map
    {
        var x: u32 = 0;
        while (x < (990 * 990)) : (x += 1) {
            try map.append(0);
        }
    }

    for (all_values.items) |line| {
        _ = line;

        var local_maxes = try get_max_x_y_for_line(line);
        //TODO make sure we only want to include the vertical lines, because this would change the initial map and the lookup
        // if (local_maxes.is_horizontal() or local_maxes.is_vertical() ) {
        max_x = std.math.max(max_x, local_maxes.max_x);
        max_y = std.math.max(max_y, local_maxes.max_y);
        // }
    }

    std.log.info("max x: {d}, max_y: {d}", .{ max_x, max_y });

    for (all_values.items) |line| {
        _ = line;

        var local_maxes = try get_max_x_y_for_line(line);
        //skip if not hor/vrt
        if (!(local_maxes.is_horizontal() or local_maxes.is_vertical())) {
            continue;
        }

        var points = try local_maxes.get_points(allocator);
        for (points.items) |point| {
            const x = point[0];
            const y = point[0];
            map.items[lookup(x, y)] += 1;
        }
    }

    //mark boards by grouping nums into groups of 5 nums
    // std.log.info("Advent 2021 Day {d} Part 1:: {d}", .{ day, part1_solved_board.? });
    // std.log.info("Advent 2021 Day {d} Part 2:: {d}", .{ day, part2_solved_board});

    std.log.info("done", .{});
}
