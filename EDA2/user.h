#include <stdbool.h>
#define MAXNICKSIZE 5
#define MAXNAMESIZE 25
#define MAXUSERSFOLLOWED 100

//Struct que define um user que é seguido
struct following{
	char nick[MAXNICKSIZE + 1];
	unsigned short msg;		//Ultima mensagem deste utilizador
};

//Struct que define um utilizador
struct user{
	char nick[MAXNICKSIZE + 1];
	char name[MAXNAMESIZE + 1];
	bool state;											
	struct following users_followed[MAXUSERSFOLLOWED]; 	
	unsigned short msg_sent;	
	unsigned short followers;	//Utilizadores que seguem este user
	unsigned short following;  	//Utilizadores que o user segue
};
