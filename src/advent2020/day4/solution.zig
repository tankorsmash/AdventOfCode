const std = @import("std");
const File = std.fs.File;
const fmt = std.fmt;

const load_input = @import("../shared/load_input.zig");

pub fn valid_len(bytes: []const u8, req_size: u32) bool {
    return std.mem.len(bytes) == req_size;
}

pub fn parse_int(bytes: []const u8) std.fmt.ParseIntError!i32 {
    var value: i32 = std.fmt.parseUnsigned(i32, bytes, 10) catch |err| {
        if (err == error.InvalidCharacter) {
            std.log.err("err: Invalid Character: {any}", .{bytes});
            return 0;
        }

        std.log.err("err {}: Unknown error parsing int: {any}", .{err, bytes});

        return 0;
    };

    return value;
}

pub fn process_byr(bytes: []const u8) bool {
    if (!valid_len(bytes, 4)) {
        return false;
    }

    var value: i32 = parse_int(bytes) catch return false;

    return value >= 1920 and value <= 2002;
}

pub fn process_iyr(bytes: []const u8) bool {
    if (!valid_len(bytes, 4)) {
        return false;
    }

    var value: i32 = parse_int(bytes) catch return false;

    return 2010 <= value <= 2020;
}

pub fn process_eyr(bytes: []const u8) bool {
    if (!valid_len(bytes, 4)) {
        return false;
    }

    var value: i32 = parse_int(bytes) catch return false;

    return 2020 <= value <= 2030;
}

pub fn process_hgt(bytes: []const u8) bool {
    _ = bytes;

    const cm_idx = std.mem.indexOf(u8, bytes, "cm");
    if (cm_idx != null) {
        var potential_height = bytes[0..cm_idx.?];
        var value: i32 = parse_int(potential_height) catch {
            std.log.info("{s} not a valid int", .{potential_height});
            return false;
        };
        return 150 <= value <= 193;
    }

    const in_idx = std.mem.indexOf(u8, bytes, "in");
    if (in_idx != null) {
        var potential_height = bytes[0..in_idx.?];
        var value: i32 = parse_int(potential_height) catch {
            std.log.info("{s} not a valid int", .{potential_height});
            return false;
        };
        return 59 <= value <= 76;
    }

    std.log.info("{s} is not a valid height", .{bytes});
    return false;
}

pub fn process_hcl(bytes: []const u8) bool {
    _ = bytes;
    const hcl_idx = std.mem.indexOfPos(u8, bytes, 0, "#");
    if (hcl_idx == null) { return false;}

    //exactly 6 bytes
    if (std.mem.len(bytes[1..]) != 6) { return false; }

    //a-f or 0.9
    for (bytes[1..]) |char| {
        const is_char: bool = char >= 'a' and char <= ('a'+5);
        const is_num: bool = char >= '0' and char <= ('0'+9);
        std.log.info("char {d} is char? {b} is num? {b}", .{char, is_char, is_num});
        if (!(is_char or is_num) ) {
            return false;
        }
        _ = char;
    }
    return true;
}
pub fn process_ecl(bytes: []const u8) bool {
    _ = bytes;

    if (std.mem.len(bytes) != 3) { return false; }

    const valid_ecls = [_][]const u8 {"amb", "blu", "brn", "gry", "grn", "hzl", "oth"};

    for (valid_ecls) |potential_color| {
        if (std.mem.eql(u8, potential_color, bytes)) {
            return true;
        }
    }

    return false;
}
pub fn process_pid(bytes: []const u8) bool {
    _ = bytes;
    const len = std.mem.len(bytes);
    if (len != 9) {
        std.log.info("length is wrong: {d}", .{len});
        return false;
    }

    _ = parse_int(bytes) catch return false;
    return true;
}
pub fn process_cid(bytes: []const u8) bool {
    _ = bytes;
    return true;
}

pub fn init_valid_map(allocator: *std.mem.Allocator) !std.StringHashMap(bool) {
    var valid_fields = std.StringHashMap(bool).init(allocator);
    try valid_fields.put("byr", false); // (Birth Year)
    try valid_fields.put("iyr", false); // (Issue Year)
    try valid_fields.put("eyr", false); // (Expiration Year)
    try valid_fields.put("hgt", false); // (Height)
    try valid_fields.put("hcl", false); // (Hair Color)
    try valid_fields.put("ecl", false); // (Eye Color)
    try valid_fields.put("pid", false); // (Passport ID)
    try valid_fields.put("cid", true); // (Country ID) hardcoded to true

    return valid_fields;
}

