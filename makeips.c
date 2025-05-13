#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int bswap32(int x) {
	return
	((x >> 24) & 0x000000ff) |
	((x >>  8) & 0x0000ff00) |
	((x <<  8) & 0x00ff0000) |
	((x << 24) & 0xff000000);
}

int main(int argc, char *argv[]) {
	if (argc < 3) {
		printf("makeips ver 20250509 by Yoti\n");
		printf("usage: out_file offset value\n");
		return 1;
	}

	char b;
	FILE *fp;
	unsigned int i;
	unsigned char fn[255];

	memset(&fn, 0, strlen(fn));
	strcat(fn, &argv[1][0]);
	strcat(fn, ".ips");
	if ((fp = fopen(fn, "wb")) == NULL) {
		return 2;
	}

	// header
	memset(&fn, 0, strlen(fn));
	strcat(fn, "IPS32");
	fwrite(&fn, 1, strlen(fn), fp);

	// body
	/// offset
	i = strtol(argv[2], NULL, 16);
	i = bswap32(i);
	fwrite(&i, 1, sizeof(i), fp);
	/// null byte
	b = 0;
	fwrite(&b, 1, sizeof(b), fp);
	/// len(value)
	b = strlen(argv[3])/2;
	fwrite(&b, 1, sizeof(b), fp);
	/// value
	i = strtoul(argv[3], NULL, 16);
	i = bswap32(i);
	fwrite(&i, 1, sizeof(i), fp);

	// footer
	memset(&fn, 0, strlen(fn));
	strcat(fn, "EEOF");
	fwrite(&fn, 1, strlen(fn), fp);

	fclose(fp);
	return 0;
}
