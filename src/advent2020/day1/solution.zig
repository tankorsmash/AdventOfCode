const std = @import("std");
const File = std.fs.File;
// const io = @import("stdio");

pub fn solve(x: i32, y: i32) anyerror!i32 {
    var file = try std.fs.cwd().openFile("src/advent2020/day1/input.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        // do something with line...
        std.log.info("Reading line: {s}", .{line});
    }
    return x+y;
}
