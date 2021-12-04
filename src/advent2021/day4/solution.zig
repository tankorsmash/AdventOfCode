const std = @import("std");
const File = std.fs.File;
const fmt = std.fmt;

const load_input = @import("./../../advent2020/shared/load_input.zig");

pub fn parse_int(bytes: []const u8) std.fmt.ParseIntError!i32 {
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

pub fn parse_bin(bytes: []const u8) std.fmt.ParseIntError!u32 {
    var value: u32 = std.fmt.parseUnsigned(u32, bytes, 2) catch |err| {
        if (err == error.InvalidCharacter) {
            std.log.err("err: Invalid Character: {any}", .{bytes});
            return 0;
        }

        std.log.err("err {}: Unknown error parsing binary int: {any}", .{ err, bytes });

        return 0;
    };

    return value;
}

pub fn get_bit(num: u32, bit_idx: u5) u32 {
    const shift: u5 = bit_idx;
    const one: u32 = 1;
    const shifted_one: u32 = one << shift;
    const shifted_one_num: u32 = (num & shifted_one);
    return shifted_one_num >> shift;
}

pub fn calc_sums_raw(allocator: *std.mem.Allocator, values: std.ArrayList(std.ArrayList(u8))) ![12]i32 {
    var sums = [12]i32{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

    std.log.info("first raw elem: {any}", .{values.items[0]});

    for (values.items) |line| {
        _ = line;
        var stringed = try fmt.allocPrint(allocator, "{s}", .{line.items});
        // std.log.info("stringed: {s}", .{stringed});
        _ = stringed;

        for (stringed) |char, idx| {
            // if (std.mem.eql(u8, char, "0")) {
            if (char == '0') {
                sums[idx] -= 1;
            } else {
                sums[idx] += 1;
            }
        }
    }
    std.log.info("sums bin: {any}", .{sums});

    return sums;
}

pub fn calc_sums_i32(values: []u32) ![12]i32 {
    var sums = [12]i32{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
    std.log.info("first i32 elem: {d}", .{values[0]});

    for (values) |line| {
        var i: u5 = 0;
        while (i < 12) {
            const char = get_bit(line, 11 - i);
            if (char == 0) {
                sums[i] -= 1;
            } else {
                sums[i] += 1;
            }

            i += 1;
        }
    }

    std.log.info("sums i32: {any}", .{sums});

    return sums;
}

pub fn lookup(x: i32, y: i32) i32 {
    const rows: i32 = 5;
    const cols: i32 = 5;
    _ = cols;

    return rows * y + x;
}

pub fn solve_board(allocator: *std.mem.Allocator, board: std.ArrayList(i32), nums: []i32) !?i32 {
    _ = board;
    _ = nums;

    var i: i32 = 0;
    var marked_elems = std.ArrayList(bool).init(allocator);
    while (i < 25) : (i += 1) {
        try marked_elems.append(false);
    }

    for (nums) |num| {
        var num_arr = [1]i32{num};
        var num_idx = std.mem.indexOf(i32, board.items, num_arr[0..]);
        while (num_idx != null) {
            marked_elems.items[num_idx.?] = true;
            num_idx = std.mem.indexOf(i32, board.items[num_idx.?..], num_arr[0..]);
        }
    }

    //if none of these edges are marked, skip checking the rest
    var row : i32 = 0;
    var col : i32 = 0;

    var found_edge = false;
    while (col < 5) : (col += 1) {
        if (marked_elems.items[@intCast(usize, lookup(row, col))]) {
            found_edge = true;
            break;
        }
    }
    if (!found_edge) {
        return null;
    }

    return null;
}

pub fn solve() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = &arena.allocator;
    const day = 4;

    var all_values = load_input.load_input_line_bytes_2021(allocator, day) catch |err| {
        std.log.err("error loading input for Day {d}! {any}", .{ day, err });
        return;
    };

    var split_nums = std.mem.split(u8, all_values.items[0].items, ",");
    _ = split_nums;

    var nums = std.ArrayList(i32).init(allocator);
    while (split_nums.next()) |splitted| {
        try nums.append(try std.fmt.parseInt(i32, splitted, 10));
    }

    std.log.info("nums: {any}", .{nums});

    var boards = std.ArrayList(std.ArrayList(i32)).init(allocator);

    //collect boards into flat arrays
    var board_building = std.ArrayList(i32).init(allocator);
    for (all_values.items[2..]) |line| {
        _ = line;
        if (std.mem.eql(u8, line.items, "")) {
            try boards.append(board_building);
            board_building = std.ArrayList(i32).init(allocator);
            continue;
        }

        var line_splitter = std.mem.split(u8, line.items, " ");
        while (line_splitter.next()) |num_str| {
            std.log.info("num_str: {s}", .{num_str});
            if (std.mem.eql(u8, num_str, " ")) {
                continue;
            }
            if (std.mem.eql(u8, num_str, "")) {
                continue;
            }
            try board_building.append(try parse_int(num_str));
        }
    }

    std.log.info("num boards {d}", .{std.mem.len(boards.items)});
    std.log.info("board 1 {any}", .{boards.items[0]});

    for (nums.items) |num, num_idx| {
        _ = num;
        _ = num_idx;

        if (num_idx % 5 == 0 and num_idx != 0) {
            for (boards.items) |board, board_idx| {
                _ = board_idx;
                var solved_board = try solve_board(allocator, board, nums.items[0..num_idx]);
                if (solved_board != null) {
                    std.log.info("found answer: {d}", .{solved_board.?});
                    break;
                }
            }
        }
    }
    //mark boards by grouping nums into groups of 5 nums

    // var split_boards = std.mem.split(u8, all_values.items[2..], "\n");
    // _ = split_boards;

    // std.log.info("Advent 2021 Day {d} Part 1:: {d}", .{ day, gamma * epsilon });
    // std.log.info("Advent 2021 Day {d} Part 2:: {d}", .{ day, oxy_result * co2_result });
}
