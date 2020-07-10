public class EmpilhaArg extends InstruArg
{
	String profundidade;
	String var;

	public EmpilhaArg(String i, String j)
	{
		profundidade = i;
		var = j;
	}

	public String toString()
	{
		return "EMPILHA_ARG " + profundidade + " " + var;
	}

	public void executa(CIMS maq)
	{
		int p = Integer.parseInt(profundidade);
		RegAti current = maq.aA;
		int i = 0;

		while(i<p)
		{
			current = current.controlLink;
			i++;
		}

		maq.avalStack.push(current.args[Integer.parseInt(var) - 1]);
		maq.incPC();
	}
}
