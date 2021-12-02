const std = @import("std");

pub fn main() !void {
    var buffer: [4]u8 = undefined;
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();
    var depths = std.ArrayList(i32).init(&arena.allocator);

    while (try stdin.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        try depths.append(try std.fmt.parseInt(i32, line, 10));
    }

    try stdout.print(
        "Part 1: {}\nPart 2: {}\n",
        .{ part1(depths.items), part2(depths.items) },
    );
}

fn part1(depths: []i32) i32 {
    var increased : i32 = 0;
    var measure : i32 = depths[0];
    for (depths) |a| {
        if (a > measure) {
            increased += 1;
        }
        measure = a;
    }
    return increased;
}

fn part2(depths: []i32) i32 {
    var increased : i32 = 0;

    var ma : i32 = depths[0] + depths[1] + depths[2];
    var mb : i32 = depths[1] + depths[2] + depths[3];
    if (mb > ma) {
        increased += 1;
    }

    var index : usize = 2;
    while (index <= (depths.len - 3)) {

        ma  = mb;
        mb  = depths[index];
        mb += depths[index+1];
        mb += depths[index+2];

        if (mb > ma) {
            increased += 1;
        }

        index += 1;
    }
    return increased;
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
