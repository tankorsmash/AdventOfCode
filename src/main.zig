const std = @import("std");
const expect = std.testing.expect;
const expectEqual = std.testing.expectEqual;

const day1 = @import("advent2020/day1/solution.zig");
const day2 = @import("advent2020/day2/solution.zig");
const day3 = @import("advent2020/day3/solution.zig");
const day4 = @import("advent2020/day4/solution.zig");

pub fn main() anyerror!void {
    std.log.info("Day1 Error?: {}", .{day1.solve()});
    std.log.info("Day2 Error?: {}", .{day2.solve()});
    std.log.info("Day3 Error?: {}", .{day3.solve()});
    std.log.info("Day4 Error?: {}", .{day4.solve()});
}

pub fn expectFalse(result: bool) !void {
    try expect(!result);
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);

    //byr
    try expectFalse(day4.process_byr("1231231"));
    try expectFalse(day4.process_byr("1000"));
    try expectFalse(day4.process_byr("3000"));
    try expect(day4.process_byr("2000"));


    //iyr
    try expectFalse(day4.process_iyr("1231231"));
    try expectFalse(day4.process_iyr("1000"));
    try expectFalse(day4.process_iyr("3000"));
    try expectFalse(day4.process_iyr("2009"));
    try expectFalse(day4.process_iyr("2021"));
    try expect(day4.process_iyr("2010"));
    try expect(day4.process_iyr("2011"));
    try expect(day4.process_iyr("2019"));
    try expect(day4.process_iyr("2020"));
}
