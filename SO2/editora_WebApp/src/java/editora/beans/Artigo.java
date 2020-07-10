/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package editora.beans;

/**
 *
 * @author fox
 */
public class Artigo {

    int id;
    String title;
    int stock;
    int sold;
    String autor;

    public Artigo(int id, String title, int sold) {
        this.id = id;
        this.title = title;
        this.sold = sold;

    }

    public Artigo(int id, String title, int sold, String autor) {
        this.id = id;
        this.title = title;
        this.sold = sold;
        this.autor = autor;

    }

    public Artigo() {
        id = 0;
        title = null;
        sold = 0;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getSold() {
        return sold;
    }

    public void setSold(int sold) {
        this.sold = sold;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public String getAutor() {
        return autor;
    }

    public void setAutor(String autor) {
        if (this.autor != null) {
            this.autor = this.autor + ", " + autor;
        } else {
            this.autor = autor;
        }
    }

    public String toString() {
        return "id:" + id + "\nTítulo:" + title + "\nVendidos:" + sold + "\nStock: " + stock + "\n+++++++++++++++\n";
    }
}
