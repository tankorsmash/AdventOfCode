const std = @import("std");
const File = std.fs.File;
const fmt = std.fmt;

const load_input = @import("../shared/load_input.zig");

pub fn solve() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = &arena.allocator;

    const day = 2;
    var all_values = load_input.load_input_line_bytes(allocator, day) catch |err| {
        std.log.err("error loading input for Day {d}! {any}", .{ day, err });
        return;
    };
    var str: *const [3:0]u8 = "asd";
    _ = str;

    for (all_values.items) |arr_bytes| {
        var bytes: []u8 = arr_bytes.items;
        // var text: *const [11:0]u8 = "word1 WORD2";

        std.log.info("pre-split: {s}", .{bytes});

        //ie 13-17, s:, ssssssssssssssssgssj
        var split_iter = std.mem.split(u8, bytes, " ");
        // var split_iter = std.mem.split(u8, text, " ");
        _ = split_iter;

        //ie 13-17
        var raw_count_rule = split_iter.next().?;
        var split_count_rule = std.mem.split(u8, raw_count_rule, "-");
        _ = raw_count_rule;

        //ie 13
        var raw_count_min = split_count_rule.next().?;
        _ = raw_count_min;
        var count_min: i32 = try fmt.parseInt(i32, raw_count_min[0..], 10);
        _ = count_min;

        //ie 17
        var raw_count_max = split_count_rule.next().?;
        _ = raw_count_max;
        var count_max = try fmt.parseInt(i32, raw_count_max[0..], 10);
        _ = count_max;

        //ie s:
        var raw_char_rule = split_iter.next().?;
        _ = raw_char_rule;
        //ie s, since its always one character
        var char_rule: []u8  = try fmt.allocPrint(allocator, "{s}", .{raw_char_rule[0..1]});
        _ = char_rule;
        std.log.info("char rule {s}", .{char_rule});


        //ie ssssssssssssssssgssj
        var raw_password = split_iter.next().?;
        _ = raw_password;

        var char_appearances:usize = std.mem.count(u8, raw_password, char_rule);
        // @compileLog(@TypeOf(char_appearances));
        std.log.info("char_appearances: {d}", .{char_appearances});

        // const stringed = try fmt.allocPrint(allocator, "{s}", .{splitted});
        std.log.info("happy: {s}", .{try fmt.allocPrint(allocator, "{s}", .{raw_count_rule})});
    }
}
