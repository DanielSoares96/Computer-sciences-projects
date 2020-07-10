#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

#include "user.h"
#include "fileaccess.h"
#include "hashtable.h"
#include "auxiliar.h"

#define BDFILENAME "users.db"
#define MAXNICKSIZE 5
#define MAXNAMESIZE 25


struct hashTable *database; 	//HashTable em memória
FILE *diskdb; 					//FD do ficheiro onde é guardada a informação
int id; 						//id do proximo utilizador a registar

/* Insere um utilizador na HashTable
 * Recebe o nick e o nome do user a incluir
 * Retorna false caso não se consiga alocar memória, true caso contrario 
 */
bool create_user(char *nick, char *name)
{	
	//Procura o user na HashTable	
	if(hash_find(database, nick) != -1)
	{
		printf("+ nick %s usado previamente\n", nick);
		return true;
	}
	
	//Cria um utilizador
	struct user *newuser = malloc(sizeof(struct user));
	if(newuser == NULL)
		return false;	//Caso não consiga alocar memória
	strcpy(newuser->nick, nick);
	strcpy(newuser->name, name);
	newuser->state = true;
	newuser->msg_sent = 0;
	newuser->followers = 0;
	newuser->following = 0;
		
	//Guarda o utilizador na HashTable e no disco
	if(hash_insert(database, nick, id, true))
	{
		writeUser(diskdb, newuser, id);
		id++;
		printf("+ utilizador %s criado\n", nick);
		free(newuser);
		return true;
	}
	
	free(newuser);
	return false;
}

/* Remove um utilizador da hashtable
 * Recebe o nick a remover
 * Retorna false caso não se consiga alocar memória, true caso contrario 
 */
bool remove_user(char *nick)
{
	struct user *user;
	
	//Procura o user na HashTable	
	int id = hash_isActive(database,nick);	
	if(id == -1)
	{
		printf("+ utilizador %s inexistente\n",nick);
		return true;
	}
	
	//Lê o user do disco
	user = malloc(sizeof(struct user));
	if(user == NULL)
		return false; //Caso não consiga alocar memória
	readUser(diskdb, user, id);	
	
	//Altera o estado e escreve de volta no disco
	user->state = false;	
	writeUser(diskdb, user, id);
	
	//Altera o estado na HashTable
	hash_remove(database,nick);
	
	printf("+ utilizador %s removido\n",nick);
	free(user);
	return true;
}

/* Seguir um utilizador
 * Recebe nick1 e nick2
 * Retorna false caso não se consiga alocar memória, true caso contrario 
 */
bool follow_user(char *nick1, char *nick2)
{
	struct user *user1;
	struct user *user2;
	int id1;
	int id2;
	
	//Tenta encontrar nick1
	id1 = hash_isActive(database,nick1);
	if(id1 == -1)
	{
		printf("+ utilizador %s inexistente\n",nick1);
		return true;
	}
	
	//Tenta encontrar nick2
	id2 = hash_isActive(database,nick2);
	if(id2 == -1)
	{
		printf("+ utilizador %s inexistente\n",nick2);
		return true;
	}
	
	//Lê os dois utilizadores do disco
	user1 = malloc(sizeof(struct user));
	user2 = malloc(sizeof(struct user));
	if(user1 == NULL || user2 == NULL)
		return false; //Caso não consiga alocar memória
	readUser(diskdb, user1, id1);
	readUser(diskdb, user2, id2);
	
	//Verifica se nick1 já segue nick2
	if(BinarySearch(nick2, user1->following, user1->users_followed) != -1)
	{
		printf("+ utilizador %s segue %s\n",nick1,nick2);
		free(user1);
		free(user2);
		return true;
	}
	
	//Verifica se já segue o limite
	if(user1->following == 100)
	{
		printf("+ utilizador %s segue o limite\n",nick1);
		free(user1);
		free(user2);
		return true;
	}
	
	//Cria um novo seguido
	struct following newfollow = {.msg = user2->msg_sent};
	strcpy(newfollow.nick, nick2);
	
	//Adiciona-o de forma ordenada ao Array de seguidos
	addArraySorted(newfollow, user1->following, user1->users_followed);
	
	printf("+ %s passou a seguir %s\n",nick1,nick2);
	
	//Se o utilizador se seguir a ele próprio apenas altera no primeiro
	if(strcmp(nick1, nick2) == 0)
	{
		user1->following += 1;
		user1->followers += 1;
		writeUser(diskdb, user1, id1);
		free(user1);
		free(user2);
		return true;
	}
	
	//Altera os valores e guarda no disco os dois users
	user1->following += 1;
	user2->followers += 1;
	writeUser(diskdb, user2, id2);
	writeUser(diskdb, user1, id1);
	
	free(user1);
	free(user2);
	return true;
}

