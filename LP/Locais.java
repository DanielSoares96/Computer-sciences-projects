public class Locais extends InstruFuncao
{
	String argumentos;
	String numero_variaveis;

	public Locais(String i, String j)
	{
		argumentos = i;
		numero_variaveis = j;
	}

	public String toString()
	{
		return "LOCAIS " + argumentos + " " + numero_variaveis;
	}

	public void executa(CIMS maq)
	{

		RegAti t1 = new RegAti();

		if(!maq.execStack.empty())
		{
			t1.controlLink = maq.execStack.peek();
		}
		else
		{
			t1.controlLink = null;
		}

		t1.args = new int[Integer.parseInt(argumentos)];
		t1.vars = new int[Integer.parseInt(numero_variaveis)];
		t1.returnAdress = maq.returnAdress;

		for(int i=0; i<maq.argTemp.size(); i++){
			t1.args[i]=maq.argTemp.get(i);
		}
		maq.argTemp.clear();

		maq.aA = t1;
		maq.execStack.push(t1);
		maq.incPC();
	}
}
