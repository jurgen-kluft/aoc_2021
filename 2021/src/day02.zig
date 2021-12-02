const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const Str = []const u8;

const util = @import("util.zig");
const gpa = util.gpa;

const input = @embedFile("../data/day2.txt");

const Direction = enum {
    Forward,
    Up,
    Down,
};

const Instruction = struct {
    dir: Direction,
    num: i32,
};

inline fn parseInstruction(s: []const u8) !Instruction {
    if (s.len < 3) {
        return error.InvalidOpcode;
    }

    var op: Direction = undefined;
    var cn: usize = undefined;
    if (mem.eql(u8, "up", s[0..2])) {
        op = Direction.Up;
        cn = 3;
    } else if (mem.eql(u8, "down", s[0..4])) {
        op = Direction.Down;
        cn = 5;
    } else if (mem.eql(u8, "forward", s[0..7])) {
        op = Direction.Forward;
        cn = 8;
    } else {
        return error.InvalidOpcode;
    }

    const num = fmt.parseInt(isize, s[cn..], 10) catch |e| return e;

    return Instruction{
        .dir = op,
        .num = @intCast(i32, num),
    };
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    var prog = std.ArrayList(Instruction).init(&arena.allocator);
    defer prog.deinit();

    var lines = tokenize(u8, input, "\n");
    while (lines.next()) |line| {
        const instruction = try parseInstruction(line);
        try prog.append(instruction);
    }

    printf(
        "Instructions {}\n",
        .{ prog.items.len },
    );

    printf(
        "Part 1: {}\nPart 2: {}\n",
        .{ travel1(prog.items), travel2(prog.items) },
    );
}

pub fn printf(comptime fmtstr: []const u8, args: anytype) void {
    const stdout = std.io.getStdOut().writer();
    nosuspend stdout.print(fmtstr, args) catch return;
}

fn travel1(prog: []Instruction) i32 {
    var x : i32 = 0;
    var y : i32 = 0;  

    for (prog) |instr| {
        switch (instr.dir) {
            .Forward => x += instr.num,
            .Up => y -= instr.num,
            .Down => y += instr.num,
        }
    }
    printf("x {} y {}\n", .{x, y});

    return x*y;
}

fn travel2(prog: []Instruction) i32 {
    var x : i32 = 0;
    var y : i32 = 0;
    var aim : i32 = 0;

    for (prog) |instr| {
        if (instr.dir == Direction.Forward) {
            x += instr.num;
            y += aim * instr.num;
        } else if (instr.dir == Direction.Up) {
            aim -= instr.num;
        } else if (instr.dir == Direction.Down) {
            aim += instr.num;
        }
    }
    printf("x {} y {}\n", .{x, y});

    return x*y;
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
