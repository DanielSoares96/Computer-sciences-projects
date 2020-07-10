package EDA1.Queue;

public class ArrayQueue<T> implements Queue<T> {
    private int maxSize;
    private T[] array;
    private int first = 0;
    private int last = 0;

    public ArrayQueue(){
        array = (T[]) new Object[20];
        maxSize = 20 + 1;
    }

    public ArrayQueue(int n){
        array = (T[]) new Object[n];
        maxSize = n + 1;
    }

    public void enqueue(T x) throws OverflowException{
        if(size() == maxSize - 1){
            throw new OverflowException();
        }
        array[last] = x;
        last = inc(last);
    }

    public T dequeue() throws EmptyException{
        if(empty()){
            throw new EmptyException();
        }
        T x = array[first];
        array[first] = null;
        first = inc(first);
        return x;
    }

    private int inc(int i){
        return (i + 1) % maxSize;
    }

    public int size(){
        return (maxSize - first + last) % maxSize;
    }

    public boolean empty(){
        return first == last;
    }

    public T front(){
        return array[first];
    }
}
