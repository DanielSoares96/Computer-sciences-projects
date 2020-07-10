public class EscreveInt extends InstruSaida
{
	public String toString()
	{
		return "PRINT_INT";
	}

	public void executa(CIMS maq)
	{
		int t = maq.getAvalStack().pop();
		System.out.print(t);
		maq.incPC();
	}
}
