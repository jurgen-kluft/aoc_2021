const std = @import("std");
pub const Allocator = std.mem.Allocator;
pub const GPA = std.heap.GeneralPurposeAllocator;
pub const List = std.ArrayList;
pub const Map = std.AutoHashMap;
pub const StrMap = std.StringHashMap;
pub const BitSet = std.DynamicBitSet;
pub const Str = []const u8;

pub var gpa_impl = GPA(.{}){};
pub const gpa = &gpa_impl.allocator;

// Add utility functions here


// Useful stdlib functions
pub const tokenize = std.mem.tokenize;
pub const split = std.mem.split;
pub const indexOf = std.mem.indexOfScalar;
pub const indexOfAny = std.mem.indexOfAny;
pub const indexOfStr = std.mem.indexOfPosLinear;
pub const lastIndexOf = std.mem.lastIndexOfScalar;
pub const lastIndexOfAny = std.mem.lastIndexOfAny;
pub const lastIndexOfStr = std.mem.lastIndexOfLinear;
pub const trim = std.mem.trim;
pub const sliceMin = std.mem.min;
pub const sliceMax = std.mem.max;

pub const parseInt = std.fmt.parseInt;
pub const parseFloat = std.fmt.parseFloat;

pub const min = std.math.min;
pub const min3 = std.math.min3;
pub const max = std.math.max;
pub const max3 = std.math.max3;

pub const print = std.debug.print;
pub const assert = std.debug.assert;

pub const sort = std.sort.sort;
pub const asc = std.sort.asc;
pub const desc = std.sort.desc;