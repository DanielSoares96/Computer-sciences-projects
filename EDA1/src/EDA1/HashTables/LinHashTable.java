package EDA1.HashTables;

public class LinHashTable<T> extends HashTable<T> {

    public LinHashTable() {
        super();
    }

    public LinHashTable(int n) {
        super(n);
    }

    protected int procPos(T s){
        int i = 0;
        int indexToInsert = 0;
        int index = Math.abs(s.hashCode()) % arr.length;

        if(arr[(index + i) % arr.length] == null) {
            return (index + i) % arr.length;
        }

        while(arr[(index + i) % arr.length] != null) {
            if (arr[(index + i) % arr.length].isAtivo()) {
                if (arr[(index + i) % arr.length].getElemento().equals(s))
                    return (index + i) % arr.length;
            } else {
                indexToInsert = (index + i) % arr.length;
                break;
            }
            i++;
        }

        if(indexToInsert == 0) //means while loop did nothing
            return (index + i) % arr.length;

        return indexToInsert;
    }
}