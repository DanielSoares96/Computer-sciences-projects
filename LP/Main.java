// Programa principal para a implementacao da maquina abstracta CIMS.

public class Main {
  public static void main(String args[])
  throws Exception
  {
    parser aParser = new parser();
    CIMS maquina;

    // carrega o programa CIMS
    maquina = (CIMS) aParser.parse().value;

    // e executa-o
    if (maquina != null)
    //System.out.println(maquina.toString());
    maquina.executa();
  }
}
