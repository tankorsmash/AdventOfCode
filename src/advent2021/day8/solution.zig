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
    digit_1_found: bool = false,
    digit_2: [num_segments_2]u8 = [_]u8{ 0, 0, 0, 0, 0 },
    digit_2_found: bool = false,
    digit_3: [num_segments_3]u8 = [_]u8{ 0, 0, 0, 0, 0 },
    digit_3_found: bool = false,
    digit_4: [num_segments_4]u8 = [_]u8{ 0, 0, 0, 0 },
    digit_4_found: bool = false,
    digit_5: [num_segments_5]u8 = [_]u8{ 0, 0, 0, 0, 0 },
    digit_5_found: bool = false,
    digit_6: [num_segments_6]u8 = [_]u8{ 0, 0, 0, 0, 0, 0 },
    digit_6_found: bool = false,
    digit_7: [num_segments_7]u8 = [_]u8{ 0, 0, 0 },
    digit_7_found: bool = false,
    digit_8: [num_segments_8]u8 = [_]u8{ 0, 0, 0, 0, 0, 0, 0 },
    digit_8_found: bool = false,
    digit_9: [num_segments_9]u8 = [_]u8{ 0, 0, 0, 0, 0, 0 },
    digit_9_found: bool = false,
    digit_0: [num_segments_0]u8 = [_]u8{ 0, 0, 0, 0, 0, 0 },
    digit_0_found: bool = false,

    unknown_5_lens: std.ArrayList(std.ArrayList(u8)),
    unknown_6_lens: std.ArrayList(std.ArrayList(u8)),
    // unknown_6_lens : [3][6]u8 = [3][6]u8{
    //     [6]u8{ 0, 0, 0, 0, 0, 0 },
    //     [6]u8{ 0, 0, 0, 0, 0, 0 },
    //     [6]u8{ 0, 0, 0, 0, 0, 0 },},

    segment_a: u8 = 0,
    segment_b: u8 = 0,
    segment_c: u8 = 0,
    segment_d: u8 = 0,
    segment_e: u8 = 0,
    segment_f: u8 = 0,
    segment_g: u8 = 0,
};
pub const Output = struct {
    digit_1: [num_segments_1]u8 = [_]u8{ 0, 0 },
    digit_1_found: bool = false,
    digit_2: [num_segments_2]u8 = [_]u8{ 0, 0, 0, 0, 0 },
    digit_2_found: bool = false,
    digit_3: [num_segments_3]u8 = [_]u8{ 0, 0, 0, 0, 0 },
    digit_3_found: bool = false,
    digit_4: [num_segments_4]u8 = [_]u8{ 0, 0, 0, 0 },
    digit_4_found: bool = false,
    digit_5: [num_segments_5]u8 = [_]u8{ 0, 0, 0, 0, 0 },
    digit_5_found: bool = false,
    digit_6: [num_segments_6]u8 = [_]u8{ 0, 0, 0, 0, 0, 0 },
    digit_6_found: bool = false,
    digit_7: [num_segments_7]u8 = [_]u8{ 0, 0, 0 },
    digit_7_found: bool = false,
    digit_8: [num_segments_8]u8 = [_]u8{ 0, 0, 0, 0, 0, 0, 0 },
    digit_8_found: bool = false,
    digit_9: [num_segments_9]u8 = [_]u8{ 0, 0, 0, 0, 0, 0 },
    digit_9_found: bool = false,
    digit_0: [num_segments_0]u8 = [_]u8{ 0, 0, 0, 0, 0, 0 },
    digit_0_found: bool = false,

    unknown_5_lens: std.ArrayList(std.ArrayList(u8)),
    unknown_6_lens: std.ArrayList(std.ArrayList(u8)),
    // unknown_6_lens : [3][6]u8 = [3][6]u8{
    //     [6]u8{ 0, 0, 0, 0, 0, 0 },
    //     [6]u8{ 0, 0, 0, 0, 0, 0 },
    //     [6]u8{ 0, 0, 0, 0, 0, 0 },},

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

    var unique_digits_found: u32 = 0;

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

        var ddd = Display{
            .unknown_5_lens = std.ArrayList(std.ArrayList(u8)).init(allocator),
            .unknown_6_lens = std.ArrayList(std.ArrayList(u8)).init(allocator),
        };
        var ooo = Output{
            .unknown_5_lens = std.ArrayList(std.ArrayList(u8)).init(allocator),
            .unknown_6_lens = std.ArrayList(std.ArrayList(u8)).init(allocator),
        };

        //pick out the unique digits (1, 4, 7, 8) and put into Display
        for (displays.items) |display, d_idx| {
            _ = d_idx;
            var length: usize = std.mem.len(display.items);
            // info("eval d_idx {d}", .{d_idx});

            switch (length) {
                num_segments_1 => {
                    ddd.digit_1 = display.items[0..num_segments_1].*;
                    ddd.digit_1_found = true;
                    // unique_digits_found += 1;
                    // info("found unique {u}", .{display.items});
                },
                num_segments_4 => {
                    ddd.digit_4 = display.items[0..num_segments_4].*;
                    ddd.digit_4_found = true;
                    // unique_digits_found += 1;
                    // info("found unique {u}", .{display.items});
                },
                num_segments_7 => {
                    ddd.digit_7 = display.items[0..num_segments_7].*;
                    ddd.digit_7_found = true;
                    // unique_digits_found += 1;
                    // info("found unique {u}", .{display.items});
                },
                num_segments_8 => {
                    ddd.digit_8 = display.items[0..num_segments_8].*;
                    ddd.digit_8_found = true;
                    // unique_digits_found += 1;
                    // info("found unique {u}", .{display.items});
                },

                5 => {
                    try ddd.unknown_5_lens.append(display);
                },
                6 => {
                    try ddd.unknown_6_lens.append(display);
                },
                else => {},
            }
            // info("ddd {any}", .{ddd});
        }
        //pick out the unique digits (1, 4, 7, 8) and put into output
        for (outputs.items) |output, o_idx| {
            _ = o_idx;
            var length: usize = std.mem.len(output.items);
            // info("eval o_idx {d}", .{o_idx});

            switch (length) {
                num_segments_1 => {
                    ooo.digit_1 = output.items[0..num_segments_1].*;
                    ooo.digit_1_found = true;
                    unique_digits_found += 1;
                    // info("found unique {u}", .{output.items});
                },
                num_segments_4 => {
                    ooo.digit_4 = output.items[0..num_segments_4].*;
                    ooo.digit_4_found = true;
                    unique_digits_found += 1;
                    // info("found unique {u}", .{output.items});
                },
                num_segments_7 => {
                    ooo.digit_7 = output.items[0..num_segments_7].*;
                    ooo.digit_7_found = true;
                    unique_digits_found += 1;
                    // info("found unique {u}", .{output.items});
                },
                num_segments_8 => {
                    ooo.digit_8 = output.items[0..num_segments_8].*;
                    ooo.digit_8_found = true;
                    unique_digits_found += 1;
                    // info("found unique {u}", .{output.items});
                },

                5 => {
                    try ooo.unknown_5_lens.append(output);
                },
                6 => {
                    try ooo.unknown_6_lens.append(output);
                },
                else => {},
            }
            // info("ooo {any}", .{ooo});
        }

        //figure out known segments
        // aaa is whatever one isn't shared by 7 and 1
        std.debug.assert(ddd.digit_7_found and ddd.digit_1_found);
        var segment_a: ?u8 = null;
        for (ddd.digit_7) |char_7| {
            var found_match = false;
            for (ddd.digit_1) |char_1| {
                if (char_1 == char_7) {
                    found_match = true;
                    break;
                }
            }
            if (!found_match) {
                segment_a = char_7;
            }
        }
        std.debug.assert(segment_a != null);
        info("segment_a: {u}", .{segment_a});

        //numbers 2, 3, and 5 all share 3 segments.
        // 2 and 5 contain two segments the other doesn't have
        // 3 shares one with 5 and one with 2
        for (ddd.unknown_5_lens.items) |len5, top_idx| {
            var total_num_matches = std.ArrayList(i32).init(allocator);
            //loop through all the other abcde's that exist
            for (ddd.unknown_5_lens.items) |bot_len5, bot_idx| {
                if (top_idx == bot_idx) {
                    continue;
                }
                var num_matches: i32 = 0;
                //loop through abcde's segment letters
                for (len5.items) |top_char| {
                    //skip checking own series

                    //count the number of matching abcde's in the bot_char
                    for (bot_len5.items) |bot_char| {
                        // info("top_char {u} bot_char {u}", .{top_char, bot_char});
                        if (bot_char == top_char) {
                            num_matches += 1;
                        }
                    }
                }
                try total_num_matches.append(num_matches);
                // info("top_idx #{d}'s found {d} num_matches with #{d}", .{ top_idx, num_matches, bot_idx });
            }

            // if (std.mem.indexOf(i32, total_num_matches.items, @intCast(i32, 3)) != null) {
            const needle = [1]i32{3};
            if (std.mem.indexOf(i32, total_num_matches.items, needle[0..]) != null) {
                info("{d} is a 2 or 5, because {any}", .{ top_idx, total_num_matches.items });
            } else {
                info("{d} is a 3, because {any}", .{ top_idx, total_num_matches.items });

                //copy into digit 3, and remove it
                for (ddd.unknown_5_lens.items[top_idx].items[0..5]) |c, c_idx| {
                    ddd.digit_3[c_idx] = c;
                }
                ddd.digit_3_found = true;
                _ = ddd.unknown_5_lens.orderedRemove(top_idx);
                // info("unknowns are now {any}", .{ddd.unknown_5_lens.items});
            }
        }

        //the segment in 4 that isn't in 3, is segment B
        std.debug.assert(ddd.digit_4_found and ddd.digit_3_found);
        var segment_b: ?u8 = null;
        for (ddd.digit_4) |char_4| {
            var found_match = false;
            for (ddd.digit_3) |char_3| {
                if (char_3 == char_4) {
                    found_match = true;
                    break;
                }
            }
            if (!found_match) {
                segment_b = char_4;
            }
        }
        std.debug.assert(segment_b != null);
        ddd.segment_b = segment_b.?;
        info("segment_b: {u}", .{segment_b});

        //number 2 is the remaining unknown_5_lens that doesn't contain
        // segment B
        var len5 = ddd.unknown_5_lens.items[0];
        const needle = [1]u8{ddd.segment_b};
        var contains_seg_b = std.mem.indexOf(u8, len5.items, needle[0..]);
        if (contains_seg_b != null) {
            //copy into digit 5, and remove it
            for (ddd.unknown_5_lens.items[0].items[0..5]) |c, c_idx| {
                ddd.digit_5[c_idx] = c;
            }
            ddd.digit_5_found = true;
            _ = ddd.unknown_5_lens.orderedRemove(0);

            //copy into digit 5, and remove it
            for (ddd.unknown_5_lens.items[0].items[0..5]) |c, c_idx| {
                ddd.digit_2[c_idx] = c;
            }
            ddd.digit_2_found = true;
            _ = ddd.unknown_5_lens.orderedRemove(0);
        } else {
            //copy into digit 5, and remove it
            for (ddd.unknown_5_lens.items[0].items[0..5]) |c, c_idx| {
                ddd.digit_2[c_idx] = c;
            }
            ddd.digit_2_found = true;
            _ = ddd.unknown_5_lens.orderedRemove(0);

            //copy into digit 5, and remove it
            for (ddd.unknown_5_lens.items[0].items[0..5]) |c, c_idx| {
                ddd.digit_5[c_idx] = c;
            }
            ddd.digit_5_found = true;
            _ = ddd.unknown_5_lens.orderedRemove(0);
        }

        //the segment in 1 that isn't in an unknown_6_lens, is number 6
        std.debug.assert(ddd.digit_1_found);
        for (ddd.unknown_6_lens.items) |bot_len6, bot_idx| {
            var num_matches: i32 = 0;
            for (ddd.digit_1) |char_1| {
                for (bot_len6.items) |len6_char| {
                    if (len6_char == char_1) {
                        num_matches += 1;
                    }
                }
            }
            if (num_matches != 2) {
                // info("len6 {any} is number 6, {d}", .{ bot_len6.items, num_matches });

                //copy into digit 6, and remove it
                for (ddd.unknown_6_lens.items[bot_idx].items[0..6]) |c, c_idx| {
                    ddd.digit_6[c_idx] = c;
                }
                ddd.digit_6_found = true;
                _ = ddd.unknown_6_lens.orderedRemove(bot_idx);

                break;
            }
        }

        //5 is in 9 but not 0
        std.debug.assert(ddd.digit_5_found);
        for (ddd.unknown_6_lens.items) |bot_len6, bot_idx| {
            var num_matches: i32 = 0;
            for (ddd.digit_5) |char_5| {
                for (bot_len6.items) |len6_char| {
                    if (len6_char == char_5) {
                        num_matches += 1;
                    }
                }
            }
            if (num_matches != 5) {
                // info("len6 {any} is number 6, {d}", .{ bot_len6.items, num_matches });

                //copy into digit 0, and remove it
                for (ddd.unknown_6_lens.items[bot_idx].items[0..6]) |c, c_idx| {
                    ddd.digit_0[c_idx] = c;
                }
                ddd.digit_0_found = true;
                _ = ddd.unknown_6_lens.orderedRemove(bot_idx);

                //copy into digit 9, and remove it
                for (ddd.unknown_6_lens.items[0].items[0..6]) |c, c_idx| {
                    ddd.digit_9[c_idx] = c;
                }
                ddd.digit_9_found = true;
                _ = ddd.unknown_6_lens.orderedRemove(0);

                break;
            }
        }

        // info("digit_1_found {b}", .{ddd.digit_1_found});
        // info("digit_2_found {b}", .{ddd.digit_2_found});
        // info("digit_3_found {b}", .{ddd.digit_3_found});
        // info("digit_4_found {b}", .{ddd.digit_4_found});
        // info("digit_5_found {b}", .{ddd.digit_5_found});
        // info("digit_6_found {b}", .{ddd.digit_6_found});
        // info("digit_7_found {b}", .{ddd.digit_7_found});
        // info("digit_8_found {b}", .{ddd.digit_8_found});
        // info("digit_9_found {b}", .{ddd.digit_9_found});
        // info("digit_0_found {b}", .{ddd.digit_0_found});

        // info("segment_a -> {u}", .{ddd.segment_a});
        // info("segment_b -> {u}", .{ddd.segment_b});
        // info("segment_c -> {u}", .{ddd.segment_c});
        // info("segment_d -> {u}", .{ddd.segment_d});
        // info("segment_e -> {u}", .{ddd.segment_e});
        // info("segment_f -> {u}", .{ddd.segment_f});
        // info("segment_g -> {u}", .{ddd.segment_g});

        // //segment E is what isn't shared by 8 and 9
        // std.debug.assert(ddd.digit_8_found and ddd.digit_9_found);
        // var segment_e: ?u8 = null;
        // for (ddd.digit_8) |char_8| {
        //     var found_match = false;
        //     for (ddd.digit_9) |char_9| {
        //         if (char_9 == char_8) {
        //             found_match = true;
        //             break;
        //         }
        //     }
        //     if (!found_match) { segment_e = char_8; }
        // }
        // std.debug.assert(segment_e != null);
        // info("segment_e: {u}", .{segment_e});

        // //segment C is what isn't shared by 8 and 6
        // var segment_c: ?u8 = null;
        // for (ddd.digit_8) |char_8| {
        //     var found_match = false;
        //     for (ddd.digit_6) |char_6| {
        //         if (char_6 == char_8) {
        //             found_match = true;
        //             break;
        //         }
        //     }
        //     if (!found_match) { segment_c = char_8; }
        // }
        // std.debug.assert(segment_c != null);
        // info("segment_c: {u}", .{segment_c});

    }

    std.log.info("Advent 2021 Day {d} Part 1:: {d}", .{ day, unique_digits_found });
    // std.log.info("Advent 2021 Day {d} Part 2:: {d}", .{ day, part2_smallest_total_fuel });

    std.log.info("done", .{});
}
