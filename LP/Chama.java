import java.util.ArrayList;

public class Chama extends InstruFuncao
{
	String etiqueta;
	String profundidade;

	public Chama(String i, String j)
	{
		profundidade = i;
		etiqueta = j;
	}

	public String toString()
	{
		return "CHAMA " + profundidade + " " + etiqueta;
	}

	public void executa(CIMS maq)
	{
		maq.returnAdress = maq.PC + 1;
		maq.setPC(etiqueta);
	}
}
