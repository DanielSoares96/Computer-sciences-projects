public class Sub extends InstruAritmetica
{
	public String toString()
	{
		return "SUB";
	}

	public void executa(CIMS maq)
	{
		int t1 = maq.getAvalStack().pop();
		int t2 = maq.getAvalStack().pop();
		maq.getAvalStack().push(t2 - t1);
		maq.incPC();
	 }
}
