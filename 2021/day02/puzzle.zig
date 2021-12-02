pub const std = @import("std");
pub const mem = std.mem;
pub const hash = std.hash;
pub const io = std.io;
pub const fmt = std.fmt;
pub const math = std.math;
pub const sort = std.sort;
pub const unicode = std.unicode;
pub const print = std.debug.print;
pub const assert = std.debug.assert;
pub const testing = std.testing;
pub const expect = testing.expect;
pub const expectError = testing.expectError;
pub const expectEqual = testing.expectEqual;
pub const expectEqualStrings = testing.expectEqualStrings;

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
    var buffer: [128]u8 = undefined;
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const stdin = std.io.getStdIn().reader();

    var prog = std.ArrayList(Instruction).init(&arena.allocator);
    defer prog.deinit();

    while (try stdin.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
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
    const stderr = io.getStdOut().writer();
    nosuspend stderr.print(fmtstr, args) catch return;
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
