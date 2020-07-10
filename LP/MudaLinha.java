public class MudaLinha extends InstruSaida
{
	public String toString()
	{
		return "MUDA_LINHA";
	}
	
	public void executa(CIMS maq)
	{
		System.out.println();
		maq.incPC();
	}
}
