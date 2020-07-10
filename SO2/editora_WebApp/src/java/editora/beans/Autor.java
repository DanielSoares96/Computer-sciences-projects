/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package editora.beans;

/**
 *
 * @author soares
 */
public class Autor {

    int c;
    String name;
    String email;
    int sold;

    public Autor(int c, String name, String email, int sold) {
        this.c = c;
        this.name = name;
        this.email = email;
        this.sold = sold;
    }

    public Autor() {
        this.c = 0;
        this.name = null;
        this.email = null;
        this.sold = 0;
    }

    public int getC() {

        return c;
    }

    public void setC(int c) {

        this.c = c;
    }

    public String getName() {

        return name;
    }

    public void setName(String name) {

        this.name = name;
    }

    public String getEmail() {

        return email;
    }

    public void setEmail(String email) {

        this.email = email;
    }

    public int getSold() {

        return sold;
    }

    public void setSold(int sold) {

        this.sold = sold;
    }

    public String toString() {

        return "Códgio:" + c + "\nNome:" + name + "email:" + email + "\n+++++++++++++++\n";
    }

    public String toStringVendidos() {

        return "Códgio:" + c + "\nNome:" + name + "\nemail:" + email + "\nVendidos" + "\n+++++++++++++++\n";
    }

}
