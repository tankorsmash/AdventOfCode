const std = @import("std");
const deps = @import("./deps.zig");

pub fn build(b: *std.build.Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("advent", "src/main.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);

    // exe.linkLibC();
    // exe.addIncludeDir("C:/code/utils/vcpkg/installed/x64-windows/include/curl");
    // exe.addLibPath("C:/code/utils/vcpkg/installed/x64-windows/lib");
    // // exe.addLibPath("C:/code/utils/vcpkg/installed/x64-windows/bin"); //libcurl.dll is here, but idk how to access it
    // exe.linkSystemLibraryName("libcurl");

    deps.addAllTo(exe);
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    // const day: i32 = 10;
    // const year: i32 = 2021;
    // const day_str = comptime std.fmt.comptimePrint("day{d}", .{day});
    // const year_str = comptime std.fmt.comptimePrint("advent{d}", .{year});
    // const solution_str = comptime std.fmt.comptimePrint("src/{s}/{s}/solution.zig", .{ year_str, day_str });
    // std.debug.print("adding to build step: {s}\n", .{solution_str});

    const exe_tests = b.addTest("src/main.zig");
    exe_tests.setBuildMode(mode);
    deps.addAllTo(exe_tests);

    // const solution_tests = b.addTest("src/advent2021/day10/solution.zig");
    // solution_tests.setBuildMode(mode);
    // deps.addAllTo(solution_tests);


    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&exe_tests.step);
    // test_step.dependOn(&solution_tests.step);
}
