const std = @import("std");
const util = @import("util.zig");

const input = @embedFile("../data/day4.txt");

const Board = struct {
    done: bool = false,
    marked: [25]i16,
    numbers: [25]i16,

    pub fn init(self: *Board) void {
        self.done = false;
        for (self.marked) |_, i| {
            self.marked[i] = 0;
            self.numbers[i] = 0;
        }
    }

    pub fn reset(self: *Board) void {
        self.done = false;
        for (self.marked) |_, i| {
            self.marked[i] = 0;
        }
    }

    pub fn play(self: *Board, number: i16) void {
        for (self.numbers) |n, i| {
            if (number == n) {
                self.marked[i] = 1;
            }
        }
    }

    pub fn sumOfNonMarkedNumbers(self: *const Board) i16 {
        var sum: i16 = 0;
        for (self.marked) |m, i| {
            if (m == 0) {
                sum += self.numbers[i];
            }
        }
        return sum;
    }

    pub fn printBoard(self: *const Board) void {
        var c: usize = 0;
        while (c < 5) {
            printf("{} {} {} {} {}\n", .{ self.numbers[c*5 + 0], self.numbers[c*5 + 1], self.numbers[c*5 + 2], self.numbers[c*5 + 3], self.numbers[c*5 + 4]});
            c += 1;
        }
        printf("\n", .{});
    }

    pub fn detectBingo(self: * const Board) bool {
        var c: usize = 0;
        while (c < 5) {
            var s: i16 = 0;
            // Row
            s = 0;
            s += self.marked[c*5 + 0];
            s += self.marked[c*5 + 1];
            s += self.marked[c*5 + 2];
            s += self.marked[c*5 + 3];
            s += self.marked[c*5 + 4];
            if (s == 5) {
                return true;
            }
            // Column
            s = 0;
            s += self.marked[c + 0*5];
            s += self.marked[c + 1*5];
            s += self.marked[c + 2*5];
            s += self.marked[c + 3*5];
            s += self.marked[c + 4*5];
            if (s == 5) {
                return true;
            }
            c += 1;
        }
        return false;
    }
};

pub fn main() !void {
    var random_numbers = std.ArrayList(i16).init(std.heap.page_allocator);
    defer random_numbers.deinit();

    var lines = util.tokenize(u8, input, "\n");    
    {
        var line = lines.next();
        {
            var numbers = util.tokenize(u8, line.?, ",");
            while (numbers.next()) |numstr| {
                //printf("n = {s}\n", .{numstr});
                var n = try util.parseInt(i16, numstr, 10);
                try random_numbers.append(n);
            }
        }
    }

    var boards = std.ArrayList(Board).init(std.heap.page_allocator);
    defer boards.deinit();

    {
        var board: Board = Board{ .done=false, .marked=undefined, .numbers=undefined };
        board.init();

        var row: usize = 0;
        while (lines.next()) |line| {
            //printf("{s}\n", .{line});

            if (row == 5) {
                try boards.append(board);
                row = 0;
                board.init();
            }
            
            {
                var numbers = util.tokenize(u8, line[0..], " ");
                var column: usize = 0;
                while (numbers.next()) |numstr| {
                    var n = try util.parseInt(i16, numstr, 10);
                    board.numbers[row*5 + column] = n;
                    column += 1;
                }
                row += 1;
            }
        }
    }

    //for (boards.items) |board| {
    //    board.printBoard();
    //}

    printf("part1: {}, part2: {}\n", .{part1(boards.items, random_numbers.items), part2(boards.items, random_numbers.items)});

    return;
}

pub fn part2(boards: []Board, random_numbers: []i16) i16 {
    var result: i16 = 0;
    var num_boards_have_bingo: i16 = 0;

    for (boards) |*board| {
        board.reset();
    }

    round: for (random_numbers) |number| {
        for (boards) |*board| {
            if (!board.done) {
                board.play(number);
            }
        }

        for (boards) |*board| {
            if (!board.done) {
                if (board.detectBingo()) {
                    board.done = true;
                    num_boards_have_bingo += 1;            
                    if (num_boards_have_bingo == boards.len) {
                        // Ok, this was the last board that has reached 'bingo'
                        var sum = board.sumOfNonMarkedNumbers();
                        result = sum * number;
                        break :round;
                    }
                }
            }
        }
    }
    return result;
}

pub fn part1(boards: []Board, random_numbers: []i16) i16 {
    var result: i16 = 0;

    for (boards) |*board| {
        board.reset();
    }

    round: for (random_numbers) |number| {
        for (boards) |*board| {
            board.play(number);
        }
        for (boards) |*board| {
            if (board.detectBingo()) {
                board.done = true;
                var sum = board.sumOfNonMarkedNumbers();
                result = sum * number;
                break :round;
            }
        }
    }
    return result;
}

pub fn printf(comptime fmtstr: []const u8, args: anytype) void {
    const stdout = std.io.getStdOut().writer();
    nosuspend stdout.print(fmtstr, args) catch return;
}