/* Deixar de seguir um Utilizador
 * Recebe nick1 e nick2
 * Retorna false caso não se consiga alocar memória, true caso contrario 
 */
bool unfollow_user(char *nick1, char *nick2)
{
	struct user *user1;
	struct user *user2;
	int id1;
	int id2;
	
	//Tenta encontrar nick1
	id1 = hash_isActive(database,nick1);
	if(id1 == -1)
	{
		printf("+ utilizador %s inexistente\n",nick1);
		return true;
	}
	
	//Tenta encontrar nick2
	id2 = hash_isActive(database,nick2);
	if(id2 == -1)
	{
		printf("+ utilizador %s inexistente\n",nick2);
		return true;
	}
	
	//Lê os dois utilizadores do disco
	user1 = malloc(sizeof(struct user));
	user2 = malloc(sizeof(struct user));
	if(user1 == NULL || user2 == NULL)
		return false;
	readUser(diskdb, user1, id1);
	readUser(diskdb, user2, id2);
	
	//Tenta Remover nick2 da lista de seguidos de nick1
	if(removeArraySorted(nick2, user1->following, user1->users_followed))
	{
		printf("+ %s deixou de seguir %s\n",nick1, nick2);
	}
	else{
		printf("+ utilizador %s nao segue %s\n",nick1, nick2);
		free(user1);
		free(user2);
		return true;
	}	
	
	//Se o utilizador deixar de se seguir a ele próprio apenas altera no primeiro
	if(strcmp(nick1,nick2) == 0)
	{
		user1->following -= 1;
		user1->followers -= 1;
		writeUser(diskdb, user1, id1);
		free(user1);
		free(user2);
		return true;
	}
	
	//Altera os valores e guarda no disco os dois users
	user1->following -= 1;
	user2->followers -= 1;	
	writeUser(diskdb, user2, id2);
	writeUser(diskdb, user1, id1);
	
	free(user1);
	free(user2);
	return true;
}

/* Envia uma mensagem para o Sistema
 * Recebe nick do user
 * Retorna false caso não se consiga alocar memória, true caso contrario 
 */
bool send_message(char *nick)
{
	struct user *user;
	int id;
	
	//Tenta encontrar nick
	id = hash_isActive(database,nick);
	if(id == -1)
	{
		printf("+ utilizador %s inexistente\n",nick);
		return true;
	}
	
	//Lê o user do disco
	user = malloc(sizeof(struct user));	
	if(user == NULL)
		return false;
	readUser(diskdb, user, id);
	
	//Altera as mensagens enviadas e guarda-o novamente no disco
	user->msg_sent += 1;	
	writeUser(diskdb, user, id);
	
	free(user);	
	return true;
}

/* Lê as mensagens de um utilizador
 * Recebe o nick do utilizador
 * Retorna false caso não se consiga alocar memória, true caso contrario 
 */
