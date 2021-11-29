const std = @import("std");
const File = std.fs.File;
const fmt = std.fmt;

const load_input = @import("./../shared/load_input.zig");

const expect = std.testing.expect;
const expectEqual = std.testing.expectEqual;
pub fn expectFalse(result: bool) !void {
    try expect(!result);
}

pub fn valid_len(bytes: []const u8, req_size: u32) bool {
    return std.mem.len(bytes) == req_size;
}

pub const Bounds = struct { lower: i32, upper: i32 };

pub fn split(bounds: Bounds, take_lower: bool) Bounds {
    // pub fn split(num: i32, take_lower:bool) i32{
    _ = bounds;
    _ = take_lower;
    var result = Bounds{ .lower = bounds.lower, .upper = bounds.upper };

    const range = (bounds.upper - bounds.lower) + 1;
    const half_range = @divExact(range, 2);
    // std.debug.print("range: {d}\n", .{range});
    // std.debug.print("range/2: {d}\n", .{half_range});

    if (take_lower) {
        // result.upper /= @intCast(i32, 2);
        result.upper = result.upper - half_range;
    } else {
        // result.lower /= @intCast(i32, 2);
        result.lower = result.lower + half_range;
    }

    return result;
}


pub fn parse_int(bytes: []const u8) std.fmt.ParseIntError!i32 {
    var value: i32 = std.fmt.parseUnsigned(i32, bytes, 10) catch |err| {
        if (err == error.InvalidCharacter) {
            std.log.err("err: Invalid Character: {any}", .{bytes});
            return 0;
        }

        std.log.err("err {}: Unknown error parsing int: {any}", .{ err, bytes });

        return 0;
    };

    return value;
}

pub fn solve() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = &arena.allocator;
    const day = 5;

    // const starting_val = Bounds{.lower=0, .upper=128};
    //
    // // const pairs = split(starting_val, false);
    // std.log.info("starting pairs: {}", .{starting_val});
    // std.log.info("taking lower: {any}", .{split(starting_val, false)});
    // std.log.info("taking upper: {any}", .{split(starting_val, true)});

    // var all_values :std.ArrayList(std.ArrayList(u8)) = undefined;
    var all_values = load_input.load_input_line_bytes(allocator, day) catch |err| {
        std.log.err("error loading input for Day {d}! {any}", .{ day, err });
        return;
    };
    _ = all_values;


    var seat_ids = std.ArrayList(i32).init(allocator);

    for (all_values.items) |ticket| {
        var row = Bounds{ .lower = 0, .upper = 127 };
        var col = Bounds{ .lower = 0, .upper = 7 };
        _ = col;
        for (ticket.items) |char| {
            // var wrapped = [_]u8{char};
            // std.log.info("char: {s}", .{([_]u8{char})[0..]});
            if (char == 'F') {
                row = split(row, true);
            } else if (char == 'B') {
                row = split(row, false);
            } else if (char == 'L') {
                col = split(col, true);
            } else if (char == 'R') {
                col = split(col, false);
            }
        }

        const seat_id = row.lower * 8 + col.lower;

        try seat_ids.append(seat_id);

        // std.log.info("result: {any} - {any}. seat: {d}", .{ row, col, seat_id });
    }

    _ = seat_ids;

    const max_seats = 1024;

    // const lookup(row: i32, col:i32) i32 {
    //     return row * 8 + col;
    // }

    var current_seat:i32 = 1; //seat id 0 doesnt exist
    var missing_seat:i32 = -1;
    while (current_seat < max_seats) : (current_seat+=1) {
        if (std.mem.indexOf(i32, seat_ids.items, ([_]i32{current_seat})[0..]) == null) {

            if (std.mem.indexOf(i32, seat_ids.items, ([_]i32{current_seat-1})[0..]) != null) {
                if (std.mem.indexOf(i32, seat_ids.items, ([_]i32{current_seat+1})[0..]) != null) {
                    std.log.info("Didnt find seat ID: {d}", .{current_seat});
                    missing_seat = current_seat;
                }
            }
        }
    }


    const max_seat_id = std.mem.max(i32, seat_ids.items);
    //TODO its not 507
    std.log.info("Advent Day {d} Part 1:: {d}", .{ day, max_seat_id });
    std.log.info("Advent Day {d} Part 2:: {d}", .{ day, missing_seat });
}

test "ASDA" {
    expect(true);
}
