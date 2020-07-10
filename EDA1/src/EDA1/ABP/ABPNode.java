package EDA1.ABP;

public class ABPNode<T> {  //Binary Search Tree Node

    T element;
    ABPNode<T> left;
    ABPNode<T> right;

    public ABPNode(T e) {
        element = e;
        left = null;
        right = null;
    }

    public ABPNode(T e, ABPNode<T> left, ABPNode<T> right) {
        element = e;
        this.left = left;
        this.right = right;
    }

    public String toString() {
        return element.toString();
    }

    public T getElement(){
        return element;
    }

    public ABPNode<T> getLeft() {
        return left;
    }

    public ABPNode<T> getRight() {
        return right;
    }

    public void setElement(T element) {
        this.element = element;
    }

    public void setLeft(ABPNode<T> left) {
        this.left = left;
    }

    public void setRight(ABPNode<T> right) {
        this.right = right;
    }
}
