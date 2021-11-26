const std = @import("std");
const File = std.fs.File;
const fmt = std.fmt;
const bufPrint = std.fmt.bufPrint;


pub fn load_input(day: u32) anyerror!std.ArrayList(i32) {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    // defer arena.deinit(); //if i uncomment this, the array gets destroyed

    const allocator = &arena.allocator;

    var filename = try fmt.allocPrint(allocator, "src/advent2020/day{d}/input.txt", .{day});
    // defer allocator.free(filename);

    // var filename: [256]u8 = undefined;
    //
    // _ = try bufPrint(&filename, "src/advent2020/day{d}/input.txt", .{day});

    std.log.info("loaded filename: {s}", .{filename});

    var file = try std.fs.cwd().openFile(filename, .{});
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
    return all_values;
}
