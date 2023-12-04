import std.algorithm, std.array, std.ascii, std.conv, std.stdio, std.string;

pure bool isSeparator(dchar c)
{
    return c == ';' || c == ',' || c == ':';
}

void main()
{
    int result = 0;
    stdin
        .byLineCopy
        .array
        .each!((line) {
            int red = 0;
            int green = 0;
            int blue = 0;

            string[] gameInfo = line.split!isSeparator;
            foreach (string pair; gameInfo)
            {
                string[] splitPair = pair.strip().split!isWhite;
                string first = splitPair[0].strip();
                string second = splitPair[1].strip();

                stdout.writeln(first);
                stdout.writeln(second);

                if (first != "Game")
                {
                    int cubeCount = to!int(first);
                    if (second == "red")
                        red = max(red, cubeCount);
                    else if (second == "green")
                        green = max(green, cubeCount);
                    else if (second == "blue")
                        blue = max(blue, cubeCount);
                }
            }

            result += red * green * blue;
        });

    stdout.writeln(to!string(result));
}
