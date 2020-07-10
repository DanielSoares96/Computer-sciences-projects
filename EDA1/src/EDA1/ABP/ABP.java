package EDA1.ABP;

public interface ABP<T extends Comparable<? super T>>{     // Interface Binary Search Tree
    public boolean isEmpty();
    public boolean contains(T x);
    public T findMin();
    public T findMax();
    public void insert(T x);
    public void remove(T x);
    public void printInOrder();
    public void printPostOrder();
    public void printPreOrder();
}
