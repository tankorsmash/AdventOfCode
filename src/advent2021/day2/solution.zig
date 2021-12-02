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
    const day = 2;

    var all_values = load_input.load_input_line_bytes_2021(allocator, day) catch |err| {
        std.log.err("error loading input for Day {d}! {any}", .{ day, err });
        return;
    };

    var x_pos : i32 = 0;
    var y_pos : i32 = 0;

    for (all_values.items) |line| {
        var split_line = std.mem.split(u8, line.items, " ");

        var cmd = split_line.next().?;

        var val = try parse_int(split_line.next().?);

        if (std.mem.eql(u8, cmd, "forward")) {
            x_pos += val;
        } else if (std.mem.eql(u8, cmd, "down")) {
            y_pos += val;
        } else if (std.mem.eql(u8, cmd, "up")) {
            y_pos -= val;
        }

    }

    std.log.info("Advent 2021 Day {d} Part 1:: {d}", .{ day, x_pos*y_pos });
    // std.log.info("Advent 2021 Day {d} Part 2:: {d}", .{ day, rolling_incremented });
}
