const std = @import("std");
const util = @import("util.zig");

const input = @embedFile("../data/day5.txt");

pub fn main() !void {
    var data = std.ArrayList(u8).init(std.heap.page_allocator);
    defer data.deinit();

    var lines = util.tokenize(u8, input, "\n");
    
    while (lines.next()) |line| {
        printf("{s}\n", .{line});
    }

    return;
}

pub fn printf(comptime fmtstr: []const u8, args: anytype) void {
    const stdout = std.io.getStdOut().writer();
    nosuspend stdout.print(fmtstr, args) catch return;
}
