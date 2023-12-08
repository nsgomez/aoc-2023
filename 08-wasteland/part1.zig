const std = @import("std");

fn to_tag(ptr: []u8) u16 {
    return (26 * 26 * @as(u16, ptr[0] - 'A')) + (26 * @as(u16, ptr[1] - 'A')) + @as(u16, ptr[2] - 'A');
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

    while (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        // Turn the node identifier into a simple int to make lookups easier.
        // Since each letter in a node is a letter A-Z, they can be turned into
        // a number 0-25.
        var node_tag: u16 = to_tag(line[0..3]);
        var left_tag: u16 = to_tag(line[7..10]);
        var right_tag: u16 = to_tag(line[12..15]);

        left[node_tag] = left_tag;
        right[node_tag] = right_tag;

        try stdout.print("{s} = ({s}, {s}) || {} = ({}, {})\n", .{
            line[0..3],
            line[7..10],
            line[12..15],
            node_tag,
            left_tag,
            right_tag
        });
    }

    var steps: usize = 0;
    var current_tag: u16 = 0;
    var sequence_iter: usize = 0;

    const zzz_tag: u16 = 17575;
    while (current_tag != zzz_tag) {
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

    try stdout.print("{}\n", .{steps});
}
