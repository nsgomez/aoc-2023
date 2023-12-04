#include <ctype.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stdio.h>
#include <sys/mman.h>
#include <sys/stat.h>

char const* parse_part(char const* schematic, int* partNumberOut, int* lineOffset, int lineLength, int lineNum, int maxLineNum);

int main(int argc, char const** argv)
{
	if (argc != 2)
	{
		fprintf(stderr, "Usage: %s <input file>\n", argv[0]);
		return 1;
	}

	struct stat sb;
	if (lstat(argv[1], &sb) == -1)
	{
		perror("lstat");
		return 1;
	}

	int fd = open(argv[1], O_RDONLY);
	if (fd == -1)
	{
		perror("open");
		return 1;
	}

	char const* schematic = mmap(NULL, sb.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
	if (schematic == (char*)-1)
	{
		perror("mmap");
		return 1;
	}

	int sum = 0;
	int lineLength = 0;

	// Probe for the length of each line
	while (schematic[++lineLength] != '\n');
	++lineLength;

	char const* schematicEnd = schematic + sb.st_size;
	int lineNum = 0;
	int lineOffset = 0;

	while (schematic != schematicEnd)
	{
		if (!isdigit(*schematic))
		{
			if (*schematic == '\n')
			{
				++lineNum;
				lineOffset = 0;
			}
			else
			{
				++lineOffset;
			}

			++schematic;
			continue;
		}

		int partNumber = 0;
		schematic = parse_part(schematic, &partNumber, &lineOffset, lineNum, (sb.st_size / lineLength) - 1, lineLength);
		sum += partNumber;
	}

	fprintf(stdout, "%d\n", sum);
	return 0;
}

bool is_interesting_symbol(char c)
{
	return !isdigit(c) && c != '.' && c != '\n';
}

bool bounding_line_contains_symbol(char const* schematic, int lineOffset, int charCount)
{
	for (int i = 0; i < charCount + 1; i++)
	{
		if (is_interesting_symbol(schematic[i]))
			return true;
	}

	return lineOffset != 0 && is_interesting_symbol(schematic[-1]);
}

char const* parse_part(char const* schematic, int* partNumberOut, int* lineOffset, int lineNum, int maxLineNum, int lineLength)
{
	int partNumber = 0;
	int charCount = 0;

	while (isdigit(schematic[charCount]))
	{
		partNumber = (partNumber * 10) + (schematic[charCount] - '0');
		++charCount;
	}

	if (bounding_line_contains_symbol(schematic, *lineOffset, charCount))
		goto symbol_found;
	
	if (lineNum != 0 && bounding_line_contains_symbol(schematic - lineLength, *lineOffset, charCount))
		goto symbol_found;

	if (lineNum != maxLineNum && bounding_line_contains_symbol(schematic + lineLength, *lineOffset, charCount))
		goto symbol_found;

	goto end;

symbol_found:
	*partNumberOut = partNumber;

end:
	fprintf(stdout, "%d -> %d [%d, %d, %d]\n", partNumber, *partNumberOut, *lineOffset, lineNum, maxLineNum);
	*lineOffset += charCount;
	return schematic + charCount;
}
