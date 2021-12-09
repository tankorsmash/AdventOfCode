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

const cols: i32 = 100;
const rows: i32 = 100;

pub fn rev_lookup(coord: i32) [2]i32 {
    var x: i32 = @mod(coord, cols);
    var y: i32 = @divFloor((coord - x), cols);

    return [2]i32{ x, y };
}
pub fn lookup(x: i32, y: i32) i32 {
    return cols * y + x;
}

const offsets = [_][2]i32{
    [2]i32{ -1, -1 },
    [2]i32{ -1, 0 },
    [2]i32{ -1, 1 },
    [2]i32{ 0, -1 },
    // [2]i32{0, 0},
    [2]i32{ 0, 1 },
    [2]i32{ 1, -1 },
    [2]i32{ 1, 0 },
    [2]i32{ 1, 1 },
};

pub fn is_lower_than_neighbors(map: std.ArrayList(u8), x: usize, y: usize, cur_val: u8) bool {
    for (offsets) |offset| {
        var ox: i32 = @intCast(i32, x) + offset[0];
        var oy: i32 = @intCast(i32, y) + offset[1];
        var offset_idx: i32 = lookup(ox, oy);
        if (ox >= 0 and ox < cols and oy >= 0 and oy < rows and offset_idx <= std.mem.len(map.items) and offset_idx >= 0) {
            var offset_val = map.items[@intCast(usize, offset_idx)];

            if (cur_val >= offset_val) {
                return false;
            }
        }
    }

    return true;
}

pub fn solve() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = &arena.allocator;
    const day = 9;

    var all_values = load_input.load_input_line_bytes_2021(allocator, day) catch |err| {
        std.log.err("error loading input for Day {d}! {any}", .{ day, err });
        return err;
    };

    var height_map = std.ArrayList(u8).init(allocator);

    for (all_values.items) |line| {
        _ = line;
        for (line.items) |digit| {
            try height_map.append(@intCast(u8, try parse_u32(([_]u8{digit})[0..])));
        }
    }

    var total_risk_level: i32 = 0;

    for (height_map.items) |height, height_idx| {
        _ = height;
        var xy = rev_lookup(@intCast(i32, height_idx));
        if (is_lower_than_neighbors(height_map, @intCast(usize, xy[0]), @intCast(usize, xy[1]), height)) {
            info("lower {d} idx {d}, {any}", .{ height, height_idx, xy });
            total_risk_level += height + 1;
        }
    }

    std.log.info("Advent 2021 Day {d} Part 1:: {d}", .{ day, total_risk_level }); //not 34128, not 574, not 560, not 578
    // std.log.info("Advent 2021 Day {d} Part 2:: {d}", .{ day, running_total });

    std.log.info("done", .{});
}