var validator_map: std.StringHashMap(fn ([]const u8) bool) = undefined;

pub fn get_validator(key: []const u8) ?(fn ([]const u8) bool) {
    return validator_map.get(key);
}

pub fn solve() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = &arena.allocator;
    const day = 4;

    std.log.info("logging {d}", .{1});

    var all_values = load_input.load_input_line_bytes(allocator, day) catch |err| {
        std.log.err("error loading input for Day {d}! {any}", .{ day, err });
        return;
    };

    std.log.info("logging {d}", .{2});
    validator_map = std.StringHashMap(fn ([]const u8) bool).init(allocator);
    try validator_map.put("byr", process_byr); // (Birth Year)
    try validator_map.put("iyr", process_iyr); // (Issue Year)
    try validator_map.put("eyr", process_eyr); // (Expiration Year)
    try validator_map.put("hgt", process_hgt); // (Height)
    try validator_map.put("hcl", process_hcl); // (Hair Color)
    try validator_map.put("ecl", process_ecl); // (Eye Color)
    try validator_map.put("pid", process_pid); // (Passport ID)
    try validator_map.put("cid", process_cid); // (Country ID)

    std.log.info("logging {d}", .{3});
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

    std.log.info("logging {d}", .{4});
    const num_req_fields = std.mem.len(req_fields);
    std.log.info("There are {d} required fields", .{num_req_fields});

    var part1_valid_passports_found: i32 = 0;
    var part2_valid_passports_found: i32 = 0;

    std.log.info("logging {d}", .{5});
    var raw_lines: std.ArrayList(std.ArrayList(u8)) = std.ArrayList(std.ArrayList(u8)).init(allocator);
    _ = raw_lines;

    std.log.info("logging {d}", .{6});
    var num_fields_found: i32 = 0;
    var field_keys_found = std.ArrayList([]const u8).init(allocator);
    _ = field_keys_found;

    std.log.info("logging {d}", .{7});
    for (all_values.items) |arr_bytes, line_idx| {
        _ = line_idx;
        var bytes: []u8 = arr_bytes.items;
        _ = bytes;

        var len_bytes = std.mem.len(bytes);
        if (len_bytes == 0) {
            var valid_fields = try init_valid_map(allocator);
            _ = valid_fields;
            //process old passport
            for (raw_lines.items) |pp_bytes| {
                std.log.info(":: processing the line {d}:: '{s}'", .{ line_idx, pp_bytes.items });

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

                    var validator_fn = get_validator(key).?;


                    var is_valid = validator_fn(value);

                    std.log.info("Value: {s} is valid?: {b}", .{value, is_valid});

                    try valid_fields.put(key, is_valid);
                }
            }

            var it = valid_fields.iterator();

            var is_valid_part2_passport: bool = true;
            while (it.next()) |entry| {
                const value = entry.value_ptr.*;
                std.log.info("entry checking -- k: {s}, v: {b}", .{entry.key_ptr.*, value});
                if (!value) { is_valid_part2_passport = false; break; }
            }
            if (is_valid_part2_passport) {
                part2_valid_passports_found += 1;
            }

            std.log.info("field keys found: #{d} {s}", .{ num_fields_found, field_keys_found.items });
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

                var is_valid_field: bool = undefined;

                if (std.mem.eql(u8, key, "byr")) {
                    is_valid_field = true;
                }

                if (is_valid_field) {}

                _ = is_valid_field;
            }
        }
    }

    std.log.info("field keys found: #{d} {s}", .{ num_fields_found, field_keys_found.items });
    if (num_fields_found >= 7) {
        std.log.info("Is valid passport", .{});
        part1_valid_passports_found += 1;
    } else {
        std.log.info("Is not a valid passport", .{});
    }

    std.log.info("Advent Day {d} Part 1:: {d}", .{ day, part1_valid_passports_found });
    std.log.info("Advent Day {d} Part 2:: {d}", .{ day, part2_valid_passports_found });
}
