const std = @import("std");

fn to_tag(ptr: []u8) u16 {
    return (26 * 26 * @as(u16, ptr[0] - 'A')) + (26 * @as(u16, ptr[1] - 'A')) + @as(u16, ptr[2] - 'A');
}

fn gcd(first: usize, second: usize) usize {
    var a: usize = first;
    var b: usize = second;

    while (b != 0) {
        var tmp: usize = a % b;
        a = b;
        b = tmp;
    }

    return a;
}

fn lcm(a: usize, b: usize) usize {
    return (a * b) / gcd(a, b);
}

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    var sequence_buf: [384]u8 = undefined;
    _ = try stdin.readUntilDelimiterOrEof(&sequence_buf, '\n');

    var buf: [32]u8 = undefined;
    _ = try stdin.readUntilDelimiterOrEof(&buf, '\n'); // skip blank line

    var left: [32768]u16 = undefined;
    var right: [32768]u16 = undefined;

    var nodes_of_interest: [16]u16 = undefined;
    var num_nodes_of_interest: usize = 0;

    while (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        // Turn the node identifier into a simple int to make lookups easier.
        // Since each letter in a node is a letter A-Z, they can be turned into
        // a number 0-25.
        var node_tag: u16 = to_tag(line[0..3]);
        var left_tag: u16 = to_tag(line[7..10]);
        var right_tag: u16 = to_tag(line[12..15]);

        left[node_tag] = left_tag;
        right[node_tag] = right_tag;

        if (line[2] == 'A') {
            try stdout.print("Found interesting node {s} to start from\n", .{line[0..3]});
            nodes_of_interest[num_nodes_of_interest] = node_tag;
            num_nodes_of_interest += 1;
        }
    }

    var factors: [16]usize = undefined;
    var i: usize = 0;

    while (i < num_nodes_of_interest) : (i += 1) {
        var steps: usize = 0;
        var sequence_iter: usize = 0;
        var current_tag: u16 = nodes_of_interest[i];

        while (current_tag % 26 != 'Z' - 'A') {
            if (sequence_buf[sequence_iter] == 'L') {
                current_tag = left[current_tag];
            }
            else {
                current_tag = right[current_tag];
            }

            steps += 1;
            sequence_iter += 1;

            if (sequence_buf[sequence_iter] == '\n') {
                sequence_iter = 0;
            }
        }

        factors[i] = steps;
        try stdout.print("Factor {}: {}\n", .{i, steps});
    }

    var result: usize = lcm(factors[0], factors[1]);
    i = 2;
    while (i < num_nodes_of_interest) : (i += 1) {
        result = lcm(result, factors[i]);
    }

    try stdout.print("{}\n", .{result});
}
