const std = @import("std");
const File = std.fs.File;
const fmt = std.fmt;

const load_input = @import("../shared/load_input.zig");

const c = @cImport(@cInclude("C:/code/utils/vcpkg/installed/x64-windows/include/curl/curl.h"));

pub fn solve() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = &arena.allocator;

    var curl = c.curl_easy_init();
    defer c.curl_easy_cleanup(curl);

    if (curl != null) {
        std.log.info("curl loaded", .{});

        _ = c.curl_easy_setopt(curl, c.CURLOPT_URL, "http://httpbin.org/get");

        var res = c.curl_easy_perform(curl);

        if (res != c.CURLE_OK) {
            std.log.err("CURL ERROR: {d}", .{res});
        }
    }

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
