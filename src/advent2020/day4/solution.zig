const std = @import("std");
const File = std.fs.File;
const fmt = std.fmt;

const load_input = @import("../shared/load_input.zig");

const c = @cImport(@cInclude("C:/code/utils/vcpkg/installed/x64-windows/include/curl/curl.h"));

pub fn myfunc(ptr: []u8, size: u32, nmemb: u32, userdata: *c_void) void {
    _ = ptr;
    _ = size;
    _ = nmemb;
    _ = userdata;
    std.log.info("size of resp to write: {d}", .{size});

    // _ = std.c.realloc(userdata, size+1);

    var valid_data_ptr: *[]u8 = @ptrCast(*[]u8, @alignCast(@alignOf([]u8), userdata));
    _ = valid_data_ptr;

    std.log.info("cast is done", .{});

    var realsize = size * nmemb;
    std.log.info("realsize is: {d}", .{realsize});
    // var some_ptr:u8 = std.c.realloc(userdata, size*nmemb).?;
    // var some_ptr:u8 = std.c.realloc(userdata, size*nmemb).?;

    // var some_ptr_nullable:?*c_void = std.c.realloc(valid_data_ptr, size*nmemb);
    std.log.info("realloc is done", .{});
    // if (some_ptr_nullable == null) {
    //     std.log.err("some_ptr_nullable is null", .{});
    //     return;
    // } else {
    //     std.log.info("some_ptr_nullable is NOT NULL YAY", .{});
    // }
    // var some_ptr:*c_void = some_ptr_nullable.?;
    // _ = some_ptr;

    var some_valid_ptr: *[]u8 = @ptrCast(*[]u8, @alignCast(@alignOf([]u8), userdata));
    _ = some_valid_ptr;
    var some_valid_data = some_valid_ptr.*;
    _ = some_valid_data;
    std.log.info("some data cast is done", .{});

    var valid_data: []u8 = valid_data_ptr.*;
    _ = valid_data;
    // std.log.info("\n\nPTR IS: {any}\n", .{ptr});
    std.log.info("\n\nVALID_DATA: {any}\n", .{valid_data});

    // std.mem.copy([]u8, @ptrCast(u8, userdata), ptr);
    // std.mem.copy(u8, valid_data[0..10], ptr[0..1]);

    // std.log.info("{any} {d} {d} {d}", .{ptr, size, nmemb, userdata});
    // std.log.info("\n\nSTART {any}\n", .{valid_data});
}

pub fn solve() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = &arena.allocator;

    var curl = c.curl_easy_init();
    defer c.curl_easy_cleanup(curl);

    if (curl != null) {
        std.log.info("curl loaded", .{});

        _ = c.curl_easy_setopt(curl, c.CURLOPT_URL, "http://httpbin.org/get");
        _ = c.curl_easy_setopt(curl, c.CURLOPT_FOLLOWLOCATION, @intCast(i32, 1));

        _ = c.curl_easy_setopt(curl, c.CURLOPT_WRITEFUNCTION, myfunc);

        var chunk: []u8 = try allocator.alloc(u8, 256*100 );
        _ = c.curl_easy_setopt(curl, c.CURLOPT_WRITEDATA, chunk);

        var res = c.curl_easy_perform(curl);
        std.log.info("done performing the web request", .{});

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
