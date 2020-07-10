#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>


typedef struct prog{ //crição do prog
	
	int id;
	int pc; 
	char inst[100];
	int estado;
	int blocked_counter;
	int Go_to_begin;
	
} prog;	

typedef struct Node{ 	//criação do nó
	
	prog *elem;			//elemento inteiro
	struct Node *next;	//o próximo nó

} Node;


typedef struct Queue{	//Uma Queue com nós
	
	struct Node *head;
	int size;
	int limit;
} Queue;

prog *Prog_new(int id, char* inst){
	
	int i = 0;
	int j = 0;
	
	prog *Prog = malloc(sizeof(Prog));
	Prog -> id = id;
	Prog -> pc = 0;
	Prog -> estado = 0;
	Prog -> Go_to_begin = 0;
	
	while (inst[i] != '\0') {
		
		if (inst[i] !=' '){
		
		Prog -> inst[j] = inst[i];
		j++;
		
		}
		
	i++;
	
	}
	return Prog;
	
}

//cria e inicializa uma nova Queue
Queue *list_new(int t){	//aloca e inicializa a Queue com NULL's
	
	Queue *list = malloc(sizeof(Queue)); //espaco necessario para a Queue
	
	
	//Inicializa a Queue com tamanho 0 e NULL na cabeca
	list -> head = NULL;
	list -> size = 0;
	list -> limit = t;
	
	return list;
}
//Cria e inicializa o novo nó
Node *node_new(){
	
	Node *node = malloc(sizeof(Node));
	node -> next = NULL;
	return node;
}
//Insere um elemento no fim da Queue
void Enqueue(Queue *list, Node *value){
	
	if(list -> size < list -> limit){
		//printf("Não pode dar enqueue");
		
		if(list -> head == NULL){ //Se a lista estiver vazia o elemento passa a ser a cabeça

			list -> head = value;
	}
	
		else {						//percorre a lista ate ao fim
			
			Node * current = list -> head;
			
			while( current -> next != NULL)
			{
				current = current -> next;
			}
				//insere no final da Queue
				//~ nod -> next = NULL;
				current -> next = value;
				
		}
		list -> size++;
	}
}

Node *Dequeue(Queue *list){		//Retira o primeiro elemento da Queue
	
	
	if (list -> head != NULL){ 
		Node *tmp;
		tmp = list -> head;
		tmp -> next = NULL;
		list -> head= list -> head -> next;
		//printf("\nRemoveu \n");
		list -> size--;
		return tmp;
}

	return NULL;
}

void Print(Queue *list) { //Print do id dos nós dentro da Queue 
	Node* tmp = list -> head;
	while(tmp != NULL) {
		printf("%d ", tmp -> elem -> estado);
		
		if(tmp -> next != NULL){
			printf(" ");
		}
		
		tmp = tmp -> next;
	}
}

int Queue_lenght(Queue *list){ //retorina o tamanho da Queue
	return list -> size;
}


