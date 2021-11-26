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
        std.log.err("error loading input for Day {d}! {any}", .{day, err});
        return ;
    };

    for (all_values.items) |bytes| {
        const guess: []u8 = try fmt.allocPrint(allocator, "{s}", .{bytes.items});
        // const guess = fmt.parseInt([]u8, bytes.items[0..], 10) catch |err| {
        //     std.log.info("err: {any}\n", .{err});
        //     std.log.info("Invalid number: {d}\n", .{bytes.items[0..]});
        //     continue;
        // };

        //TODO make `guess` be an actual ascii string, because allocPrint doesn't do it
        std.log.info("happy: {s}", .{guess});
    }
}
