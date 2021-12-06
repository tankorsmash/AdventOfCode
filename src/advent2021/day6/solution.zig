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
    const day = 6;

    var all_values = load_input.load_input_line_bytes_2021(allocator, day) catch |err| {
        std.log.err("error loading input for Day {d}! {any}", .{ day, err });
        return;
    };

    var fishes = std.ArrayList(u32).init(allocator);

    for (all_values.items) |line| {
        var split = std.mem.split(u8, line.items, ",");

        while (split.next()) |fish| {
            try fishes.append(try parse_u32(fish));
        }
    }

    std.log.info("len fish {d}", .{std.mem.len(fishes.items)});

    //mark boards by grouping nums into groups of 5 nums
    // std.log.info("Advent 2021 Day {d} Part 1:: {d}", .{ day, danger_spots });
    // std.log.info("Advent 2021 Day {d} Part 2:: {d}", .{ day, part2_solved_board});

    std.log.info("done", .{});
}
