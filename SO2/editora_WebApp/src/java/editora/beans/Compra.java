/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package editora.beans;

import java.util.ArrayList;

/**
 *
 * @author fox
 */
public class Compra {

    Artigo artigo;
    int quantidade;

    public Compra(Artigo artigo, int quantidade) {
        this.artigo = artigo;
        this.quantidade = quantidade;
    }

    public Artigo getArtigo() {
        return artigo;
    }

    public void setArtigo(Artigo artigo) {
        this.artigo = artigo;
    }

    public Integer getQuantidade() {
        return quantidade;
    }

    public void setQuantidade(int quantidade) {
        this.quantidade = quantidade;
    }
}
