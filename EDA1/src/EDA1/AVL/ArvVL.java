package EDA1.AVL;

import java.util.Iterator;

public class ArvVL<T extends Comparable<? super T>> implements Iterable<T>, AVL<T> {

    private AVLNode<T> root;
    private int size;

    public ArvVL(T x) {
        root = new AVLNode<>(x);
        size = 1;
    }

    public ArvVL(AVLNode<T> x) {
        root = x;
        size = 0;
    }

    public ArvVL() {
        root = null;
        size = 0;
    }

    public ArvVL(T x, AVLNode<T> left, AVLNode<T> right) {
        root = new AVLNode<>(x, left, right);
        size = 3;
    }

    @Override
    public boolean isEmpty() {
        return root == null;
    }

    @Override
    public boolean contains(T x) {
        return contains(x, root);
    }

    private boolean contains(T x, AVLNode<T> n) {
        if (n == null)
            return false;
        if (n.element.compareTo(x) == 0)
            return true;

        if (x.compareTo(n.element) < 0)    // if(x < root.element)
            return contains(x, n.left);
        else                               // if(x > root.element)
            return contains(x, n.right);

    }

    @Override
    public T findMin() {
        return findMin(root).element;
    }

    private AVLNode<T> findMin(AVLNode<T> n) {
        AVLNode<T> current = n;
        while (current.left != null) {
            current = current.left;
        }
        return current;
    }

    @Override
    public T findMax() {
        return findMax(root).element;
    }

    private AVLNode<T> findMax(AVLNode<T> n) {
        AVLNode<T> current = n;
        while (current.right != null) {
            current = current.right;
        }
        return current;
    }


    @Override
    public void insert(T x) {
        //System.out.println("Inserting " + x);
        root = insert(x, root);
        size++;
    }

    private AVLNode<T> insert(T x, AVLNode<T> n) {
        if (n == null)
            return new AVLNode<>(x);

        if (x.compareTo(n.element) < 0)     // if(x < n.element)
            n.left = insert(x, n.left);
        else if (x.compareTo(n.element) > 0)// if(x > n.element)
            n.right = insert(x, n.right);
        else
            return n;

        n.height = 1 + Math.max(height(n.left), height(n.right));

        int balance = getBalance(n);

        //UNBALANCED PATH: LEFT, LEFT
        if (balance > 1 && x.compareTo(n.left.element) < 0)
            return simpleRightRotation(n);

        //UNBALANCED PATH: RIGHT, RIGHT
        if (balance < -1 && x.compareTo(n.right.element) > 0)
            return simpleLeftRotation(n);

        //UNBALANCED PATH: LEFT, RIGHT
        if (balance > 1 && x.compareTo(n.left.element) > 0)
            return leftRightRotation(n);

        //UNBALANCED PATH: RIGHT, LEFT
        if (balance < -1 && x.compareTo(n.right.element) < 0)
            return rightLeftRotation(n);

        return n;
    }


    @Override
    public void remove(T x) {
        if (!isEmpty()) {
            if (contains(x)) {
                size--;
                root = remove(x, root);
            }
        }
    }

    private AVLNode<T> remove(T x, AVLNode<T> n) {

        if (n == null)
            return n;

        if (x.compareTo(n.element) < 0) {
            n.left = remove(x, n.left);
        } else if (x.compareTo(n.element) > 0) {
            n.right = remove(x, n.right);
        } else {
            //Node with one or no child
            if (n.left == null || n.right == null) {
                AVLNode<T> temp = null;
                if (temp == n.left)
                    temp = n.right;
                else
                    temp = n.left;

                //No child case
                if (temp == null) {
                    temp = n;
                    n = null;
                } else //One child case
                    n = temp;
            } else {
                //Node with two children
                //find the smallest node in the right subtree
                AVLNode<T> temp = findMin(n.right);

                n.element = temp.element;

                n.right = remove(temp.element, n.right);
            }
        }

        if (n == null)
            return n;

        n.height = Math.max(height(n.left), height(n.right)) + 1;

        int balance = getBalance(n);

        //UNBALANCED PATH: LEFT, LEFT
        if (balance > 1 && getBalance(n.left) >= 0)
            return simpleRightRotation(n);

        //UNBALANCED PATH: LEFT, RIGHT
        if (balance > 1 && getBalance(n.left) < 0) {
            return leftRightRotation(n);
        }

        //UNBALANCED PATH: RIGHT, RIGHT
        if (balance < -1 && getBalance(n.right) <= 0)
            return simpleRightRotation(n);

        //UNBALANCED PATH: RIGHT, LEFT
        if (balance < -1 && getBalance(n.right) > 0) {
            return rightLeftRotation(n);
        }

        return n;
    }

    @Override
    public void printInOrder() {
        printInOrder(root);
    }

    private void printInOrder(AVLNode<T> n) {
        if (n == null)
            return;

        printInOrder(n.left);

        System.out.print(n.element + "  ");

        printInOrder(n.right);
    }

    @Override
    public void printPostOrder() {
        printPostOrder(root);
    }

    private void printPostOrder(AVLNode<T> n) {
        if (n == null)
            return;

        printPostOrder(n.left);

        printPostOrder(n.right);

        System.out.print(n.element + " ");
    }

    @Override
    public void printPreOrder() {
        printPreOrder(root);
    }

    private void printPreOrder(AVLNode<T> n) {
        if (n == null)
            return;

        System.out.print(n.element + " ");

        printPreOrder(n.left);

        printPreOrder(n.right);
    }

    @Override
    public Iterator<T> iterator() {
        return new AVLIteratorPostOrder<>(root, size);
    }


    private AVLNode<T> simpleRightRotation(AVLNode<T> n0) {
        //System.out.println("Rotacao dir");
        AVLNode<T> n1 = n0.left;
        n0.left = n1.right;
        n1.right = n0;

        n0.height = Math.max(height(n0.left), height(n0.right)) + 1;
        n1.height = Math.max(height(n1.right), height(n1.left)) + 1;

        return n1;
    }

    private AVLNode<T> simpleLeftRotation(AVLNode<T> n0) {
        //System.out.println("Rotacao esq");
        AVLNode<T> n1 = n0.right;
        n0.right = n1.left;
        n1.left = n0;

        n0.height = Math.max(height(n0.left), height(n0.right)) + 1;
        n1.height = Math.max(height(n1.right), height(n1.left)) + 1;

        return n1;
    }

    private AVLNode<T> rightLeftRotation(AVLNode<T> n0) {
        //System.out.println("Rotaçao dupla dir esq");
        AVLNode<T> n1 = n0.right;
        n0.right = simpleRightRotation(n1);

        n0.height = Math.max(height(n0.left), height(n0.right)) + 1;
        n1.height = Math.max(height(n1.right), height(n1.left)) + 1;

        return simpleLeftRotation(n0);
    }

    private AVLNode<T> leftRightRotation(AVLNode<T> n0) {
        //System.out.println("Rotaçao dupla esq dir");
        AVLNode<T> n1 = n0.left;
        n0.left = simpleLeftRotation(n1);

        n0.height = Math.max(height(n0.left), height(n0.right)) + 1;
        n1.height = Math.max(height(n1.right), height(n1.left)) + 1;

        return simpleRightRotation(n0);
    }

    private int height(AVLNode<T> n) {
        if (n == null)
            return 0;

        return n.height;
    }

    private int getBalance(AVLNode<T> n) {
        if (n == null)
            return 0;

        return height(n.left) - height(n.right);
    }
}

