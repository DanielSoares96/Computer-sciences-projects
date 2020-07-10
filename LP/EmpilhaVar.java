public class EmpilhaVar extends InstruVar
{
	String distancia;
	String numero;

	public EmpilhaVar(String i, String j)
	{
		distancia = i;
		numero = j;
	}

	public String toString()
	{
		return "EMPILHA_VAR " + distancia + " " + numero;
	}

	public void executa(CIMS maq)
	{
		int p = Integer.parseInt(distancia);
		RegAti current = maq.aA;
		int i = 0;

		while(i<p)
		{
			current = current.controlLink;
			i++;
		}

		maq.avalStack.push(current.vars[Integer.parseInt(numero) - 1]);
		maq.incPC();
	}
}
