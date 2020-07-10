#include <string.h>
#include <stdbool.h>

int BinarySearch(char *nick, int size, struct following array[]);
void addArraySorted(struct following newfollow, int size, struct following array[]);
bool removeArraySorted(char *nick, int size, struct following array[]);
