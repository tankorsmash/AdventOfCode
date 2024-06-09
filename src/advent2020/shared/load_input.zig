const std = @import("std");
const File = std.fs.File;
const fmt = std.fmt;
const bufPrint = std.fmt.bufPrint;

pub fn load_input_line_bytes_2021(allocator: *std.mem.Allocator, day: u32) anyerror!std.ArrayList(std.ArrayList(u8)) {
    var filename = try fmt.allocPrint(allocator.*, "src/advent2021/day{d}/input.txt", .{day});

    std.log.info("loaded filename: {s}", .{filename});

    var file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var all_values: std.ArrayList(std.ArrayList(u8)) = std.ArrayList(std.ArrayList(u8)).init(allocator.*);

    var line_buf: [2048*16]u8 = undefined; //TODO figure out if this is a good idea or not. seems like its just asking for trouble once I get more data in here again
    while (try in_stream.readUntilDelimiterOrEof(&line_buf, '\n')) |raw_line| {
        var line = std.mem.trimRight(u8, raw_line, "\r\n");

        var inner_arr = std.ArrayList(u8).init(allocator.*);
        for (line) |c| {
            try inner_arr.append(c);
        }
        try all_values.append(inner_arr);
    }

    // std.log.info("values: {d}", .{all_values.items});
    return all_values;
}
pub fn load_input_line_bytes(allocator: *std.mem.Allocator, day: u32) anyerror!std.ArrayList(std.ArrayList(u8)) {
    var filename = try fmt.allocPrint(allocator, "src/advent2020/day{d}/input.txt", .{day});

    std.log.info("loaded filename: {s}", .{filename});

    var file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var all_values: std.ArrayList(std.ArrayList(u8)) = std.ArrayList(std.ArrayList(u8)).init(allocator);

    var line_buf: [2048]u8 = undefined; //TODO figure out if this is a good idea or not. seems like its just asking for trouble once I get more data in here again
    while (try in_stream.readUntilDelimiterOrEof(&line_buf, '\n')) |raw_line| {
        var line = std.mem.trimRight(u8, raw_line, "\r\n");

        var inner_arr = std.ArrayList(u8).init(allocator);
        for (line) |c| {
            try inner_arr.append(c);
        }
        try all_values.append(inner_arr);
    }

    // std.log.info("values: {d}", .{all_values.items});
    return all_values;
}

pub fn load_input_i32(allocator: *std.mem.Allocator, day: u32) anyerror!std.ArrayList(i32) {
    var raw_values = try load_input_line_bytes(allocator, day);

    var all_values: std.ArrayList(i32) = std.ArrayList(i32).init(allocator);

    for (raw_values.items) |inner_arr| {
        const guess = fmt.parseInt(i32, inner_arr.items[0..], 10) catch {
            std.log.info("Invalid number: {d}\n", .{inner_arr.items[0..]});
            continue;
        };
        try all_values.append(guess);
    }

    return all_values;
}

pub fn load_input_i32_2021(allocator: *std.mem.Allocator, day: u32) anyerror!std.ArrayList(i32) {
    var raw_values = try load_input_line_bytes_2021(allocator, day);

    var all_values: std.ArrayList(i32) = std.ArrayList(i32).init(allocator);

    for (raw_values.items) |inner_arr| {
        const guess = fmt.parseInt(i32, inner_arr.items[0..], 10) catch {
            std.log.info("Invalid number: {d}\n", .{inner_arr.items[0..]});
            continue;
        };
        try all_values.append(guess);
    }

    return all_values;
}
