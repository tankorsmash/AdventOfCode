const std = @import("std");
const File = std.fs.File;
const fmt = std.fmt;
const info = std.log.info;

pub fn log(comptime format: []const u8,) void { info(format, .{}); }

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

pub const CrabCount = struct { pos : i32, count: i32};

pub fn sort_crabs_by_count (desc: bool, left: CrabCount, right:CrabCount) bool {
// pub fn sort_crabs_by_count (left: CrabCount, right:CrabCount) bool {
    // _ = context;
    if (desc) { return left.count > right.count; }

    return left.count < right.count;
}

pub fn solve() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = &arena.allocator;
    const day = 7;

    var all_values = load_input.load_input_line_bytes_2021(allocator, day) catch |err| {
        std.log.err("error loading input for Day {d}! {any}", .{ day, err });
        return err;
    };

    var crabs = std.ArrayList(i32).init(allocator);
    var counter_map = std.AutoHashMap(i32, i32).init(allocator);

    for (all_values.items) |line| {
        var splitter = std.mem.split(u8, line.items, ",");
        while (splitter.next()) |raw_crab| {
            var crab = try parse_i32(raw_crab);

            var counted:?i32 = counter_map.get(crab);
            var new_counted : i32 = undefined;
            if (counted != null) {
                new_counted = counted.? + 1;
            } else {
                new_counted = 1;
            }
            try counter_map.put(crab, new_counted);

            try crabs.append(crab);
        }
    }

    var crab_count = std.ArrayList(CrabCount).init(allocator);

    var counter_map_it = counter_map.iterator();
    while (counter_map_it.next()) |counted| {
        // info("counter_map:: {d} - {d}", .{counted.key_ptr.*, counted.value_ptr.*});
        try crab_count.append(CrabCount{.pos = counted.key_ptr.*, .count= counted.value_ptr.*});
    }

    const min_crab_pos:i32 = std.mem.min(i32, crabs.items);
    const max_crab_pos:i32 = std.mem.max(i32, crabs.items);
    info("min {d} max {d}", .{min_crab_pos, max_crab_pos});

    var dest:i32 = 0;
    var part1_smallest_total_fuel: i32 =  999999999;
    var part2_smallest_total_fuel: i32 =  999999999;
    while (dest <= max_crab_pos) : (dest += 1)  {
        var part1_total_fuel:i32 = 0;
        var part2_total_fuel:i32 = 0;
        for (crabs.items) | crab_pos | {
            var d:i32 = try std.math.absInt(crab_pos - dest);
            part1_total_fuel += d;

            part2_total_fuel += @divExact((d * (d+1)), @intCast(i32, 2));
        }
        part1_smallest_total_fuel = std.math.min(part1_smallest_total_fuel, part1_total_fuel);
        part2_smallest_total_fuel = std.math.min(part2_smallest_total_fuel, part2_total_fuel);
    }

    std.log.info("Advent 2021 Day {d} Part 1:: {d}", .{ day, part1_smallest_total_fuel });
    std.log.info("Advent 2021 Day {d} Part 2:: {d}", .{ day, part2_smallest_total_fuel});

    std.log.info("done", .{});
}
