const std = @import("std");

const day1 = @import("advent2020/day1/solution.zig");

pub fn main() anyerror!void {
    const result = day1.solve(123, 3123);
    std.log.info("All your codebase are belong to us. {}", .{result});
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}
