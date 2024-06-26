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
    return bytes.len == req_size;
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

    return value >= 2010 and value <= 2020;
    // return 2010 <= value <= 2020;
}

pub fn process_eyr(bytes: []const u8) bool {
    if (!valid_len(bytes, 4)) {
        return false;
    }

    var value: i32 = parse_int(bytes) catch return false;

    // return 2020 <= value <= 2030;
    return value >= 2020 and value <= 2030;
}

pub fn process_hgt(bytes: []const u8) bool {

    const cm_idx = std.mem.indexOf(u8, bytes, "cm");
    if (cm_idx != null) {
        var potential_height = bytes[0..cm_idx.?];
        var value: i32 = parse_int(potential_height) catch {
            // std.log.info("{s} not a valid int", .{potential_height});
            return false;
        };
        // return 150 <= value <= 193;
        return value >= 150 and value <= 193;
    }

    const in_idx = std.mem.indexOf(u8, bytes, "in");
    if (in_idx != null) {
        var potential_height = bytes[0..in_idx.?];
        var value: i32 = parse_int(potential_height) catch {
            // std.log.info("{s} not a valid int", .{potential_height});
            return false;
        };
        // return 59 <= value <= 76;
        return value >= 59 and value <= 76;
    }

    // std.log.info("{s} is not a valid height", .{bytes});
    return false;
}

