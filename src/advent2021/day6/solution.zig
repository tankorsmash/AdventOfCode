const std = @import("std");
const File = std.fs.File;
const fmt = std.fmt;
const info = std.log.info;

pub fn log(comptime format: []const u8,) void { info(format, .{}); }

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
pub fn parse_i32(bytes: []const u8) std.fmt.ParseIntError!i32 {
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
    const rows: i32 = 990 + 1;
    const cols: i32 = 990 + 1;
    // const rows: i32 = 9 + 1;
    // const cols: i32 = 9 + 1;
    _ = cols;

    return rows * y + x;
}

pub const LocalMaxes = struct {
    start_x: i32,
    end_x: i32,
    start_y: i32,
    end_y: i32,

    min_x: i32,
    max_x: i32,
    min_y: i32,
    max_y: i32,

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

    pub fn get_points(this: *LocalMaxes, allocator: *std.mem.Allocator) anyerror!std.ArrayList([2]i32) {
        var result = std.ArrayList([2]i32).init(allocator);
        var x: i32 = this.min_x;
        var y: i32 = this.min_y;

        if (this.is_flat()) {
            while (x <= this.max_x) : (x += 1) {
                y = this.min_y;
                while (y <= this.max_y) : (y += 1) {
                    try result.append([2]i32{ x, y });
                }
            }
        } else {
            x = this.start_x;
            y = this.start_y;
            while (true) {
                try result.append([2]i32{ x, y });

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
        .start_x = try parse_i32(raw_start_x),
        .end_x = try parse_i32(raw_end_x),
        .start_y = try parse_i32(raw_start_y),
        .end_y = try parse_i32(raw_end_y),
        .min_x = std.math.min(try parse_i32(raw_start_x), try parse_i32(raw_end_x)),
        .max_x = std.math.max(try parse_i32(raw_start_x), try parse_i32(raw_end_x)),
        .min_y = std.math.min(try parse_i32(raw_start_y), try parse_i32(raw_end_y)),
        .max_y = std.math.max(try parse_i32(raw_start_y), try parse_i32(raw_end_y)),
    };
}

pub const Fish = struct {
    born_day_idx: i32,
    had_kids: bool = false,
    pub fn is_matured(this:*Fish, cur_day_idx:i32) bool {
        return cur_day_idx >= this.born_day_idx + 8;
    }

    pub fn get_child_fish(this: *const Fish, allocator: *std.mem.Allocator, cur_day_idx: i32) !std.ArrayList(Fish) {
        // log("get child fish");

        var result = std.ArrayList(Fish).init(allocator);

        if (this.had_kids) { return result; }

        const days_left: i32 = cur_day_idx - MAX_DAYS;

        var gestation_period: i32 = 8;

        //temp 8 period for first child
        if (days_left >= gestation_period) {
            try result.append(Fish{
                .born_day_idx = this.born_day_idx+gestation_period
            });
        }

        gestation_period = 6;
        var cur_day: i32 = cur_day_idx + gestation_period;

        while (cur_day < MAX_DAYS) {
            try result.append(Fish{
                .born_day_idx = cur_day
            });

            cur_day += gestation_period;
        }

        return result;
    }
};

const MAX_DAYS: i32 = 256;

pub fn solve() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = &arena.allocator;
    const day = 6;

    var all_values = load_input.load_input_line_bytes_2021(allocator, day) catch |err| {
        std.log.err("error loading input for Day {d}! {any}", .{ day, err });
        return;
    };

    var fishes = std.ArrayList(Fish).init(allocator);

    info("0", .{});
    for (all_values.items) |line| {
        var split = std.mem.split(u8, line.items, ",");

        while (split.next()) |fish| {
            var cur_fish_day = try parse_i32(fish);
            try fishes.append(Fish{.born_day_idx=0-cur_fish_day});
        }
    }

    info("len fishes {d}", .{std.mem.len(fishes.items)});

    var current_day: i32 = -10; //bogus day in the past so that the lookups work
    while (current_day < MAX_DAYS) : (current_day += 1) {
        var all_new_fishes = std.ArrayList(Fish).init(allocator);

        for (fishes.items) |fish| {
            if (fish.had_kids) { continue;}

            var children = try fish.get_child_fish(allocator, current_day);
            for (children.items) |new_fish| {
                try all_new_fishes.append(new_fish);
            }
        }
        fishes = all_new_fishes;
        // for (all_new_fishes.items) |new_fish| {
        //     try fishes.append(new_fish);
        // }

        info("current day {d}, len fishes {d}", .{current_day, std.mem.len(fishes.items)});
    }


    std.log.info("len fishes {d}", .{std.mem.len(fishes.items)});

    var cur_day: i32 = 0;

    info("fishes day {d}:: {any}", .{cur_day, fishes.items});



    //get smallest number to define the smallest loop

    //mark boards by grouping nums into groups of 5 nums
    std.log.info("Advent 2021 Day {d} Part 1:: {d}", .{ day, std.mem.len(fishes.items) });
    // std.log.info("Advent 2021 Day {d} Part 2:: {d}", .{ day, part2_solved_board});

    std.log.info("done", .{});
}
