#include <stdio.h>
#include <stdlib.h>
#include <string.h>

long long int bswap64(long long int x) {
	return
	((x << 56) & 0xff00000000000000UL) |
	((x << 40) & 0x00ff000000000000UL) |
	((x << 24) & 0x0000ff0000000000UL) |
	((x <<  8) & 0x000000ff00000000UL) |
	((x >>  8) & 0x00000000ff000000UL) |
	((x >> 24) & 0x0000000000ff0000UL) |
	((x >> 40) & 0x000000000000ff00UL) |
	((x >> 56) & 0x00000000000000ffUL);
}

int main(int argc, char *argv[]) {
	if (argc < 2) {
		printf("hexfind ver 20250509 by Yoti\n");
		printf("usage: in_file pattern_value\n");
		return 1;
	}

	int i;
	int fl;
	int pl;
	FILE *fp;
	long long int t;
	long long int p;
	unsigned char fn[255];

	// file
	memset(&fn, 0, strlen(fn));
	strcat(fn, &argv[1][0]);
	if ((fp = fopen(fn, "rb")) == NULL) {
		return 2;
	}

	// file length
	fseek(fp, 0, SEEK_END);
	fl = ftell(fp);
	fseek(fp, 0, SEEK_SET);

	// pattern
	p = strtoull(argv[2], NULL, 16);
	p = bswap64(p);

	// pattern length
	pl = strlen(argv[2]) / 2;

	for (i = 0; i < (fl - pl); i++) {
		fread(&t, 8, 1, fp);
		fseek(fp, -7, SEEK_CUR);
		if (t == p) {
			printf("%X", ftell(fp) - 1);
			break;
		}
	}

	fclose(fp);
	return 0;
}
