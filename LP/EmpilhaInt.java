public class EmpilhaInt extends InstruSaida
{
	String val;

	public EmpilhaInt(String i)
	{
		val = i;
	}

	public String toString()
	{
		return "EMPILHA " + val;
	}

	public void executa(CIMS maq)
	{
		maq.getAvalStack().push(Integer.parseInt(val));
		maq.incPC();
	}
}
