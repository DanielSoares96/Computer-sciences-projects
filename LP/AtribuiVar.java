public class AtribuiVar extends InstruVar
{
	String profundidade;
	String var;

	public AtribuiVar(String i, String j)
	{
		profundidade = i;
		var = j;
	}

	public String toString()
	{
		return "ATRIBUI_VAR " + profundidade + " " + var;
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

		current.vars[Integer.parseInt(var) - 1] = t1;
		maq.incPC();
	}
}
