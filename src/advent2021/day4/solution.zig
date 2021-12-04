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
        // std.log.info("stringed: {s}", .{stringed});
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
        while (i < 12) {
            const char = get_bit(line, 11 - i);
            if (char == 0) {
                sums[i] -= 1;
            } else {
                sums[i] += 1;
            }

            i += 1;
        }
    }

    std.log.info("sums i32: {any}", .{sums});

    return sums;
}

pub fn solve() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = &arena.allocator;
    const day = 4;

    var all_values = load_input.load_input_line_bytes_2021(allocator, day) catch |err| {
        std.log.err("error loading input for Day {d}! {any}", .{ day, err });
        return;
    };

    for (all_values.items) |line| {
        _ = line;
    }


    // std.log.info("Advent 2021 Day {d} Part 1:: {d}", .{ day, gamma * epsilon });
    // std.log.info("Advent 2021 Day {d} Part 2:: {d}", .{ day, oxy_result * co2_result });
}
