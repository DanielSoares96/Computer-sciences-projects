public class SaltoInst extends InstruSalto
{
	String etiqueta;

	public 	SaltoInst(String x)
	{
		etiqueta = x;
	}

	public String toString()
	{
		return "SALTA " + etiqueta;
	}

	public void executa(CIMS maq)
	{
		maq.setPC(etiqueta);
	}
}
