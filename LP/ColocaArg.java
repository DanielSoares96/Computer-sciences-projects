import java.util.ArrayList;

public class ColocaArg extends InstruFuncao
{
	String var;

	public ColocaArg(String i)
	{
		var = i;
	}

	public String toString()
	{
		return "COLOCA_ARG " + var;
	}
	
	public void executa(CIMS maq)
	{
		int t1 = maq.getAvalStack().pop();
		maq.argTemp.add(t1);
		maq.incPC();
	}
}
