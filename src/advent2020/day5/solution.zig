const std = @import("std");
const File = std.fs.File;
const fmt = std.fmt;

const load_input = @import("./../shared/load_input.zig");

const expect = std.testing.expect;
const expectEqual = std.testing.expectEqual;
pub fn expectFalse(result: bool) !void {
    try expect(!result);
}


pub fn valid_len(bytes: []const u8, req_size: u32) bool {
    return std.mem.len(bytes) == req_size;
}

pub const Bounds = struct {
    lower: i32,
    upper: i32
};

pub fn split(bounds: Bounds, take_lower:bool) Bounds {
// pub fn split(num: i32, take_lower:bool) i32{
    _ = bounds;
    _ = take_lower;
    var result = Bounds {
        .lower = bounds.lower,
        .upper = bounds.upper
    };

    if (take_lower) {
        // result.upper /= @intCast(i32, 2);
        result.upper = @divExact(result.upper, @intCast(i32, 2));
    } else {
        // result.lower /= @intCast(i32, 2);
        result.lower = @divExact(result.upper, @intCast(i32, 2));
    }

    return result;
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
    const day = 5;

    const starting_val = Bounds{.lower=0, .upper=128};

    // const pairs = split(starting_val, false);
    std.log.info("starting pairs: {}", .{starting_val});
    std.log.info("taking lower: {any}", .{split(starting_val, false)});
    std.log.info("taking upper: {any}", .{split(starting_val, true)});

    // var all_values :std.ArrayList(std.ArrayList(u8)) = undefined;
    var all_values = load_input.load_input_line_bytes(allocator, day) catch |err| {
        std.log.err("error loading input for Day {d}! {any}", .{ day, err });
        return;
    };
    _ = all_values;

    std.log.info("Advent Day {d} Part 1:: {d}", .{ day, 1 });
    std.log.info("Advent Day {d} Part 2:: {d}", .{ day, 2 });
}
