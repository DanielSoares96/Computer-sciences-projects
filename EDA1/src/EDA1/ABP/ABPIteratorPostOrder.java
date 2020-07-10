package EDA1.ABP;

import EDA1.Stack.*;

public class ABPIteratorPostOrder<T> implements java.util.Iterator<T> {
    ABPNode<T> node;
    Stack<ABPNode<T>> stack;

    public ABPIteratorPostOrder(ABPNode<T> node, int BSTSize){
        this.node = node;
        stack = new ArrayStack<>(BSTSize);
        populateStack(stack, this.node);
    }

    private void populateStack(Stack<ABPNode<T>> st, ABPNode<T> n){
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
