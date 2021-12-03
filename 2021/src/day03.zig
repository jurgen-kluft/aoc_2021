const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const Str = []const u8;

const util = @import("util.zig");
const gpa = util.gpa;

const input = @embedFile("../data/day3.txt");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    var report = std.ArrayList(u16).init(&arena.allocator);
    defer report.deinit();

    var lines = tokenize(u8, input, "\n");
    while (lines.next()) |line| {
        var i = parseBinary(line);
        try report.append(i);
    }

    var gamma: u64 = 0;
    var epsilon: u64 = 0;

    const bits = [_]u16{1<<11,1<<10,1<<9,1<<8,1<<7,1<<6,1<<5,1<<4,1<<3,1<<2,1<<1,1<<0};
    var num_all_bits = report.items.len;
    for (bits) |bit| {
        var num_one_bits: usize = 0;
        for (report.items) |n| {
            if ((n & bit) == bit) {
                num_one_bits += 1;
            }
        }
        gamma = (gamma << 1);
        if (num_one_bits > (num_all_bits - num_one_bits)) {
            gamma = gamma | 1;
        }
    }
    epsilon = gamma ^ 0b111111111111;

    printf("gamma {}, epsilon {}\n", .{gamma, epsilon});
    printf("power consumption = {}\n", .{gamma * epsilon});
    
    return;
}

pub fn parseBinary(str: []const u8) u16 {
    var value: u16 = 0;
    for (str) |c| {
        const bit: u16 = switch (c) {
            '0' => 0,
            '1' => 1,
            else => 0,
        };
        value = (value << 1) | bit;
    }
    return value;
}

pub fn printf(comptime fmtstr: []const u8, args: anytype) void {
    const stdout = std.io.getStdOut().writer();
    nosuspend stdout.print(fmtstr, args) catch return;
}


// Useful stdlib functions
const tokenize = std.mem.tokenize;
const split = std.mem.split;
const indexOf = std.mem.indexOfScalar;
const indexOfAny = std.mem.indexOfAny;
const indexOfStr = std.mem.indexOfPosLinear;
const lastIndexOf = std.mem.lastIndexOfScalar;
const lastIndexOfAny = std.mem.lastIndexOfAny;
const lastIndexOfStr = std.mem.lastIndexOfLinear;
const trim = std.mem.trim;
const sliceMin = std.mem.min;
const sliceMax = std.mem.max;

const parseInt = std.fmt.parseInt;
const parseFloat = std.fmt.parseFloat;

const min = std.math.min;
const min3 = std.math.min3;
const max = std.math.max;
const max3 = std.math.max3;

const print = std.debug.print;
const assert = std.debug.assert;

const sort = std.sort.sort;
const asc = std.sort.asc;
const desc = std.sort.desc;
