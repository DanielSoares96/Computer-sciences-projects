public class SaltoIgual extends InstruSalto
{
	String etiqueta;

	public 	SaltoIgual(String x)
	{
		etiqueta = x;
	}

	public String toString()
	{
		return "SIGUAL " + etiqueta;
	}

	public void executa(CIMS maq)
	{
		int t1 = maq.getAvalStack().pop();
		int t2 = maq.getAvalStack().pop();

		if(t1 == t2)
		{
			maq.setPC(etiqueta);
		}
		else
		{
			maq.incPC();
		}
	}
}
