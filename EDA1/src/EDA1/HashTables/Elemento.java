package EDA1.HashTables;

public class Elemento<T> {

    T elemento;
    boolean ativo;

    public Elemento(T x){
        elemento = x;
        ativo = true;
    }

    public T getElemento(){
        return elemento;
    }

    public void setElemento(T x){
        elemento = x;
    }

    public boolean isAtivo(){
        return ativo;
    }

    public void remove(){
        ativo = false;
    }
}
