const std = @import("std");
const expect = std.testing.expect;
const expectEqual = std.testing.expectEqual;

const day1 = @import("advent2020/day1/solution.zig");
const day2 = @import("advent2020/day2/solution.zig");
const day3 = @import("advent2020/day3/solution.zig");
const day4 = @import("advent2020/day4/solution.zig");
const day5 = @import("advent2020/day5/solution.zig");

const load_input = @import("./advent2020/../advent2020/shared/load_input.zig");

pub const Bounds = struct { lower: i32, upper: i32 };

pub fn split(bounds: Bounds, take_lower: bool) Bounds {
    // pub fn split(num: i32, take_lower:bool) i32{
    _ = bounds;
    _ = take_lower;
    var result = Bounds{ .lower = bounds.lower, .upper = bounds.upper };

    const range = (bounds.upper - bounds.lower) + 1;
    const half_range = @divExact(range, 2);
    // std.debug.print("range: {d}\n", .{range});
    // std.debug.print("range/2: {d}\n", .{half_range});

    if (take_lower) {
        // result.upper /= @intCast(i32, 2);
        result.upper = result.upper - half_range;
    } else {
        // result.lower /= @intCast(i32, 2);
        result.lower = result.lower + half_range;
    }

    return result;
}

pub fn main() anyerror!void {
    std.log.info("Day1 Error?: {}", .{day1.solve()});
    std.log.info("Day2 Error?: {}", .{day2.solve()});
    std.log.info("Day3 Error?: {}", .{day3.solve()});
    std.log.info("Day4 Error?: {}", .{day4.solve()});
    std.log.info("Day5 Error?: {}", .{day5.solve()});

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = &arena.allocator;
    _ = try load_input.load_input_line_bytes(allocator, 1);
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);

    try expect(1 == 1);
    var value: i32 = 100;

    try expect(value > 1);
    try expect(value < 1000);
    // try expect(1 < value < 1000);
}


test "split higher" {
    const starting_val = Bounds{ .lower = 0, .upper = 127 };
    try expectEqual(@intCast(i32, 64), split(starting_val, false).lower);
    try expectEqual(@intCast(i32, 127), split(starting_val, false).upper);
}
test "split lower" {
    const starting_val = Bounds{ .lower = 0, .upper = 127 };
    try expectEqual((Bounds{ .lower = 0, .upper = 63 }).lower, split(starting_val, true).lower);
    try expectEqual((Bounds{ .lower = 0, .upper = 63 }).upper, split(starting_val, true).upper);
}

test "split higher smaller" {
    const starting_val = Bounds{ .lower = 64, .upper = 127 };
    try expectEqual(@intCast(i32, 96), split(starting_val, false).lower);
    try expectEqual(@intCast(i32, 127), split(starting_val, false).upper);
}
test "split lower smaller lower" {
    const starting_val = Bounds{ .lower = 0, .upper = 63 };
    try expectEqual(@intCast(i32, 0), split(starting_val, true).lower);
    try expectEqual(@intCast(i32, 31), split(starting_val, true).upper);
}
test "split lower smaller upper" {
    const starting_val = Bounds{ .lower = 0, .upper = 63 };
    try expectEqual(@intCast(i32, 32), split(starting_val, false).lower);
    try expectEqual(@intCast(i32, 63), split(starting_val, false).upper);
}