bool read_messages(char *nick)
{
	struct user *user;
	struct user *seguido;
	struct following *users_followed;
	int id;	
	
	//Tenta encontrar nick
	id = hash_isActive(database,nick);
	if(id == -1)
	{
		printf("+ utilizador %s inexistente\n",nick);
		return true;
	}
	
	//Carrega o utilizador para memória
	user = malloc(sizeof(struct user));
	if(user == NULL)
		return false;
	readUser(diskdb, user, id);
	
	//Carrega o Array dos seguidos do user para memória e a sua ocupação
	users_followed = user->users_followed;
	short size = user->following;
	
	//Não tem seguidos
	if(size == 0)
	{
		printf("+ utilizador %s sem seguidos\n", nick);
		free(user);
		return true;
	}	
	
	seguido = malloc(sizeof(struct user));
	if(seguido == NULL)
		return false;
	
	//Percorre o Array dos utilizadores seguidos
	for(short i=0; i<size; i++)
	{
		int id_seguido = hash_isActive(database, users_followed[i].nick);
		
		//Utilizador foi removido
		if(id_seguido == -1)
		{
			printf("utilizador %s desactivado\n", users_followed[i].nick);
			removeArraySorted(users_followed[i].nick, size, users_followed);
			size--;
			i--;
			user->following--;
			writeUser(diskdb, user, id);
			continue;
		}
		
		//Carrega o utilizador para memória e as mensagens
		readUser(diskdb, seguido, id_seguido);		 
		short msg_user = users_followed[i].msg;
		short msg_now = seguido->msg_sent;
		
		//Print do output em funçao do nº de mensagens
		if(msg_now - msg_user == 0)
		{
			printf("sem mensagens novas de %s (%s)\n",seguido->nick, seguido->name);
		}
		else if(msg_now - msg_user == 1)
		{
			printf("mensagem nova de %s (%s): %d\n",seguido->nick, seguido->name, msg_now);
			readUser(diskdb, user, id);
			user->users_followed[i].msg = msg_now;
			writeUser(diskdb, user, id);
		}
		else
		{
			printf("mensagens novas de %s (%s): %d a %d\n",seguido->nick, seguido->name, msg_user+1, msg_now);
			readUser(diskdb, user, id);
			user->users_followed[i].msg = msg_now;
			writeUser(diskdb, user, id);
		}		
	}
	
	free(user);
	free(seguido);
	return true;
}

/* Print da informação de um utilizador
 * Recebe um nick do utilizador
 * Retorna false caso não se consiga alocar memória, true caso contrario 
 */
bool user_inf(char *nick)
{
	struct user *user;
	int id;
	
	//Tenta encontrar nick
	id = hash_isActive(database,nick);
	if(id == -1)
	{
		printf("+ utilizador %s inexistente\n",nick);
		return true;
	}
	
	//Carrega um utilizador para memória
	user = malloc(sizeof(struct user));
	if(user == NULL)
		return false;
	readUser(diskdb, user, id);
	
	//Print das ifnormações
	printf("utilizador %s (%s)\n",nick, user->name);
	printf("%d mensagens, %d seguidores, segue %d utilizadores\n",user->msg_sent, user->followers, user->following);
	for(int i=0; i<user->following; i++)
	{
		printf("%s (%d lidas)\n",user->users_followed[i].nick, user->users_followed[i].msg);
	}
	
	free(user);
	return true;
}

/* Elimina as estruturas usadas da memória e fecha a ligaçao ao ficheiro
 * Não recebe nenhum argumento
 * Não retorna nenhum valor
 */
void prog_exit()
{
	hash_destroy(database);
	fclose(diskdb);
}

int main(void){
	
	char option;
	char nick1[MAXNICKSIZE + 1];
	char nick2[MAXNICKSIZE + 1];
	char name[MAXNAMESIZE + 1];
	
	id = 0;
	
	//Abre o ficheiro
	diskdb = openFile(BDFILENAME);
	
	//Inicializa  a HashTable
	database = hashNew();
	if(database == NULL)
		return 1;
	
	//Carrega os users em disco para a HashTable
	id = loadDb(diskdb, database);
	
	//Loop da interface do Utilizador
	while(scanf("%c", &option) != EOF)
	{		
		switch(option)
		{
			case 'U':
				scanf("%5s %[^\n]25s",nick1, name);
				if(!create_user(nick1, name))
					return 1;
				break;
			case 'R':
				scanf("%5s", nick1);
				if(!remove_user(nick1))
					return 1;
				break;
			case 'S':
				scanf("%5s %5s",nick1,nick2);
				if(!follow_user(nick1, nick2))
					return 1;
				break;
			case 'D':
				scanf("%5s %5s",nick1,nick2);
				if(!unfollow_user(nick1, nick2))
					return 1;
				break;
			case 'P':
				scanf("%5s", nick1);
				if(!send_message(nick1))
					return 1;
				break;
			case 'L':
				scanf("%5s", nick1);
				if(!read_messages(nick1))
					return 1;
				break;
			case 'I':
				scanf("%5s", nick1);
				if(!user_inf(nick1))
					return 1;
				break;
			case 'X':
				prog_exit();
				return 0;
				break;
		}	
	}
}
