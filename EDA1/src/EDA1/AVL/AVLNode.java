package EDA1.AVL;

public class AVLNode<T> {
    T element;
    AVLNode<T> left;
    AVLNode<T> right;
    int height;

    public AVLNode(T e) {
        element = e;
        left = null;
        right = null;
        height = 1;
    }

    public AVLNode(T e, AVLNode<T> left, AVLNode<T> right) {
        element = e;
        this.left = left;
        this.right = right;
        height = 1;
    }

    public String toString() {
        return element.toString();
    }
}
