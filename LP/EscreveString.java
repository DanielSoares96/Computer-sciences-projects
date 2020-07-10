public class EscreveString extends InstruSaida
{
	String text;

	public EscreveString(String s)
	{
		text = s;
	}

	public String toString()
	{
		return "PRINT_STRING " + text;
	}

	public void executa(CIMS maq)
	{
		System.out.print(text);
		maq.incPC();
	}
}
