public class Div extends InstruAritmetica
{
	public String toString()
	{
		return "DIV";
	}

	public void executa(CIMS maq)
	{
		int t2 = maq.getAvalStack().pop();
		int t1 = maq.getAvalStack().pop();
		maq.getAvalStack().push(t1 / t2);
		maq.incPC();
	 }
}
