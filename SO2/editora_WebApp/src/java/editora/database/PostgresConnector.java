package editora.database;

import editora.beans.Artigo;
import editora.beans.Autor;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class PostgresConnector implements EditoraLogic {

    Connection con = null;

    //cria uma conexão à BD
    public PostgresConnector(String host, String db, String user, String pw) {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace(System.out);
        }
        try {// url = "jdbc:postgresql://host:port/database",
            con = DriverManager.getConnection("jdbc:postgresql://"
                    + host + ":5432/" + db, user, pw);
        } catch (SQLException e) {
            e.printStackTrace(System.out);
        }
    }

    @Override
    public void disconnect() {
        if (con != null) {
            try {
                con.close();
            } catch (SQLException e) {
            }
        }
    }

    @Override
    public Artigo obtainArticleData(int id) {

        Artigo artigo = new Artigo();

        if (con != null) {
            try {
                Statement s = con.createStatement();
                try {
                    ResultSet rs = s.executeQuery("SELECT * FROM artigos INNER JOIN autor_artigos ON artigos.id = '" + id + "' AND autor_artigos.id = '" + id + "' INNER JOIN autor ON  autor.codigo = autor_artigos.codigo;");
                    try {
                        while (rs.next()) {
                            artigo.setId(rs.getInt("id"));
                            artigo.setSold(rs.getInt("vendidos"));
                            artigo.setStock(rs.getInt("stock"));
                            artigo.setTitle(rs.getString("titulo"));
                            artigo.setAutor(rs.getString("nome"));
                        }
                    } finally {
                        rs.close();
                    }
                } finally {
                    s.close();
                }
            } catch (SQLException e) {
                System.out.println("Não foi possivel obter dados do artigo " + e.getMessage());
            }
            return artigo;
        }
        return null;
    }

    @Override
    public ArrayList obtainArticles(int c) {
        ArrayList<Artigo> listarArtigos = new ArrayList<>();
        if (con != null) {
            try {
                Statement s = con.createStatement();
                try {
                    String query = ("SELECT * FROM artigos INNER JOIN autor_artigos ON artigos.id = autor_artigos.id INNER JOIN autor ON  autor.codigo = autor_artigos.codigo WHERE autor.codigo ='" + c + "';");
                    ResultSet rs = s.executeQuery(query);
                    try {
                        while (rs.next()) {
                            Artigo temp = new Artigo();
                            temp.setId(rs.getInt("id"));
                            temp.setSold(rs.getInt("vendidos"));
                            temp.setStock(rs.getInt("stock"));
                            temp.setTitle(rs.getString("titulo"));
                            temp.setAutor(rs.getString("nome"));
                            listarArtigos.add(temp);
                        }
                    } finally {
                        rs.close();
                    }
                } finally {
                    s.close();
                }
            } catch (SQLException e) {
                System.out.println("Não possivel obter informações:" + e.getMessage());
            }
            return listarArtigos;
        }
        return null;
    }

    public ArrayList obtainAllArticles() {
        ArrayList<Artigo> listarArtigos = new ArrayList<>();
        if (con != null) {
            try {
                Statement s = con.createStatement();
                try {
                    String query = ("SELECT * FROM artigos;");
                    ResultSet rs = s.executeQuery(query);
                    try {
                        while (rs.next()) {
                            Artigo temp = new Artigo();
                            temp.setId(rs.getInt("id"));
                            temp.setSold(rs.getInt("vendidos"));
                            temp.setStock(rs.getInt("stock"));
                            temp.setTitle(rs.getString("titulo"));
                            listarArtigos.add(temp);

                        }
                    } finally {
                        rs.close();
                    }
                } finally {
                    s.close();
                }
            } catch (SQLException e) {
                System.out.println("Não possivel obter informações:" + e.getMessage());
            }
            return listarArtigos;
        }
        return null;
    }

    public boolean buyArticle(int id, int quantity, long referencia) {
        if (con != null) {
            try {
                Statement s = con.createStatement();
                try {
                    String query = ("SELECT stock FROM artigos WHERE id='" + id + "';");
                    ResultSet rs = s.executeQuery(query);
                    try {
                        while (rs.next()) {
                            int stock = rs.getInt("stock");

                            if (stock < quantity) {
                                s.close();
                                return false;
                            } else {
                                query = ("INSERT INTO compra VALUES(DEFAULT," + id + "," + quantity + "," + referencia + ");");
                                s.executeUpdate(query);
                                query = ("UPDATE artigos SET stock = stock -'" + quantity + "', vendidos = vendidos +'" + quantity + "' WHERE artigos.id ='" + id + "';");
                                s.executeUpdate(query);
                                s.close();
                                return true;
                            }
                        }
                    } finally {
                        rs.close();
                    }
                } finally {
                    s.close();
                }
            } catch (SQLException e) {
                System.out.println("Não possivel obter informações:" + e.getMessage());
            }
            return true;

        }
        return false;
    }

    @Override
    public Autor bestSeller() {
        Autor autor = new Autor();
        if (con != null) {
            try {
                Statement s = con.createStatement();
                try {
                    String query = "SELECT codigo, nome, email, SUM(vendidos) FROM autor NATURAL JOIN artigos NATURAL JOIN autor_artigos GROUP BY codigo, nome, email;";
                    ResultSet rs = s.executeQuery(query);
                    int check = -1;
                    int vendidos;
                    try {
                        while (rs.next()) {
                            vendidos = rs.getInt("SUM");
                            if (vendidos > check) {
                                check = vendidos;
                                autor.setC(rs.getInt("codigo"));
                                autor.setName(rs.getString("name"));
                                autor.setEmail(rs.getString("email"));
                                autor.setSold(rs.getInt("SUM"));
                            }
                        }
                    } finally {
                        rs.close();
                    }
                } finally {
                    s.close();
                }
            } catch (SQLException e) {
                System.out.println("Não foi possivel obter as Reservas: " + e.getMessage());
            }
            return autor;
        }
        return null;
    }

    public Artigo bestSellerArtigo() {
        Artigo artigo = new Artigo();
        if (con != null) {
            try {
                Statement s = con.createStatement();
                try {
                    String query = "select * from artigos where vendidos = (select max(vendidos) from artigos);";
                    ResultSet rs = s.executeQuery(query);
                    int check = -1;
                    int vendidos;
                    try {
                        while (rs.next()) {
                            vendidos = rs.getInt("vendidos");
                            if (vendidos > check) {
                                check = vendidos;
                                artigo.setId(rs.getInt("id"));
                                artigo.setTitle(rs.getString("titulo"));

                            }
                        }
                    } finally {
                        rs.close();
                    }
                } finally {
                    s.close();
                }
            } catch (SQLException e) {
                System.out.println("Não foi possivel obter as Reservas: " + e.getMessage());
            }
            return artigo;
        }
        return null;
    }
}
