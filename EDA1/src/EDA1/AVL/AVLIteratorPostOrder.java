package EDA1.AVL;

import EDA1.Stack.*;

public class AVLIteratorPostOrder<T> implements java.util.Iterator<T> {
    AVLNode<T> node;
    Stack<AVLNode<T>> stack;

    public AVLIteratorPostOrder(AVLNode<T> node, int BSTSize){
        this.node = node;
        stack = new ArrayStack<>(BSTSize);
        populateStack(stack, this.node);
    }

    private void populateStack(Stack<AVLNode<T>> st, AVLNode<T> n){
        if(n == null)
            return;
        populateStack(st,n.right);
        st.push(n);
        populateStack(st,n.left);
    }

    public boolean hasNext(){
        return !stack.empty();
    }

    public T next() {
        return stack.pop().element;
    }

}
