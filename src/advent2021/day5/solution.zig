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
    const rows: u32 = 990 + 1;
    const cols: u32 = 990 + 1;
    // const rows: u32 = 9 + 1;
    // const cols: u32 = 9 + 1;
    _ = cols;

    return rows * y + x;
}

pub const LocalMaxes = struct {
    start_x: u32,
    end_x: u32,
    start_y: u32,
    end_y: u32,

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

    pub fn is_flat(this: *LocalMaxes) bool {
        return this.is_horizontal() or this.is_vertical();
    }
    pub fn is_diagonal(this: *LocalMaxes) bool {
        return !this.is_flat();
    }

    pub fn get_points(this: *LocalMaxes, allocator: *std.mem.Allocator) anyerror!std.ArrayList([2]u32) {
        var result = std.ArrayList([2]u32).init(allocator);
        var x: u32 = this.min_x;
        var y: u32 = this.min_y;

        if (this.is_flat()) {
            while (x <= this.max_x) : (x += 1) {
                y = this.min_y;
                while (y <= this.max_y) : (y += 1) {
                    try result.append([2]u32{ x, y });
                }
            }
        } else {
            x = this.start_x;
            y = this.start_y;
            while (true) {
                try result.append([2]u32{ x, y });

                if (this.start_x < this.end_x) {
                    x += 1;
                    if (x > this.end_x) {
                        // std.log.info("breaking greater than end x", .{}) ;
                        break;
                    }
                } else {
                    if (x == 0) { break;  }
                    x -= 1;
                    if (x < this.end_x) {
                        // std.log.info("breaking less than end x", .{}) ;
                        break;
                    }
                }
                if (this.start_y < this.end_y) {
                    y += 1;
                    if (y > this.end_y) {
                        // std.log.info("breaking greater than end y", .{}) ;
                        break;
                    }
                } else {
                    if (y == 0) { break;  }
                    y -= 1;
                    if (y < this.end_y) {
                        // std.log.info("breaking less than end y", .{}) ;
                        break;
                    }
                }
            }
        }

        // if (!this.is_flat()) {

        // std.log.info("line start (flat? {b}) {any}", .{ this.is_flat(), this });
        // for (result.items) |coord| {
        //     std.log.info("line: -> {d}, {d}", .{ coord[0], coord[1] });
        // }

        // }

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
        .start_x = try parse_u32(raw_start_x),
        .end_x = try parse_u32(raw_end_x),
        .start_y = try parse_u32(raw_start_y),
        .end_y = try parse_u32(raw_end_y),
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
    var xxx: u32 = 0;
    while (xxx < ((990 + 1) * (990 + 1))) : (xxx += 1) {
        // while (xxx < ((10) * (10))) : (xxx += 1) {
        // std.log.info("appending", .{});
        try map.append(0);
    }
    std.log.info("map is length of {d}", .{std.mem.len(map.items)});

    for (all_values.items) |line| {
        _ = line;

        var local_maxes = try get_max_x_y_for_line(line);
        //TODO make sure we only want to include the vertical lines, because this would change the initial map and the lookup
        // both have the same answer though, so it doesnt matter for now
        // if (local_maxes.is_horizontal() or local_maxes.is_vertical() ) {
        // if (local_maxes.is_flat()) {
        max_x = std.math.max(max_x, local_maxes.max_x);
        max_y = std.math.max(max_y, local_maxes.max_y);
        // }
    }

    std.log.info("max x: {d}, max_y: {d}", .{ max_x, max_y });

    for (all_values.items) |line| {
        _ = line;

        var local_maxes = try get_max_x_y_for_line(line);
        //skip if not hor/vrt
        // if (!(local_maxes.is_horizontal() or local_maxes.is_vertical())) {
        //     continue;
        // }

        var points = try local_maxes.get_points(allocator);
        for (points.items) |point| {
            const x = point[0];
            const y = point[1];
            const idx = lookup(x, y);
            // std.log.info("idx: {d}, x: {d}, y: {d}", .{ idx, x, y });
            map.items[idx] += 1;
        }
    }

    var danger_spots: u32 = 0;
    for (map.items) |hits, idx| {
        _ = hits;
        _ = idx;
        // std.log.info("map hits (@{d}): {d}", .{ idx, hits });
        if (hits < 2) {
            continue;
        }

        danger_spots += 1;
    }

    // const end_slice: u32 = (max_x + 1) * (max_y + 1);
    // for (map.items[0..end_slice]) |_, idx| {
    //     if ((idx % 10 == 0) and idx != 0) {
    //         var row = map.items[idx - 10 .. idx];
    //         _ = row;
    //         // if ((idx % 991 == 0) and idx != 0) {
    //         //     var row = map.items[idx - 991 .. idx];
    //         std.log.info("{any}", .{row});
    //     }
    // }

    //mark boards by grouping nums into groups of 5 nums
    std.log.info("Advent 2021 Day {d} Part 1:: {d}", .{ day, danger_spots }); // not 1949
    // std.log.info("Advent 2021 Day {d} Part 2:: {d}", .{ day, part2_solved_board}); //not 956248, not 19915 (too low)

    std.log.info("done", .{});
}
