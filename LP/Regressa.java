public class Regressa extends InstruFuncao
{
	public String toString()
	{
		return "REGRESSA";
	}

	public void executa(CIMS maq)
	{
		RegAti t = maq.execStack.pop();

		if(!maq.execStack.empty())
		{
			maq.aA= maq.execStack.peek();
			maq.PC = t.returnAdress;
		}
	}
}
