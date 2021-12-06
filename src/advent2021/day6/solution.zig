const std = @import("std");
const File = std.fs.File;
const fmt = std.fmt;
const info = std.log.info;

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

pub fn solve() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = &arena.allocator;
    const day = 6;

    var all_values = load_input.load_input_line_bytes_2021(allocator, day) catch |err| {
        std.log.err("error loading input for Day {d}! {any}", .{ day, err });
        return;
    };

    var fishes_lifespans = std.ArrayList(i32).init(allocator);
    var fishes = std.ArrayList(i32).init(allocator);

    for (all_values.items) |line| {
        var split = std.mem.split(u8, line.items, ",");

        while (split.next()) |fish| {
            try fishes.append(try parse_i32(fish));
        }
    }


    for (fishes.items) |lifespan| {
        _ = lifespan;
        try fishes_lifespans.append(6);
    }

    std.log.info("len fish lifespans {d}", .{std.mem.len(fishes_lifespans.items)});
    std.log.info("len fishes {d}", .{std.mem.len(fishes.items)});

    var cur_day: i32 = 0;
    const max_days: i32 = 80;

    info("fishes day {d}:: {any}", .{cur_day, fishes.items});

    while (cur_day < max_days) {
        var min_day_delta = std.mem.min(i32, fishes.items) + 1; //since 0 is still a valid day
        if (min_day_delta + cur_day > max_days) { min_day_delta = max_days - cur_day;}
        // var min_day_delta:i32 = 1;

        var new_fishes = std.ArrayList(i32).init(allocator);
        var added_fishes = std.ArrayList(i32).init(allocator);

        // info("min_day_delta {d}", .{min_day_delta});
        for (fishes.items) |fish, fish_idx| {
            var new_fish = fish - min_day_delta;
            // info("new_fish {d}", .{new_fish});

            //if the fish has died
            if (new_fish == -1) {
                //reset its lifespan
                new_fish = fishes_lifespans.items[fish_idx];
                //if the lifespan was 8, reduce it down to 6
                // info("saved lifespan {d} for #{d}", .{new_fish, fish_idx});
                if (new_fish == 8) {
                    fishes_lifespans.items[fish_idx] = 6;
                }
                //queue to spawn a new one
                try added_fishes.append(8);
            }

            try new_fishes.append(new_fish);
        }

        for (added_fishes.items) |added_fish| {
            try fishes_lifespans.append(6);
            try new_fishes.append(added_fish);
        }

        fishes = new_fishes;


        cur_day += min_day_delta;
        // info("fishes day {d}:: {any}", .{cur_day, fishes.items});
    }
    info("cur_day {d}", .{cur_day});

    //get smallest number to define the smallest loop

    //mark boards by grouping nums into groups of 5 nums
    std.log.info("Advent 2021 Day {d} Part 1:: {d}", .{ day, std.mem.len(fishes_lifespans.items) });
    // std.log.info("Advent 2021 Day {d} Part 2:: {d}", .{ day, part2_solved_board});

    std.log.info("done", .{});
}
