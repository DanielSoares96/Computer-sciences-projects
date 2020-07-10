#include <string.h>
#include "user.h"

/* Pesquisa Binaria no Array ordenado
 * Recebe um nick, o array dos seguidos e a ocupação do array
 * Devolve a posição em que o nick esta, -1 se não for encontrado
 */
int BinarySearch(char *nick, int size, struct following array[])
{	
	short esq = 0;
	short meio;
	short dir = size-1;
	
	while(esq <= dir)
	{
		meio = (esq + dir) / 2;
		if(strcmp(nick, array[meio].nick) < 0)
			dir = meio - 1;
		else if (strcmp(nick, array[meio].nick) > 0)
			esq = meio + 1;
		else
			return meio;
	}
	
	return -1;
}

/* Adicionar um user seguido ordenadamente no Array
 * Recebe um seguido, o Array de seguidos e o tamanho desse array
 * Não devolve nenhum valor
 */
void addArraySorted(struct following newfollow, int size, struct following array[])
{
	short i;
	//Percorre a lista a partir do fim, se nick na posição i for maior do que o nick dado
	//move i para i+1
	for (i = size-1; ( i >= 0  && strcmp(array[i].nick,newfollow.nick) > 0); i--)
       array[i+1] = array[i];
	
	//Coloca o user seguido no esapaço criado
    array[i+1] = newfollow;
}

/* Remove um user seguido do Array 
 * Recebe um seguido, o Array de seguidos e o tamanho desse array
 * Devolve true se for removido, false se user não for encontrado
 */
bool removeArraySorted(char *nick, int size, struct following array[])
{
	short pos = BinarySearch(nick, size, array);
	if(pos == -1)
		return false;
	 
	for(int i=pos; i < size -1; i++)
	{
		array[i] = array[i + 1];
	}
	
	return true;
}
