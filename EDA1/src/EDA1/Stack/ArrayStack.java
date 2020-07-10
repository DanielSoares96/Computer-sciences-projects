package EDA1.Stack;

public class ArrayStack<T> implements Stack<T> {

    private T[] values;
    private int topIndex = 0;
    private int maxSize;

    public ArrayStack(){
        values = (T[]) new Object[20];
        maxSize = 20;
    }

    public ArrayStack(int n){
        values = (T[]) new Object[n];
        maxSize = n;
    }

    @Override
    public T top() {
        if(topIndex > 0){
            return values[topIndex - 1];
        }else{
            return null;
        }
    }

    @Override
    public T pop() {
        if(topIndex > 0){
            T obj = values[topIndex - 1];
            values[topIndex - 1] = (T) new Object();
            topIndex--;
            return obj;
        }else{
            System.out.println("Pop Unsucessful >> Array is Empty!");
            return null;
        }
    }

    @Override
    public void push(T element) {
        if(topIndex < maxSize){
            values[topIndex] = element;
            topIndex++;
        }else{
            System.out.println("Push Unsucessful >> Array is full!");
        }
    }

    @Override
    public boolean empty() {
        return topIndex == 0;
    }

    @Override
    public int size() {
        return topIndex;
    }
}
