public class Mult extends InstruAritmetica
{
	public String toString()
	{
		return "MULT";
	}
	
	public void executa(CIMS maq)
	{
		int t1 = maq.getAvalStack().pop();
		int t2 = maq.getAvalStack().pop();
		maq.getAvalStack().push(t1 * t2);
		maq.incPC();
	 }
}
