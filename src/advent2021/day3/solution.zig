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
    const day = 3;

    var all_values = load_input.load_input_line_bytes_2021(allocator, day) catch |err| {
        std.log.err("error loading input for Day {d}! {any}", .{ day, err });
        return;
    };

    var sums = [12]i32{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

    for (all_values.items) |line| {
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

    std.log.info("Advent 2021 Day {d} Part 1:: {d}", .{ day, gamma * epsilon });
    // std.log.info("Advent 2021 Day {d} Part 2:: {d}", .{ day, horiz*depth });
}
