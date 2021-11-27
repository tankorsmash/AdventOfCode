const std = @import("std");
const File = std.fs.File;
const fmt = std.fmt;

const load_input = @import("../shared/load_input.zig");

const c = @cImport({
       @cInclude("curl/curl.h");
});
var curl = c.curl_easy_init();

pub fn solve() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = &arena.allocator;

    const day = 4;
    var all_values = load_input.load_input_line_bytes(allocator, day) catch |err| {
        std.log.err("error loading input for Day {d}! {any}", .{ day, err });
        return;
    };

    for (all_values.items) |arr_bytes, row_idx| {
        _ = arr_bytes;
        _ = row_idx;
    }

    std.log.info("Advent Day {d} Part 1:: {d}", .{ day, 122 });
    std.log.info("Advent Day {d} Part 2:: {d}", .{ day, 123 });
}
