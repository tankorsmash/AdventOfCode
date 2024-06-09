const std = @import("std");
const expect = std.testing.expect;
const expectEqual = std.testing.expectEqual;

// const day1 = @import("advent2020/day1/solution.zig");
// const day2 = @import("advent2020/day2/solution.zig");
// const day3 = @import("advent2020/day3/solution.zig");
const day4 = @import("advent2020/day4/solution.zig");
// const day5 = @import("advent2020/day5/solution.zig");
//
// const day1_2021 = @import("advent2021/day1/solution.zig");
// const day2_2021 = @import("advent2021/day2/solution.zig");
// const day3_2021 = @import("advent2021/day3/solution.zig");
// const day4_2021 = @import("advent2021/day4/solution.zig");
// const day5_2021 = @import("advent2021/day5/solution.zig");
// const day6_2021 = @import("advent2021/day6/solution.zig");
// const day7_2021 = @import("advent2021/day7/solution.zig");
// const day8_2021 = @import("advent2021/day8/solution.zig");
// const day9_2021 = @import("advent2021/day9/solution.zig");
// const day10_2021 = @import("advent2021/day10/solution.zig");

pub fn main() anyerror!void {
    var year : i32 = 2020;
    // std.log.info("{d} Day1 Error?: {}", .{year, day1.solve()});
    // std.log.info("{d} Day2 Error?: {}", .{year, day2.solve()});
    // std.log.info("{d} Day3 Error?: {}", .{year, day3.solve()});
    std.log.info("{d} Day4 Error?: {!}", .{year, day4.solve()});
    // std.log.info("{d} Day5 Error?: {}", .{year, day5.solve()});
    //
    year = 2021;
    // std.log.info("{d} Day1 Error?: {}", .{year, day1_2021.solve()});
    // std.log.info("{d} Day2 Error?: {}", .{year, day2_2021.solve()});
    // std.log.info("{d} Day3 Error?: {}", .{year, day3_2021.solve()});
    // std.log.info("{d} Day4 Error?: {}", .{year, day4_2021.solve()});
    // std.log.info("{d} Day5 Error?: {}", .{year, day5_2021.solve()});
    // std.log.info("{d} Day6 Error?: {}", .{year, day6_2021.solve()});
    // std.log.info("{d} Day7 Error?: {}", .{year, day7_2021.solve()});
    // std.log.info("{d} Day8 Error?: {}", .{year, day8_2021.solve()});
    // std.log.info("{d} Day9 Error?: {}", .{year, day9_2021.solve()});
    // std.log.info("{d} Day10 Error?: {!}", .{year, day10_2021.solve()});

}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);

    try expect(1 == 1);
    var value: i32 = 100;

    try expect(value > 1);
    try expect(value < 1000);
    // try expect(1 < value < 1000);
}
