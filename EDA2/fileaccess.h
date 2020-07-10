#include <stdio.h>
#include "hashtable.h"

void writeUser(FILE *file, struct user *user, int id);
void readUser(FILE *file, struct user *user, int id);
int loadDb(FILE *file, struct hashTable *database);
FILE *openFile(const char *filename);
