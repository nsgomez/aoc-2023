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
            int id = 0;
            bool valid = true;

            string[] gameInfo = line.split!isSeparator;
            foreach (string pair; gameInfo)
            {
                string[] splitPair = pair.strip().split!isWhite;
                string first = splitPair[0].strip();
                string second = splitPair[1].strip();

                stdout.writeln(first);
                stdout.writeln(second);

                if (first == "Game")
                    id = to!int(second);
                else
                {
                    int cubeCount = to!int(first);
                    if ((second == "red" && cubeCount > 12) || (second == "green" && cubeCount > 13) || (second == "blue" && cubeCount > 14))
                        valid = false;
                }
            }

            if (valid)
                result += id;
        });

    stdout.writeln(to!string(result));
}
