package EDA1.Stack;

public interface Stack<T> {
    public T top();
    public T pop();
    public void push(T element);
    public boolean empty();
    public int size();
}
