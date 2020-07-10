
<%@page import="java.util.HashMap"%>
<%@page import="editora.beans.Compra"%>
<%@page import="java.util.ArrayList"%>
<%@page import="editora.beans.Artigo"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:useBean id="dataManager" scope="application" class="editora.database.DataManager"/>
<!DOCTYPE html>
<%
    String base = (String) application.getAttribute("base");
    String imageURL = (String) application.getAttribute("imageURL");
    HashMap<String, Compra> carrinho = (HashMap) session.getAttribute("carrinho");
    if (carrinho == null) {
        carrinho = new HashMap<String, Compra>(10);
    }

    String action = request.getParameter("action");
    if (action != null && action.equals("addItem")) {
        try {
            String bookId = request.getParameter("bookId");
            Artigo book = dataManager.obtainArticleData(Integer.parseInt(bookId));
            if (book != null) {
                Compra item = new Compra(book, 1);
                carrinho.remove(bookId);
                carrinho.put(bookId, item);
                session.setAttribute("carrinho", carrinho);
            }
        } catch (Exception e) {
            System.err.println("Erro a adicionar o livro ao carrinho " + e.getMessage());
            out.println("Erro a adicionar o livro ao carrinho ");
        }
    }
    if (action != null && action.equals("updateItem")) {
        try {
            String bookId = request.getParameter("bookId");
            String quantity = request.getParameter("quantity");
            Compra item = (Compra) carrinho.get(bookId);
            if (item != null) {
                item.setQuantidade(Integer.parseInt(quantity));
            }
        } catch (Exception e) {
            out.println("Error updating shopping cart!");
        }
    }
    if (action != null && action.equals("deleteItem")) {
        try {
            String bookId = request.getParameter("bookId");
            carrinho.remove(bookId);
        } catch (Exception e) {
            out.println("Error deleting the selected item from the shopping cart!");
        }
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css" integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4" crossorigin="anonymous">
        <title>Carrinho-Editora </title>
    </head>
    <body>
        <div class="container">
            <jsp:include page="menu.jsp" flush="true"/>
            <table class="table">
                <thead>
                    <tr>
                        <th scope="col">Artigo</th>
                        <th scope="col">Autor</th>
                        <th scope="col">Quantidade</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <%
                            for (Compra item : carrinho.values()) {

                        %>
                        <td><%=item.getArtigo().getTitle()%></td>
                        <td><%=item.getArtigo().getAutor()%></td>
                        <td>
                            <form>
                                <input type="hidden" name="action" value="updateItem"/>
                                <input type="hidden" name="bookId"
                                       value="<%=item.getArtigo().getId()%>"/>

                                <select name="quantity">
                                    <% for (int i = 0; i <= item.getArtigo().getStock(); i++) {%>
                                    <option value="<%= i%>" <% if (i == item.getQuantidade()) {%> selected="<%= i%>" <%}%> >  <%=i%></option>
                                    <% }%>
                                </select> 
                                <input type="submit" value="Update"/>
                            </form>
                        </td>
                        <td>
                            <form>
                                <input type="hidden" name="action" value="deleteItem"/>
                                <input type="hidden" name="bookId" 
                                       value="<%=item.getArtigo().getId()%>"/>
                                <input type="submit" value="Delete"/>
                            </form>
                        </td>
                    </tr>

                    <% }
                    %>
                    <tr>
                        <td colspan="6" class="center"><a class="link1"
                                                          href="<%=base%>?action=checkout">Check Out</a></td>
                    </tr>
                </tbody>
            </table>

        </div><button class="btn btn-primary btn-block"style="position: fixed; left: 0; bottom: 0; width: 100%; background-color: #e7e7e7; color: black; text-align: center; border-color: #e7e7e7;" onclick="window.location.href = '/editora_WebApp/'">Página Inicial</a></button>
</body>
</html>
