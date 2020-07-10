#include <stdbool.h>

struct hashTable;

struct hashTable *hashNew();
void hash_destroy(struct hashTable *t);
int hashCode(char *p);
bool hash_insert(struct hashTable *t, char *nick, int id, bool state);
int hash_find(struct hashTable *t, char *nick);
int hash_isActive(struct hashTable *t, char *nick);
bool hash_remove(struct hashTable *t, char *nick);
