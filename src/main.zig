const std = @import("std");
const expect = std.testing.expect;
const expectEqual = std.testing.expectEqual;

const day1 = @import("advent2020/day1/solution.zig");
const day2 = @import("advent2020/day2/solution.zig");
const day3 = @import("advent2020/day3/solution.zig");
const day4 = @import("advent2020/day4/solution.zig");
const day5 = @import("advent2020/day5/solution.zig");

const load_input = @import("./advent2020/../advent2020/shared/load_input.zig");

pub fn main() anyerror!void {
    std.log.info("Day1 Error?: {}", .{day1.solve()});
    std.log.info("Day2 Error?: {}", .{day2.solve()});
    std.log.info("Day3 Error?: {}", .{day3.solve()});
    std.log.info("Day4 Error?: {}", .{day4.solve()});
    std.log.info("Day5 Error?: {}", .{day5.solve()});

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = &arena.allocator;
    _ =try  load_input.load_input_line_bytes(allocator, 1);
}



test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);

    try expect( 1 ==1);
    var value : i32 = 100;

    try expect(value > 1);
    try expect(value < 1000);
    // try expect(1 < value < 1000);

}
