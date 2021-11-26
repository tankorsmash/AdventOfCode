const std = @import("std");

const day1 = @import("advent2020/day1/solution.zig");
const day2 = @import("advent2020/day2/solution.zig");

pub fn main() anyerror!void {
    const result = day1.solve();
    std.log.info("All your codebase are belong to us. {}", .{result});
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}
