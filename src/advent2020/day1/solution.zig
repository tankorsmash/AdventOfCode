const std = @import("std");
const File = std.fs.File;
const fmt = std.fmt;
// const io = @import("stdio");

pub fn intToString(int: u32, buf: []u8) ![]const u8 {
    return try std.fmt.bufPrint(buf, "{}", .{int});
}

pub fn solve(x: i32, y: i32) anyerror!i32 {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = &arena.allocator;

    var file = try std.fs.cwd().openFile("src/advent2020/day1/input.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var all_values: std.ArrayList(i32) = std.ArrayList(i32).init(allocator);
    _ = all_values;

    var line_buf: [10]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&line_buf, '\n')) |raw_line| {
        var line = std.mem.trimRight(u8, raw_line, "\r\n");

        const guess = fmt.parseInt(i32, line, 10) catch {
            std.log.info("Invalid number: {d}\n", .{line});
            continue;
        };
        try all_values.append(guess);
    }

    std.log.info("values: {d}", .{all_values.items});

    for (all_values.items) |val, idx| {
        _ = val;
        _ = idx;

        for (all_values.items) |other_val, other_idx| {
            _ = other_val;
            _ = other_idx;

            if (other_idx == idx) {
                continue;
            }

            if (val + other_val == 2020) {
                std.log.info("answer is {d}", .{val * other_val});
                break;
            }
        }
    }

    return x + y;
}
