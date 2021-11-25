const std = @import("std");
const File = std.fs.File;
// const io = @import("stdio");

pub fn solve(x: i32, y: i32) anyerror!i32 {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = &arena.allocator;

    var file = try std.fs.cwd().openFile("src/advent2020/day1/input.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();


    var all_lines: std.ArrayList([]u8) = std.ArrayList([]u8).init(allocator);
    _ = all_lines;

    var line_buf: [5]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&line_buf, '\n')) |line| {
        // do something with line...
        std.log.info("Reading line: {s}", .{line});

        try all_lines.append(line);
    }
    return x+y;
}
