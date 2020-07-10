#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SIZE 2000003
#define MAXNICKSIZE 5

struct cell{
	char nick[MAXNICKSIZE + 1];
	int id;
	bool active;
};

struct hashTable{
	struct cell *table[SIZE];
};

/* Cria uma nova HashTable em memória
 * Não recebe nenhum argumento
 * Retorna um apontador para uma hastable com todas os indices a NULL
 * Retorna NULL caso não consiga alocar memória
 */
struct hashTable *hashNew()
{
	struct hashTable *new = malloc(sizeof(struct hashTable));
	if(new == NULL)
		return NULL;
	
	for(int i=0; i < SIZE; i++)
		new->table[i] = NULL;
	
	return new;
}

/* Destroi uma Hastable
 * Recebe um apontador para a HasTable e destroi cada elemento
 * Não retorna nenhum valor
 */ 
void hash_destroy(struct hashTable *t)
{
	for(int i=0; i<SIZE; i++)
		free(t->table[i]);
	free(t);
}

/* HashCode um de uma string p
 * Recebe uma String e devolve um index
 * Algoritmo de Hash usado djb2
 * http://www.cse.yorku.ca/~oz/hash.html
 */
int hashCode(char *p)
{
	unsigned long hash = 5381;
	int c;
	while ((c = *p++))
		hash = ((hash << 5) + hash) + c; /* hash * 33 + c */
		
	return hash % SIZE;
}

/* Insere uma celula na HashTable
 * Recebe a HashTable, o nick, id e estado do utilizador
 * Retorna true caso consiga inserir, false caso contrário
 */
bool hash_insert(struct hashTable *t, char *nick, int id, bool state)
{
	int hashIndex = hashCode(nick);
	
	//Cria e preenche os elementos de uma célula da hashtable
	struct cell *cell = malloc(sizeof(struct cell));
	if(cell == NULL)
		return false;
		
	strcpy(cell->nick,nick);
	cell->id=id;
	cell->active = state;
	
	while(t->table[hashIndex] != NULL && strcmp(t->table[hashIndex]->nick,nick) != 0)
	{
		hashIndex++;
		hashIndex %= SIZE;
	}
	
	t->table[hashIndex] = cell;
	return true;
}

/* Procura um utilizador na HashTable
 * Recebe uma hashtable e um nick
 * Retorna o id do utilizador se for encontrado, -1 caso nao encontre
 */ 
int hash_find(struct hashTable *t, char *nick)
{
	int hashIndex = hashCode(nick);
	
	while(t->table[hashIndex] != NULL)
	{
		if(strcmp(t->table[hashIndex]->nick,nick) == 0)
		{
			return t->table[hashIndex]->id;
		}
		
		hashIndex++;
		hashIndex %= SIZE;
	}
	
	return -1;
}

/* Procura um utilizador na HashTable que esteja activo
 * Recebe uma hashtable e um nick
 * Retorna o id do utilizador se for encontrado e esteja activo, 
 * -1 caso nao encontre ou esteja inactivo * 
 */ 
int hash_isActive(struct hashTable *t, char *nick)
{
	int hashIndex = hashCode(nick);
	
	while(t->table[hashIndex] != NULL)
	{
		if(strcmp(t->table[hashIndex]->nick,nick) == 0 && t->table[hashIndex]->active)
		{
			return t->table[hashIndex]->id;
		}
		
		hashIndex++;
		hashIndex %= SIZE;
	}
	
	return -1;
}

/* Desactiva um utilizador
 * Recebe uma hashtable e um nick desactiva esse user na HashTable
 * Devolve true caso encontre e esteja activo, false caso contrario
 */
bool hash_remove(struct hashTable *t, char *nick)
{
	int hashIndex = hashCode(nick);
	
	while(t->table[hashIndex] != NULL)
	{
		if(strcmp(t->table[hashIndex]->nick,nick) == 0 && t->table[hashIndex]->active)
		{
			t->table[hashIndex]->active = false;
			return true;
		}
		hashIndex++;
		hashIndex %= SIZE;
	}
	return false;
}
