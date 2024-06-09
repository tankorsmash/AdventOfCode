const std = @import("std");
const File = std.fs.File;
const fmt = std.fmt;
const info = std.log.info;
const mem = std.mem;

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

    std.debug.assert(false);
    return ' ';
}

pub fn parse_line_for_part_1(allocator:*std.mem.Allocator, line:[]u8) !i32 {
    var chunk_symbols = std.AutoHashMap(u8, u32).init(allocator.*);
    for ("[](){}<>") | char | {
        try chunk_symbols.put(char, 0);
    }
    for (line) |char| {
        var char_count = chunk_symbols.get(char).?;
        var is_closer_char: bool = std.mem.indexOfScalar(u8, closers, char) != null;

        if (is_closer_char) {
            var opener_char = matching_char(char);
            var opener_count = chunk_symbols.get(opener_char);

            if (opener_count == null or opener_count.? == 0) {
                //handle invalid closers
                if (char == ')') { return 3; }
                else if (char == ']') { return 57; }
                else if (char == '}') { return 1197; }
                else if (char == '>') { return 25137; }

                else { info("WTF", .{}); }
            } else {
                try chunk_symbols.put(opener_char, opener_count.? - 1);
            }

        }
        try chunk_symbols.put(char, char_count + 1);
    }

    var chunk_splitter = chunk_symbols.iterator();
    while (chunk_splitter.next()) |item| {
        info("{c}: {d}", .{item.key_ptr.*, item.value_ptr.*});
    }

    return 0;
}

pub fn solve() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    var allocator : mem.Allocator = arena.allocator();
    const day = 10;

    var all_values = load_input.load_input_line_bytes_2021(&allocator, day) catch |err| {
        std.log.err("error loading input for Day {d}! {any}", .{ day, err });
        return err;
    };


    var total_score_p1 : i32 = 0;
    for (all_values.items) |line| {
        var score_p1 = try parse_line_for_part_1(&allocator, line.items);
        info("score_p1 {d}", .{score_p1});
        total_score_p1 += score_p1;
        
    }


    std.log.info("Advent 2021 Day {d} Part 1:: {d}", .{ day, total_score_p1 });
    // std.log.info("Advent 2021 Day {d} Part 2:: {d}", .{ day, top3_basin_product }); //not 751872 , too low

    std.log.info("done", .{});
}

test "day10 test" {
    try expect(1 == 1);
    try expect(1 == 0);
}
