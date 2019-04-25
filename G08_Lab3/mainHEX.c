#include <stdio.h>

#include "./drivers/inc/HEX_displays.h"

int main() {
	HEX_flood_ASM(HEX0 | HEX1 | HEX4);
	return 0;
}
