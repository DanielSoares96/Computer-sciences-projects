public class SaltoMenor extends InstruSalto
{
	String etiqueta;

	public 	SaltoMenor(String x)
	{
		etiqueta = x;
	}

	public String toString()
	{
		return "SMENOR " + etiqueta;
	}

	public void executa(CIMS maq)
	{
		int t1 = maq.getAvalStack().pop();
		int t2 = maq.getAvalStack().pop();
		
		if(t2 < t1)
		{
			maq.setPC(etiqueta);
		}
		else
		{
			maq.incPC();
		}
	}
}
