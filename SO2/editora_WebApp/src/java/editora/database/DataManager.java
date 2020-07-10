package editora.database;

import editora.beans.Artigo;
import editora.beans.Autor;
import java.time.Instant;
import java.util.ArrayList;
import java.util.LinkedList;

public class DataManager implements EditoraLogic {

    private static EditoraLogic dbManager;

    public DataManager() {

        //Obtem dados do ficheiro de configurações
        GetPropertyValues prop = new GetPropertyValues();
        String h = prop.getProperties("host");
        String b = prop.getProperties("bd");
        String u = prop.getProperties("user");
        String p = prop.getProperties("pw");

        dbManager = new PostgresConnector(h, b, u, p);
    }

    @Override
    public Artigo obtainArticleData(int id) {
        return dbManager.obtainArticleData(id);
    }

    @Override
    public ArrayList<Artigo> obtainArticles(int id) {
        return dbManager.obtainArticles(id);
    }

    public ArrayList<Artigo> obtainAllArticles() {
        return dbManager.obtainAllArticles();
    }

    @Override
    public boolean buyArticle(int id, int quantity, long referencia) {
        return dbManager.buyArticle(id, quantity, referencia);
    }

    @Override
    public Autor bestSeller() {
        return dbManager.bestSeller();
    }

    public Artigo bestSellerArtigo() {
        return dbManager.bestSellerArtigo();
    }

    @Override
    public void disconnect() {
        dbManager.disconnect();
    }

}
