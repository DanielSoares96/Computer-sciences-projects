#include <stdio.h>
#include "user.h"
#include "hashtable.h"

/* Abre o ficheiro com o nome filename
 * Cria-o se não existir
 * Devolve o file pointer, erro caso não consiga abrir
 */
FILE *openFile(const char *filename)
{
	FILE *temp = fopen(filename, "rb+");
	
	if(temp == NULL)
	{
		temp = fopen(filename, "wb");
		fclose(temp);
		temp = fopen(filename, "rb+");
	}
	
	if(temp == NULL)
	{
		perror("open: ");
	}
	
	return temp;
}

/* Escreve um utilizador user na posição id do ficheiro
 * Recebe um fp do ficheiro o user e o id do user
 * Não retorna nenhum valor
 */
void writeUser(FILE *file, struct user *user, int id)
{
	fseek(file, id * sizeof(struct user), SEEK_SET);
	fwrite(user, sizeof(struct user), 1, file);
}

/* Lê um utilizador user da posição id do ficheiro
 * Recebe um fp do ficheiro o user e o id do user
 * Não retorna nenhum valor
 */
void readUser(FILE *file, struct user *user, int id)
{
	fseek(file, id * sizeof(struct user), SEEK_SET);
	fread(user, sizeof(struct user), 1, file);
}

/* Carrega todos os utilizadores encontrados do ficheiro para a hashTable
 * Recebe um fp do ficheiro e a HasTable a preencher
 * Devolve o id do ultimo utilizador encontrado
 */
int loadDb(FILE *file, struct hashTable *database)
{
	struct user user;	
	int id=0;
	
	while (fread(&user, sizeof(struct user), 1, file) != 0)
	{
		hash_insert(database, user.nick, id, user.state);
		id++;
	}
	
	return id;
}
