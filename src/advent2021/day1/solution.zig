const std = @import("std");
const File = std.fs.File;
const fmt = std.fmt;

const load_input = @import("./../../advent2020/shared/load_input.zig");

pub fn parse_int(bytes: []const u8) std.fmt.ParseIntError!i32 {
    var value: i32 = std.fmt.parseUnsigned(i32, bytes, 10) catch |err| {
        if (err == error.InvalidCharacter) {
            std.log.err("err: Invalid Character: {any}", .{bytes});
            return 0;
        }

        std.log.err("err {}: Unknown error parsing int: {any}", .{ err, bytes });

        return 0;
    };

    return value;
}

pub fn solve() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = &arena.allocator;
    const day = 1;

    var all_values = load_input.load_input_line_bytes_2021(allocator, day) catch |err| {
        std.log.err("error loading input for Day {d}! {any}", .{ day, err });
        return;
    };

    var prev_val = try parse_int(all_values.items[0].items);
    var times_incremented : i32 = 0;

    var rolling_vals: std.ArrayList(i32) = std.ArrayList(i32).init(allocator);
    try rolling_vals.append(-1);
    try rolling_vals.append(-1);
    try rolling_vals.append(-1);

    var rolling_incremented : i32 = 0;
    var prev_sum : i32= 0;

    for (all_values.items) |line, idx| {
        var val = try parse_int(line.items);

        if (val > prev_val) {
            times_incremented += 1;
        }
        prev_val = val;


        //what is a queue even mean
        _ = rolling_vals.items[0];
        var el1= rolling_vals.items[1];
        var el2= rolling_vals.items[2];

        rolling_vals = std.ArrayList(i32).init(allocator);
        try rolling_vals.append(el1);
        try rolling_vals.append(el2);
        try rolling_vals.append(val);


        if (idx >= 3) {
            var cur_sum: i32 = 0;
            for (rolling_vals.items) |v| {
                cur_sum += v;
            }

            if (cur_sum > prev_sum) {
                rolling_incremented += 1;
            }
            prev_sum = cur_sum;
        }

    }

    std.log.info("Advent 2021 Day {d} Part 1:: {d}", .{ day, times_incremented });
    std.log.info("Advent 2021 Day {d} Part 2:: {d}", .{ day, rolling_incremented });
}
