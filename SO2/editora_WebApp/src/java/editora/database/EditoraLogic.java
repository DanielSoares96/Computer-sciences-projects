package editora.database;

import editora.beans.Artigo;
import editora.beans.Autor;
import java.time.Instant;
import java.util.ArrayList;

public interface EditoraLogic {

    public Artigo obtainArticleData(int id);

    public ArrayList obtainArticles(int c);

    public ArrayList obtainAllArticles();

    public boolean buyArticle(int id, int quantity, long referencia);

    public Autor bestSeller();

    public Artigo bestSellerArtigo();

    public void disconnect();

}
