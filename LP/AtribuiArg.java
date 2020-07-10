public class AtribuiArg extends InstruArg
{
	String profundidade;
	String var;

	public AtribuiArg(String i, String j)
	{
		profundidade = i;
		var = j;
	}

	public String toString()
	{
		return "ATRIBUI_ARG " + profundidade + " " + var;
	}

	public void executa(CIMS maq)
	{

		int p = Integer.parseInt(profundidade);
		int t1 = maq.getAvalStack().pop();
		RegAti current = maq.aA;
		
		int i = 0;
		while(i<p){
			current = current.controlLink;
			i++;
		}

		current.args[Integer.parseInt(var) - 1] = t1;
		maq.incPC();
	}
}
