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

pub fn lookup(x: i32, y: i32) i32 {
    const rows: i32 = 5;
    const cols: i32 = 5;
    _ = cols;

    return rows * y + x;
}

pub fn score_board(allocator: *std.mem.Allocator, board: std.ArrayList(i32), nums: []i32, marked_elems: std.ArrayList(bool)) i32 {
    _ = allocator;
    _ = board;
    _ = nums;
    _ = marked_elems;

    const last_num: i32 = nums[std.mem.len(nums) - 1];

    var sum: i32 = 0;
    for (marked_elems.items) |marked_elem, marked_idx| {
        if (!marked_elem) {
            sum += board.items[marked_idx];
        }
    }

    return last_num * sum;
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
            num_idx = std.mem.indexOf(i32, board.items[num_idx.? + 1 ..], num_arr[0..]);
        }
    }

    //if none of these edges are marked, skip checking the rest
    var row: i32 = 0;
    var col: i32 = 0;

    var found_edge = false;
    while (col < 5) : (col += 1) {
        row = 0;
        if (marked_elems.items[@intCast(usize, lookup(row, col))]) {
            var found_match = false;
            while (row < 5) : (row += 1) {
                if (marked_elems.items[@intCast(usize, lookup(row, col))] == false) {
                    break;
                }

                if (row == 4) {
                    found_match = true;
                }
            }

            if (found_match) {
                return score_board(allocator, board, nums, marked_elems);
            }
        }
    }

    row = 0;
    while (row < 5) : (row += 1) {
        col = 0;
        if (marked_elems.items[@intCast(usize, lookup(row, col))]) {
            var found_match = false;
            while (col < 5) : (col += 1) {
                if (marked_elems.items[@intCast(usize, lookup(row, col))] == false) {
                    break;
                }

                if (col == 4) {
                    found_match = true;
                }
            }

            if (found_match) {
                return score_board(allocator, board, nums, marked_elems);
            }
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
            if (std.mem.eql(u8, num_str, " ")) {
                continue;
            }
            if (std.mem.eql(u8, num_str, "")) {
                continue;
            }
            try board_building.append(try parse_int(num_str));
        }
    }
    try boards.append(board_building);

    std.log.info("num boards {d}", .{std.mem.len(boards.items)});

    var solved_board: ?i32 = null;
    var part1_solved_board : ?i32 = null;
    var part2_solved_board : ?i32 = null;

    var solved_boards = std.ArrayList(?i32).init(allocator);
    for (boards.items) |_| {
        try solved_boards.append(null);
    }

    for (nums.items) |num, num_idx| {
        for (boards.items) |board, board_idx| {
            _ = board_idx;

            //dont re-solve solved boards
            if (solved_boards.items[board_idx] != null) { continue; }

            solved_board = try solve_board(allocator, board, nums.items[0..num_idx]);
            if (solved_board != null) {
                if (part1_solved_board == null) {
                    part1_solved_board = solved_board.?;
                }
                part2_solved_board = solved_board.?;
                // std.log.info("part2_solved_board idx: {d} answer: {d}", .{board_idx, part2_solved_board});

                solved_boards.items[board_idx] = num;
            }
        }
    }
    //mark boards by grouping nums into groups of 5 nums
    std.log.info("Advent 2021 Day {d} Part 1:: {d}", .{ day, part1_solved_board.? });
    std.log.info("Advent 2021 Day {d} Part 2:: {d}", .{ day, part2_solved_board});

    std.log.info("done", .{});
}
