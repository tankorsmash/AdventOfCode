const std = @import("std");
const File = std.fs.File;
const fmt = std.fmt;
const info = std.log.info;

pub fn log(comptime format: []const u8) void {
    info(format, .{});
}

const load_input = @import("./../../advent2020/shared/load_input.zig");

pub fn parse_u32(bytes: []const u8) std.fmt.ParseIntError!u32 {
    var value: u32 = std.fmt.parseUnsigned(u32, bytes, 10) catch |err| {
        if (err == error.InvalidCharacter) {
            std.log.err("err: Invalid Character: '{s}' -- '{d}'", .{ bytes, bytes });
            return 0;
        }

        std.log.err("err {}: Unknown error parsing int: {any}", .{ err, bytes });

        return 0;
    };

    return value;
}
pub fn parse_i32(bytes: []const u8) std.fmt.ParseIntError!i32 {
    var value: i32 = std.fmt.parseUnsigned(i32, bytes, 10) catch |err| {
        if (err == error.InvalidCharacter) {
            std.log.err("err: Invalid Character: '{s}' -- '{d}'", .{ bytes, bytes });
            return 0;
        }

        std.log.err("err {}: Unknown error parsing int: {any}", .{ err, bytes });

        return 0;
    };

    return value;
}

pub const CrabCount = struct { pos: i32, count: i32 };

pub fn sort_crabs_by_count(desc: bool, left: CrabCount, right: CrabCount) bool {
    // pub fn sort_crabs_by_count (left: CrabCount, right:CrabCount) bool {
    // _ = context;
    if (desc) {
        return left.count > right.count;
    }

    return left.count < right.count;
}

const num_segments_1: i32 = 2; //unique
const num_segments_2: i32 = 5; //   ooo
const num_segments_3: i32 = 5; //   ooo
const num_segments_4: i32 = 4; //unique
const num_segments_5: i32 = 5; //   ooo
const num_segments_6: i32 = 6; //---
const num_segments_7: i32 = 3; //unique
const num_segments_8: i32 = 7; //unique
const num_segments_9: i32 = 6; //---
const num_segments_0: i32 = 6; //---

pub const Display = struct {
    digit_1: [num_segments_1]u8 = [_]u8{ 0, 0 },
    digit_2: [num_segments_2]u8 = [_]u8{ 0, 0, 0, 0, 0 },
    digit_3: [num_segments_3]u8 = [_]u8{ 0, 0, 0, 0, 0 },
    digit_4: [num_segments_4]u8 = [_]u8{ 0, 0, 0, 0 },
    digit_5: [num_segments_5]u8 = [_]u8{ 0, 0, 0, 0, 0 },
    digit_6: [num_segments_6]u8 = [_]u8{ 0, 0, 0, 0, 0, 0 },
    digit_7: [num_segments_7]u8 = [_]u8{ 0, 0, 0 },
    digit_8: [num_segments_8]u8 = [_]u8{ 0, 0, 0, 0, 0, 0, 0 },
    digit_9: [num_segments_9]u8 = [_]u8{ 0, 0, 0, 0, 0, 0 },
    digit_0: [num_segments_0]u8 = [_]u8{ 0, 0, 0, 0, 0, 0 },

    segment_a: u8 = 0,
    segment_b: u8 = 0,
    segment_c: u8 = 0,
    segment_d: u8 = 0,
    segment_e: u8 = 0,
    segment_f: u8 = 0,
    segment_g: u8 = 0,
};

pub fn solve() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = &arena.allocator;
    const day = 8;

    var all_values = load_input.load_input_line_bytes_2021(allocator, day) catch |err| {
        std.log.err("error loading input for Day {d}! {any}", .{ day, err });
        return err;
    };

    var crabs = std.ArrayList(i32).init(allocator);
    _ = crabs;

    for (all_values.items) |line| {
        var section_split = std.mem.split(u8, line.items, " | ");

        var displays = std.ArrayList(std.ArrayList(u8)).init(allocator);
        var outputs = std.ArrayList(std.ArrayList(u8)).init(allocator);

        //parse displays
        var displays_split = std.mem.split(u8, section_split.next().?, " ");
        while (displays_split.next()) |display| {
            var single_display = std.ArrayList(u8).init(allocator);
            for (display) |d| {
                try single_display.append(d);
            }
            try displays.append(single_display);
        }

        //parse output
        var output_split = std.mem.split(u8, section_split.next().?, " ");
        while (output_split.next()) |output| {
            var single_output = std.ArrayList(u8).init(allocator);
            for (output) |d| {
                try single_output.append(d);
            }
            try outputs.append(single_output);
        }

        var ddd = Display{};
        _ = ddd;

        //pick out the unique digits (1, 4, 7, 8) and put into Display
        for (displays.items) |display| {
            var length: usize = std.mem.len(display.items);

            info("display len {d}", .{length});

            switch (length) {
                num_segments_1 => {
                    ddd.digit_1 = display.items[0..num_segments_1].*;
                },
                num_segments_4 => {
                    ddd.digit_4 = display.items[0..num_segments_4].*;
                },
                num_segments_7 => {
                    ddd.digit_7 = display.items[0..num_segments_7].*;
                },
                num_segments_8 => {
                    ddd.digit_8 = display.items[0..num_segments_8].*;
                },
                else => {},
            }
            info("ddd {any}", .{ddd});
        }

        //figure out known segments
        // aaa is whatever one isn't shared by 7 and 1
    }

    // std.log.info("Advent 2021 Day {d} Part 1:: {d}", .{ day, part1_smallest_total_fuel });
    // std.log.info("Advent 2021 Day {d} Part 2:: {d}", .{ day, part2_smallest_total_fuel });

    std.log.info("done", .{});
}