pub fn process_hcl(bytes: []const u8) bool {
    const hcl_idx = std.mem.indexOfPos(u8, bytes, 0, "#");
    if (hcl_idx == null) {
        return false;
    }

    //exactly 6 bytes
    if (bytes[1..].len != 6) {
        return false;
    }

    //a-f or 0.9
    for (bytes[1..]) |char| {
        const is_char: bool = char >= 'a' and char <= ('a' + 5);
        const is_num: bool = char >= '0' and char <= ('0' + 9);
        // std.log.info("char {d} is char? {b} is num? {b}", .{ char, is_char, is_num });
        if (!(is_char or is_num)) {
            return false;
        }
    }
    return true;
}
pub fn process_ecl(bytes: []const u8) bool {

    if (bytes.len != 3) {
        return false;
    }

    const valid_ecls = [_][]const u8{ "amb", "blu", "brn", "gry", "grn", "hzl", "oth" };

    for (valid_ecls) |potential_color| {
        if (std.mem.eql(u8, potential_color, bytes)) {
            return true;
        }
    }

    return false;
}
pub fn process_pid(bytes: []const u8) bool {
    if (bytes.len != 9) {
        // std.log.info("length is wrong: {d}", .{len});
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
    var valid_fields = std.StringHashMap(bool).init(allocator.*);
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

pub fn init_value_map(allocator: *std.mem.Allocator) !std.StringHashMap(?[]const u8) {
    var valid_fields = std.StringHashMap(?[]const u8).init(allocator.*);
    try valid_fields.put("byr", null); // (Birth Year)
    try valid_fields.put("iyr", null); // (Issue Year)
    try valid_fields.put("eyr", null); // (Expiration Year)
    try valid_fields.put("hgt", null); // (Height)
    try valid_fields.put("hcl", null); // (Hair Color)
    try valid_fields.put("ecl", null); // (Eye Color)
    try valid_fields.put("pid", null); // (Passport ID)
    try valid_fields.put("cid", null); // (Country ID) hardcoded to true

    return valid_fields;
}

var validator_map: std.StringHashMap(*const fn ([]const u8) bool) = undefined;

pub fn get_validator(key: []const u8) ?(*const fn ([]const u8) bool) {
    return validator_map.get(key);
}

pub fn is_passport_valid(allocator: *std.mem.Allocator, entries: std.ArrayList(std.ArrayList(u8))) !bool {
    var num_fields_found: i32 = 0; //for part1,otherwise unused though
    var valid_fields = try init_valid_map(allocator);
    var value_map = try init_value_map(allocator);

    for (entries.items) |entry| {
        // std.log.info("processing the entry {s}", .{entry.items});
        var split_entries = std.mem.split(u8, entry.items, ":");

        var key = split_entries.next().?;
        // try field_keys_found.append(key);
        var value = split_entries.next().?;
        try value_map.put(key, value);
        // std.log.info(":: Found {s} -- value: {s}", .{ key, value });
        if (!std.mem.eql(u8, "cid", key)) {
            num_fields_found += 1;
        }

        var validator_fn = get_validator(key).?;
        var is_valid = validator_fn(value);
        // std.log.info("key: {s} is valid?: {b}", .{ key, is_valid });

        try valid_fields.put(key, is_valid);
    }

    var is_valid_part2_passport: bool = true;

    // var keys = [][]u8{ "hcl" };
    for (req_fields) |field_name| {
        // if (!std.mem.eql(u8, field_name, "byr")) {
        //     continue;
        // }

        var field_valid: ?bool = valid_fields.get(field_name);
        // var field_value: ??[]const u8 = value_map.get(field_name);
        // std.log.info("Checking {s}: {b} --  {s}", .{ field_name, field_valid, field_value });

        if (!field_valid.?) {
            is_valid_part2_passport = false;
        }
    }

    // var it = valid_fields.iterator();
    // while (it.next()) |entry| {
    //     const key = entry.key_ptr.*;
    //     const value = entry.value_ptr.*;
    //     std.log.info("entry checking -- k: {s}, v: {b}", .{ key, value });
    //     if (!value) {
    //         is_valid_part2_passport = false;
    //         break;
    //     }
    // }
    return is_valid_part2_passport;
}

pub fn collect_entries(allocator: *std.mem.Allocator, raw_lines: std.ArrayList(std.ArrayList(u8))) !std.ArrayList(std.ArrayList(u8)) {
    var all_entries = std.ArrayList(std.ArrayList(u8)).init(allocator.*);
    //process old passport
    for (raw_lines.items) |pp_bytes| {
        var entries = std.mem.split(u8, pp_bytes.items, " ");
        while (entries.next()) |entry| {
            var sub_arr = std.ArrayList(u8).init(allocator.*);
            for (entry) |el| {
                try sub_arr.append(el);
            }
            try all_entries.append(sub_arr);
        }
    }

    return all_entries;
}

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

pub fn solve() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    var allocator = arena.allocator();
    const day = 4;

    // var all_values :std.ArrayList(std.ArrayList(u8)) = undefined;
    var all_values = load_input.load_input_line_bytes(&allocator, day) catch |err| {
        std.log.err("error loading input for Day {d}! {any}", .{ day, err });
        return;
    };

    validator_map = std.StringHashMap(*const fn ([]const u8) bool).init(allocator);
    try validator_map.put("byr",  process_byr); // (Birth Year)
    try validator_map.put("iyr",  process_iyr); // (Issue Year)
    try validator_map.put("eyr",  process_eyr); // (Expiration Year)
    try validator_map.put("hgt",  process_hgt); // (Height)
    try validator_map.put("hcl",  process_hcl); // (Hair Color)
    try validator_map.put("ecl",  process_ecl); // (Eye Color)
    try validator_map.put("pid",  process_pid); // (Passport ID)
    try validator_map.put("cid",  process_cid); // (Country ID)

    // const num_req_fields = std.mem.len(req_fields);
    // std.log.info("There are {d} required fields", .{num_req_fields});

    var part1_valid_passports_found: i32 = 0;
    var part2_valid_passports_found: i32 = 0;

    var raw_lines: std.ArrayList(std.ArrayList(u8)) = std.ArrayList(std.ArrayList(u8)).init(allocator);

    for (all_values.items) |arr_bytes| {
        var bytes: []u8 = arr_bytes.items;

        // var len_bytes = std.mem.len(arr_bytes.items);
        var len_bytes = bytes.len;
        var empty_line: bool = len_bytes == 0;
        if (empty_line) {
            var all_entries = try collect_entries(&allocator, raw_lines);
            var passport_is_valid = try is_passport_valid(&allocator, all_entries);

            // std.log.info("Passport valid? {b}", .{passport_is_valid});

            if (passport_is_valid) {
                part2_valid_passports_found += 1;
            }

            //clear old one by just replacing it
            raw_lines = std.ArrayList(std.ArrayList(u8)).init(allocator);
            continue;
        }
        // std.log.info("length {d}", .{len_bytes});

        try raw_lines.append(arr_bytes);
    }

    var all_entries = try collect_entries(&allocator, raw_lines);
    var passport_is_valid = try is_passport_valid(&allocator, all_entries);

    // std.log.info("is pp valid? {b}", .{passport_is_valid});

    if (passport_is_valid) {
        part2_valid_passports_found += 1;
    }

    std.log.info("Advent Day {d} Part 1:: {d}", .{ day, part1_valid_passports_found });
    std.log.info("Advent Day {d} Part 2:: {d}", .{ day, part2_valid_passports_found });
}

test "day4test" {
    std.log.info("ASDASDA", .{});

    try expect(1 == 1231231); //this should fail but it doesnt because of the @import above
    //byr
    try expectFalse(process_byr("1231231"));
    try expectFalse(process_byr("1000"));
    try expectFalse(process_byr("3000"));
    try expect(process_byr("2000"));


    //iyr
    try expectFalse(process_iyr("1231231"));
    try expectFalse(process_iyr("1000"));
    try expectFalse(process_iyr("3000"));
    try expectFalse(process_iyr("2009"));
    try expectFalse(process_iyr("2021"));
    try expect(process_iyr("2010"));
    try expect(process_iyr("2011"));
    try expect(process_iyr("2019"));
    try expect(process_iyr("2020"));
}
