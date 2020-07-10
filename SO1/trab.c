#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <pthread.h>
#include <unistd.h>
#include "Queue.c"

Queue *new;
Queue *ready;
Queue *running;       //Inicializa as Queue
Queue *Exit;
Queue *blocked;

pthread_t thread_id;


int quantum = 3;
int Leave_run = 0;
int n_programas = 0;
int tempo = 0;


void node_prog(prog *P){ //Introduz um programa no nó e coloca-o na Queue new
	
	Node *novo  = node_new();
	novo -> elem = P;
	Enqueue(new,novo);
	
}


void * Read_file(void* arg){ //Lê o ficheiro dado pelo utilizador
		
	FILE* ficheiro;
	char* linha = NULL;
	size_t len = 0;
	char programa[20];
	
	printf("insira um programa: ");
	
	scanf("%s", programa);	 
	
	ficheiro = fopen(programa ,"r");
	
	if (ficheiro == NULL){
		printf("\nFicheiro não encontrado!");
	}
	else {
			getline(&linha, &len, ficheiro);
			printf("linha lida: %s", linha);
		
		n_programas++;
		prog *lido = Prog_new(n_programas,linha);
		node_prog(lido);
		
	}
	pthread_create(&thread_id, NULL, &Read_file, NULL);
	fclose(ficheiro);
	return NULL;
}


void Admit(){ //Verifica e admite se houver no máximo 4 processos no ready
	if (new -> head != NULL){
		if (ready -> size <=4){
			
			Enqueue(ready,Dequeue(new));
			ready -> head -> elem -> estado = 1;
			
		}	
		else{
			
		}
				
	}
}

void Dispach(){ //Dispacha o processo para o running se não houver nenhum processo no mesmo
	
	if (running -> head == NULL){

		if (ready -> head !=NULL){				
			Enqueue(running,Dequeue(ready));
			running -> head -> elem -> estado = 2;
		}
 	}	
}

void Release(){ //Envia o processo do running para o exit
	
	running -> head -> elem -> estado = 3;
	Enqueue(Exit,Dequeue(running));
	Leave_run = 0;

}

void Timeout(){ //Dá timeout ao processo se exceder o quantum
	if (running -> size != 0){
		
		running -> head -> elem -> estado = 1;
		Enqueue(ready,Dequeue(running));
		
		Leave_run = 0;
	}
}

void Event_Wait(){ //Transfere do running para o blocked
	
	Enqueue(blocked,Dequeue(running));
	blocked -> head -> elem -> estado = 4;	
	
}

void Event_Occurs(){ //Transfere do blocked para o ready
	
	Enqueue(ready,Dequeue(blocked));
	ready-> head-> elem-> estado = 1;

}

void blocked_counter_increment(){
	if (blocked -> size != 0){
		
		blocked->head->elem->blocked_counter++;
		
		if (blocked->head->elem->blocked_counter == 4){
			
			Event_Occurs();
		}
	}
}
	
void run(){ //percorre o Array de instruções
	
	
	
	if(running -> size != 0){
		
		char proc = running -> head -> elem -> inst[running -> head -> elem -> pc];
			
	
				if (proc == '0'){
					
					Release();
				}
		
				else if (proc == '1'){
						
						running -> head -> elem -> pc++;
						
					}
		
				else if (proc == '2'){
						
						running -> head -> elem -> pc++;
						running -> head -> elem -> blocked_counter = 0;
						Event_Wait();
					}
		
				else if (proc == '3'){
						if (running -> head -> elem -> Go_to_begin < 10){
					
							running -> head -> elem -> pc = 0;
							running -> head -> elem -> Go_to_begin++;
					}
				
						else{
							
							running -> head -> elem -> inst[running -> head -> elem -> pc] = '1';
				  			running -> head -> elem -> pc ++;
							running -> head -> elem -> Go_to_begin = 0;
						}	
					}
				
				else if (proc == '4'){
					
					(running -> head -> elem -> pc)++;
					n_programas++;
					prog *fork = Prog_new(n_programas,running -> head -> elem -> inst);
					fork -> pc = running -> head -> elem -> pc;
					node_prog(fork);
			
				
				}	
		
			Leave_run++;
			if (Leave_run == quantum){
			Timeout();
			}
		}	
}
	

void Scheduler(int* Array){ //Recebe um Array, cria o ficheiro e coloca os estados dos programas  
	
	FILE *ficheiro;
	ficheiro = fopen("scheduler.out","a");
	
	for (int i = 0; i <= n_programas - 1; i++){
		
		if (Array[i] == 0){
				
				fprintf(ficheiro,"%s","NEW|");
				
		}	
			else if (Array[i] == 1){
					
					fprintf(ficheiro,"%s","READY|");
			
			}
			
			else if (Array[i] == 2){						
					
					fprintf(ficheiro,"%s","RUNNING|");
				
			}
	
			else if (Array[i] == 3){
					
					fprintf(ficheiro,"%s","EXIT|");
			
			}
			
			else if (Array[i] == 4){
					
					fprintf(ficheiro,"%s","BLOCKED|");
			
			}
		
	}
	
	fprintf(ficheiro,"%s","\n");
	fclose(ficheiro);
}

void output(){ //Coloca no Array os estados dos programas em posição consoante o seu id
	
	int Estado[n_programas];
	
	Node *tmp = new -> head;
	 
	if (new -> size !=0){
		
		while (tmp != NULL){
			
			Estado[(tmp -> elem -> id) - 1] = tmp -> elem -> estado;
			
			tmp = tmp -> next;
		
		}
	}
	
	tmp = ready -> head;
	
	if (ready -> size !=0){
		
		while (tmp != NULL){
			
			Estado[(tmp -> elem -> id) - 1] = tmp -> elem -> estado;
			
			tmp = tmp -> next;
		
		}
	}
	
	tmp = running -> head;
	
	if (running -> size !=0){
		
		while (tmp != NULL){
			
			Estado[(tmp -> elem -> id) - 1] = tmp -> elem -> estado;
			
			tmp = tmp -> next;
		
		}
	}	
	
	tmp = Exit -> head;
	
	if (Exit -> size !=0){
		
		while (tmp != NULL){
			
			Estado[(tmp -> elem -> id) - 1] = tmp -> elem -> estado;
			
			tmp = tmp -> next;
		
		}
	}
	
	tmp = blocked -> head;
	
	if (blocked -> size !=0){
		
		while (tmp != NULL){
			
			Estado[(tmp -> elem -> id) - 1] = tmp -> elem -> estado;
			
			tmp = tmp -> next;
		
		}
	}
	Scheduler(Estado);	
}



int main(){
	
	new = list_new(6);
	ready = list_new(6);
	running = list_new(1);		//cria as Queue's
	blocked = list_new(6);
	Exit = list_new(6);
	
	pthread_create(&thread_id, NULL, &Read_file, NULL);
	
	while (tempo < 100){
		
		
		Admit();
		Dispach();
		run();
		Dispach();
		blocked_counter_increment();
		output();
		sleep(1);
		tempo++;
		
	}

		
	return 0;
	
	}



