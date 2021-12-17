const std = @import("std");
const File = std.fs.File;
const fmt = std.fmt;
const info = std.log.info;

const testing = std.testing;
const expect = testing.expect;

pub fn log(comptime format: []const u8) void {
    info(format, .{});
}

const load_input = @import("./../../advent2020/shared/load_input.zig");

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

pub const openers = "[({<";
pub const closers = "])}>";

pub fn to_str(char: u8) [1]u8 {
    return [1]u8{char};
}

pub fn to_slice(char: u8) []u8 {
    return to_str(char)[0..];
}

pub fn matching_char(char: u8) u8 {
    if (char == '[') { return ']'; }
    if (char == '(') { return ')'; }
    if (char == '{') { return '}'; }
    if (char == '<') { return '>'; }

    if (char == ']') { return '['; }
    if (char == ')') { return '('; }
    if (char == '}') { return '{'; }
    if (char == '>') { return '<'; }

    return ' ';
}

pub fn parse_line(allocator:*std.mem.Allocator, line:[]u8) !void {
    var chunk_symbols = std.StringHashMap(u32).init(allocator);
    for ("[](){}<>") | char | {
        try chunk_symbols.put(([1]u8{char})[0..], 0);
    }
    _ = chunk_symbols;

    for (line) |char| {
        if (std.mem.indexOf(u8, closers, to_str(char)[0..]) != null) {
            var opener_char = matching_char(char);
            var opener_count = chunk_symbols.get(to_slice(opener_char));
            if (opener_count == null or opener_count.? == 0) {

            }
        }
    }
}

pub fn solve() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = &arena.allocator;
    const day = 10;

    var all_values = load_input.load_input_line_bytes_2021(allocator, day) catch |err| {
        std.log.err("error loading input for Day {d}! {any}", .{ day, err });
        return err;
    };


    for (all_values.items) |line| {
        try parse_line(allocator, line.items);
    }


    // std.log.info("Advent 2021 Day {d} Part 1:: {d}", .{ day, total_risk_level }); //not 34128, not 574, not 560, not 578, not 74679, it was 585
    // std.log.info("Advent 2021 Day {d} Part 2:: {d}", .{ day, top3_basin_product }); //not 751872 , too low

    std.log.info("done", .{});
}

test "day10 test" {
    try expect(1 == 1);
    try expect(1 == 0);
}
