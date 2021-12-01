const std = @import("std");
const File = std.fs.File;
const fmt = std.fmt;

const load_input = @import("./../../advent2020/shared/load_input.zig");

const expect = std.testing.expect;
const expectEqual = std.testing.expectEqual;
pub fn expectFalse(result: bool) !void {
    try expect(!result);
}

pub fn valid_len(bytes: []const u8, req_size: u32) bool {
    return std.mem.len(bytes) == req_size;
}

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

    // const starting_val = Bounds{.lower=0, .upper=128};
    //
    // // const pairs = split(starting_val, false);
    // std.log.info("starting pairs: {}", .{starting_val});
    // std.log.info("taking lower: {any}", .{split(starting_val, false)});
    // std.log.info("taking upper: {any}", .{split(starting_val, true)});

    // var all_values :std.ArrayList(std.ArrayList(u8)) = undefined;
    var all_values = load_input.load_input_line_bytes_2021(allocator, day) catch |err| {
        std.log.err("error loading input for Day {d}! {any}", .{ day, err });
        return;
    };
    _ = all_values;

    var prev_val = try parse_int(all_values.items[0].items);
    var times_incremented : i32 = 0;

    var rolling_vals: std.ArrayList(i32) = std.ArrayList(i32).init(allocator);
    try rolling_vals.append(-1);
    try rolling_vals.append(-1);
    try rolling_vals.append(-1);
    _ = rolling_vals;
    var rolling_incremented : i32 = 0;
    _ = rolling_incremented;
    var prev_sum : i32= 0;

    for (all_values.items) |line, idx| {
        _ = line;
        var val = try parse_int(line.items);
        _ = val;

        if (val > prev_val) {
            times_incremented += 1;
        }
        prev_val = val;


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
            // std.log.info("cur_sum: {d}, {b}", .{cur_sum, cur_sum > prev_sum});
            if (cur_sum > prev_sum) {
                rolling_incremented += 1;
            }
            prev_sum = cur_sum;
        }


        // associate letters and their sum

    }

    //TODO its not 507
    std.log.info("Advent 2021 Day {d} Part 1:: {d}", .{ day, times_incremented });
    std.log.info("Advent 2021 Day {d} Part 2:: {d}", .{ day, rolling_incremented });
}

test "ASDA" {
    try expect(true);
}
