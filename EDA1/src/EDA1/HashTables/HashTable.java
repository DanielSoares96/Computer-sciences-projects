package EDA1.HashTables;

public abstract class HashTable<T> {

    Elemento<T>[] arr;
    private int nElementos;

    public HashTable() {
        alocarTabela(23);
        nElementos = 0;
    }

    public HashTable(int n) {
        alocarTabela(n);
        nElementos = 0;
    }


    public int ocupados() {
        return nElementos;
    }

    private float fatorCarga() {
        return ((float) nElementos / (float) arr.length);
    }

    protected abstract int procPos(T s);    //retornará a posição em que s será inserido ou se s existe a sua localização na tabela

    private void alocarTabela(int dim) {     //uma nova tabela de dimensão especificada
        arr = (Elemento<T>[]) new Elemento[dim];
        nElementos = 0;
    }

    private void tornarVazia(){              //esvazia a tabela em uso;
        alocarTabela(arr.length);
    }

    public T procurar(T x) {                //retorna o elemento que esta na tabela , se x não está lá ou está inativo retorna null
        int index = procPos(x);
        if(arr[index] == null)
            return null;
        else if (arr[index].getElemento().equals(x) && arr[index].isAtivo())
            return x;
        else
            return null;
    }

    public void remove(T x) {
        if(procurar(x) != null) {
            //System.out.println("DELETED: " + arr[procPos(x)].getElemento());
            arr[procPos(x)].remove();
            nElementos--;
        }
    }

    public void insere(T x) {
        //System.out.println("TO INSERT: " + x.toString());
        if(procurar(x) != null) {
            //System.out.println("\t" + x.toString() + " ALREADY IN HASHTABLE");
            return;
        }
        int index = procPos(x);
        arr[index] = new Elemento<>(x);
        nElementos++;
        //System.out.println("\tINSERTED: " + x.toString() + " IN INDEX " + index + "\n\t\tFactor Carga = " + fatorCarga());
        if(fatorCarga() >= 0.5){
            //System.out.println("\t\tREHASING!");
            rehash();
            //System.out.println("\t\tREHASING DONE!");
        }
    }

    private void rehash() {
        int dim = getPrime(arr.length * 2);
        Elemento<T>[] arrTemp1 = arr.clone();
        int c = 0;
        alocarTabela(dim);
        while(c < arrTemp1.length){
            if(arrTemp1[c] != null && arrTemp1[c].isAtivo()) {
                insere(arrTemp1[c].getElemento());
            }
            c++;
        }

    }

    public void print() {
        System.out.println("Index -> Object: Status");
        for(int i = 0; i < arr.length; i++){
            if(arr[i] != null)
                System.out.printf("%d -> %s: %s\n", i, arr[i].getElemento(), arr[i].isAtivo() ? "Active" : "Inactive");
            else
                System.out.printf("%d -> %s: %s\n", i, arr[i], "Inactive");
        }
    }

    private int getPrime(int min){
        while(true){
            int c = 0;
            for(int i = 1; i <= min; i++){
                if(c > 2)
                    break;
                if(min % i == 0){
                    c++;
                }
            }
            if(c == 2)
                return min;
            min++;
        }
    }
}
