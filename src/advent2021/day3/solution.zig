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

    var sums = std.ArrayList(i32).init(allocator);
    _ = sums;

    //make sums 12 zeroes
    try sums.append(0);
    try sums.append(0);
    try sums.append(0);
    try sums.append(0);
    try sums.append(0);
    try sums.append(0);
    try sums.append(0);
    try sums.append(0);
    try sums.append(0);
    try sums.append(0);
    try sums.append(0);
    try sums.append(0);

    for (all_values.items) |line| {
        _ = line;
        var stringed = try fmt.allocPrint(allocator, "{s}", .{line.items});
        _ = stringed;


        for (stringed) |char, idx| {
            // if (std.mem.eql(u8, char, "0")) {
            if (char == '0') {
                sums.items[idx] -= 1;
            } else {
                sums.items[idx] += 1;
            }
        }




        // std.sort.sort(u8, &stringed, {}, comptime std.sort.asc(u8));
        //
        // const first_one = std.mem.indexOf(u8, stringed, '1').?;
        // _ = first_one;
        //
        // if (first_one >= 6) {
        //
        // }

    }
    var g_bit_0: u8 = if (sums.items[0] > 0 ) '1' else '0';
    _ = g_bit_0;
    var g_bit_1: u8 = if (sums.items[1] > 0 ) '1' else '0';
    _ = g_bit_1;
    var g_bit_2: u8 = if (sums.items[2] > 0 ) '1' else '0';
    _ = g_bit_2;
    var g_bit_3: u8 = if (sums.items[3] > 0 ) '1' else '0';
    _ = g_bit_3;
    var g_bit_4: u8 = if (sums.items[4] > 0 ) '1' else '0';
    _ = g_bit_4;
    std.log.info("sums: {any}", .{sums});

    var gamma_str = [_]u8 { g_bit_0, g_bit_1, g_bit_2, g_bit_3, g_bit_4};

    var gamma: i32 = try std.fmt.parseInt(i32, gamma_str[0..], 2); //how the fuck
    _ = gamma;

    var epsilon = 1 ^ gamma;
    _ = epsilon;

    std.log.info("Advent 2021 Day {d} Part 1:: {d}", .{ day, gamma*epsilon});
    // std.log.info("Advent 2021 Day {d} Part 2:: {d}", .{ day, horiz*depth });
}
