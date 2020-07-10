import java.util.LinkedList;
import java.util.ArrayList;
import java.util.Stack;
import java.util.Hashtable;

// Conjunto de Instrucoes Maquina Simples
public class CIMS
{
	ArrayList<Instrucao> cims;
	Stack<Integer> avalStack;
	Hashtable<String,Integer> posicoes;
	Stack<RegAti> execStack;
	RegAti aA;
	int PC;
	ArrayList<Integer> argTemp;
	int returnAdress;



	public CIMS()
	{
		cims = new ArrayList<Instrucao>();
		posicoes = new Hashtable<String,Integer>();
		avalStack = new Stack<Integer>();
		execStack = new Stack<RegAti>();
		argTemp = new ArrayList<Integer>();
	}

	public ArrayList<Instrucao> getMem()
	{
		return cims;
	}

	/** Executa o programa CIMS carregado na maquina. */
	public void executa()
	{
		this.setPC("main");
		this.returnAdress = PC + 1;
		while(true)
		{
			cims.get(PC).executa(this);
			if(execStack.empty())
			{
				break;
			}
		}
	}

	public String toString()
	{
		String result="";

		for(int i=0; i<cims.size(); i++){
			result += (cims.get(i).toString() + "\n");
		}
		return result;
	}

	public Stack<Integer> getAvalStack()
	{
		return avalStack;
	}

	public void incPC()
	{
		PC +=1;
	}

	public void setPC(String etiqueta)
	{
		PC = posicoes.get(etiqueta);
	}
}
