const std = @import("std");
const File = std.fs.File;
const fmt = std.fmt;

const load_input = @import("../shared/load_input.zig");

pub fn solve() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = &arena.allocator;

    const day = 4;
    var all_values = load_input.load_input_line_bytes(allocator, day) catch |err| {
        std.log.err("error loading input for Day {d}! {any}", .{ day, err });
        return;
    };

    var req_fields = [_][]const u8{
        "byr", // (Birth Year)
        "iyr", // (Issue Year)
        "eyr", // (Expiration Year)
        "hgt", // (Height)
        "hcl", // (Hair Color)
        "ecl", // (Eye Color)
        "pid", // (Passport ID)
        "cid", // (Country ID)
    };
    _ = req_fields;

    const num_req_fields = std.mem.len(req_fields);
    std.log.info("There are {d} required fields", .{num_req_fields});

    var part1_valid_passports_found: i32 = 0;

    var raw_lines: std.ArrayList(std.ArrayList(u8)) = std.ArrayList(std.ArrayList(u8)).init(allocator);
    _ = raw_lines;

    var num_fields_found: i32 = 0;
    var field_keys_found = std.ArrayList([]const u8).init(allocator);
    _ = field_keys_found;

    for (all_values.items) |arr_bytes, line_idx| {
        _ = line_idx;
        var bytes: []u8 = arr_bytes.items;
        _ = bytes;

        var len_bytes = std.mem.len(bytes);
        if (len_bytes == 0) {
            //process old passport
            for (raw_lines.items) |pp_bytes| {
                std.log.info(":: processing the line {d}:: '{s}'", .{line_idx, pp_bytes.items});

                var entries = std.mem.split(u8, pp_bytes.items, " ");
                _ = entries;
                while (entries.next()) |entry| {
                    std.log.info("processing the entry {s}", .{entry});
                    var split_entries = std.mem.split(u8, entry, ":");
                    _ = split_entries;

                    var key = split_entries.next().?;
                    try field_keys_found.append(key);
                    var value = split_entries.next().?;
                    std.log.info(":: Found {s} -- value: {s}", .{ key, value });
                    if (!std.mem.eql(u8, "cid", key)) {
                        num_fields_found += 1;
                    }
                }
            }

            std.log.info("field keys found: #{d} {s}", .{num_fields_found, field_keys_found.items});
            if (num_fields_found >= 7) {
                std.log.info("Is valid passport", .{});
                part1_valid_passports_found += 1;
            } else {
                std.log.info("Is not a valid passport", .{});
            }

            //clear old one by just replacing it
            raw_lines = std.ArrayList(std.ArrayList(u8)).init(allocator);
            field_keys_found = std.ArrayList([]const u8).init(allocator);
            num_fields_found = 0;
            continue;
        }
        // std.log.info("length {d}", .{len_bytes});

        try raw_lines.append(arr_bytes);
    }

    //duplicate the checking logic for  the last item, since we skip the last one
    for (raw_lines.items) |pp_bytes| {
        std.log.info(":: processing the line LAST:: '{s}'", .{pp_bytes.items});

        var entries = std.mem.split(u8, pp_bytes.items, " ");
        _ = entries;
        while (entries.next()) |entry| {
            std.log.info("processing the entry {s}", .{entry});
            var split_entries = std.mem.split(u8, entry, ":");
            _ = split_entries;

            var key = split_entries.next().?;
            try field_keys_found.append(key);
            var value = split_entries.next().?;
            std.log.info(":: Found {s} -- value: {s}", .{ key, value });
            if (!std.mem.eql(u8, "cid", key)) {
                num_fields_found += 1;
            }
        }
    }

    std.log.info("field keys found: #{d} {s}", .{num_fields_found, field_keys_found.items});
    if (num_fields_found >= 7) {
        std.log.info("Is valid passport", .{});
        part1_valid_passports_found += 1;
    } else {
        std.log.info("Is not a valid passport", .{});
    }

    std.log.info("Advent Day {d} Part 1:: {d}", .{ day, part1_valid_passports_found });
}
