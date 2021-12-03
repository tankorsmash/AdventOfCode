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

pub fn parse_bin(bytes: []const u8) std.fmt.ParseIntError!u32 {
    var value: u32 = std.fmt.parseUnsigned(u32, bytes, 2) catch |err| {
        if (err == error.InvalidCharacter) {
            std.log.err("err: Invalid Character: {any}", .{bytes});
            return 0;
        }

        std.log.err("err {}: Unknown error parsing binary int: {any}", .{ err, bytes });

        return 0;
    };

    return value;
}

pub fn get_bit(num: u32, bit_idx: u5) u32 {
    const shift: u5 = bit_idx;
    const one: u32 = 1;
    const shifted_one: u32 = one << shift;
    const shifted_one_num: u32 = (num & shifted_one);
    return shifted_one_num >> shift;
}

pub fn calc_sums_raw(allocator: *std.mem.Allocator, values: std.ArrayList(std.ArrayList(u8))) ![12]i32 {
    var sums = [12]i32{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

    std.log.info("first raw elem: {any}", .{values.items[0]});

    for (values.items) |line| {
        _ = line;
        var stringed = try fmt.allocPrint(allocator, "{s}", .{line.items});
        _ = stringed;

        for (stringed) |char, idx| {
            // if (std.mem.eql(u8, char, "0")) {
            if (char == '0') {
                sums[idx] -= 1;
            } else {
                sums[idx] += 1;
            }
        }
    }
    std.log.info("sums bin: {any}", .{sums});

    return sums;
}
pub fn calc_sums_i32(values: []u32) ![12]i32 {
    var sums = [12]i32{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
    std.log.info("first i32 elem: {d}", .{values[0]});

    for (values) |line| {
        var i: u5 = 0;
        while (i < 12) : (i += 1) {
            const char = get_bit(line, i);
            if (char == 0) {
                sums[i] -= 1;
            } else {
                sums[i] += 1;
            }
        }
    }

    std.log.info("sums i32: {any}", .{sums});

    return sums;
}

pub fn solve() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = &arena.allocator;
    const day = 3;

    var all_values = load_input.load_input_line_bytes_2021(allocator, day) catch |err| {
        std.log.err("error loading input for Day {d}! {any}", .{ day, err });
        return;
    };

    var sums = try calc_sums_raw(allocator, all_values);
    std.log.info("about to parse oxy vals", .{});
    //oxygen
    var oxy_vals = std.ArrayList(u32).init(allocator);
    var co2_vals = std.ArrayList(u32).init(allocator);
    for (all_values.items) |line| {
        var parsed: u32 = try parse_bin(line.items);
        // std.log.info("parsed: {b} {d}", .{@intCast(u32, parsed), @intCast(u32, parsed)});
        try oxy_vals.append(@intCast(u32, parsed));
        try co2_vals.append(@intCast(u32, parsed));
    }
    std.log.info("done to parse oxy vals", .{});

    var oxy_result: u32 = undefined;
    var cur_vals = std.ArrayList(u32).init(allocator);
    var i: usize = 0;
    while (i < 12) : (i += 1) {
        var oxy_sums = try calc_sums_i32(oxy_vals.items);
        var sum = oxy_sums[i];
        for (oxy_vals.items) |line| {
            const bit: u32 = get_bit(line, @intCast(u5, i));

            const ones_common = sum > 0;
            const tied_common = sum == 0;
            const zero_common = sum < 0;
            if (ones_common) {
                if (bit == 1) {
                    try cur_vals.append(line);
                }
            }
            if (tied_common) {
                if (bit == 1) {
                    try cur_vals.append(line);
                }
            }
            if (zero_common) {
                if (bit == 0) {
                    try cur_vals.append(line);
                }
            }
        }

        if (std.mem.len(cur_vals.items) == 1) {
            oxy_result = cur_vals.items[0];
            std.log.info("hit oxy end: {d}", .{oxy_result});
            break;
        } else {
            oxy_vals = cur_vals;
            cur_vals = std.ArrayList(u32).init(allocator);
        }
    }

    var co2_result: u32 = undefined;
    var co2_cur_vals = std.ArrayList(u32).init(allocator);
    i = 0;
    while (i < 12) : (i += 1) {
        var co2_sums = try calc_sums_i32(co2_vals.items);
        var sum = co2_sums[i];
        for (co2_vals.items) |line| {
            const bit: u32 = get_bit(line, @intCast(u5, i));

            const zero_uncommon = sum > 0;
            const tied_uncommon = sum == 0;
            const one_uncommon = sum < 0;
            if (zero_uncommon) {
                if (bit == 0) {
                    try co2_cur_vals.append(line);
                }
            }
            if (tied_uncommon) {
                if (bit == 0) {
                    try co2_cur_vals.append(line);
                }
            }
            if (one_uncommon) {
                if (bit == 1) {
                    try co2_cur_vals.append(line);
                }
            }
        }

        if (std.mem.len(co2_cur_vals.items) == 1) {
            co2_result = co2_cur_vals.items[0];
            std.log.info("hit co2 end: {d}", .{co2_result});
            break;
        } else {
            co2_vals = co2_cur_vals;
            co2_cur_vals = std.ArrayList(u32).init(allocator);
        }
    }

    std.log.info("oxy vals: {any}, co2 vals: {any}", .{ oxy_vals.items, co2_vals.items });

    var g_bit_0: u8 = if (sums[0] > 0) '1' else '0';
    _ = g_bit_0;
    var g_bit_1: u8 = if (sums[1] > 0) '1' else '0';
    _ = g_bit_1;
    var g_bit_2: u8 = if (sums[2] > 0) '1' else '0';
    _ = g_bit_2;
    var g_bit_3: u8 = if (sums[3] > 0) '1' else '0';
    _ = g_bit_3;
    var g_bit_4: u8 = if (sums[4] > 0) '1' else '0';
    _ = g_bit_4;
    var g_bit_5: u8 = if (sums[5] > 0) '1' else '0';
    _ = g_bit_5;
    var g_bit_6: u8 = if (sums[6] > 0) '1' else '0';
    _ = g_bit_6;
    var g_bit_7: u8 = if (sums[7] > 0) '1' else '0';
    _ = g_bit_7;
    var g_bit_8: u8 = if (sums[8] > 0) '1' else '0';
    _ = g_bit_8;
    var g_bit_9: u8 = if (sums[9] > 0) '1' else '0';
    _ = g_bit_9;
    var g_bit_10: u8 = if (sums[10] > 0) '1' else '0';
    _ = g_bit_10;
    var g_bit_11: u8 = if (sums[11] > 0) '1' else '0';
    _ = g_bit_11;
    std.log.info("sums: {any}", .{sums});

    var gamma_str = [_]u8{ g_bit_0, g_bit_1, g_bit_2, g_bit_3, g_bit_4, g_bit_5, g_bit_6, g_bit_7, g_bit_8, g_bit_9, g_bit_10, g_bit_11 };
    std.log.info("gamma_str: {any}", .{gamma_str});

    var gamma: i32 = try std.fmt.parseInt(i32, gamma_str[0..], 2); //how the fuck
    _ = gamma;
    std.log.info("gamma: {b}", .{gamma});

    // var epsilon: i32 = gamma ^ 0b11111;
    var epsilon: i32 = ~gamma & ((1 << 12) - 1);
    std.log.info("epsilon: {b}", .{epsilon});
    _ = epsilon;

    std.log.info("oxy_Result: {b}", .{oxy_result});
    // var co2_hack: u32 = ~oxy_result & ((1 << 12) - 1); //2397996 TODO is too high

    std.log.info("Advent 2021 Day {d} Part 1:: {d}", .{ day, gamma * epsilon });
    std.log.info("Advent 2021 Day {d} Part 2:: {d}", .{ day, oxy_result * co2_result });
    // std.log.info("Advent 2021 Day {d} Part 2:: {d}", .{ day, oxy_result*co2_hack });
}
