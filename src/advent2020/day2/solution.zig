const std = @import("std");
const File = std.fs.File;
const fmt = std.fmt;

pub fn solve() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = &arena.allocator;

    var file = try std.fs.cwd().openFile("src/advent2020/day2/input.txt", .{});
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

    // std.log.info("values: {d}", .{all_values.items});

    var found_part_one = false;
    var found_part_two = false;

    for (all_values.items) |val, idx| {
        for (all_values.items) |other_val, other_idx| {
            if (other_idx == idx) {
                continue;
            }

            if (val + other_val == 2020 and !found_part_one) {
                std.log.info("answer is {d}", .{val * other_val});
                found_part_one = true;
            }

            for (all_values.items) |third_val, third_idx| {
                if (third_idx == idx or third_idx == other_idx) {
                    continue;
                }

                if (val + other_val + third_val == 2020 and !found_part_two) {
                    std.log.info("answer is {d}", .{val * other_val * third_val});
                    found_part_two = true;
                }
            }
        }
    }
}
