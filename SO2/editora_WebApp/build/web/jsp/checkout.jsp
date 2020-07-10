<%@page import="editora.beans.Compra"%>
<%@page import="editora.beans.Artigo"%>
<%@page import="java.util.Iterator"%>
<%@page language="java" contentType="text/html"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Date"%>

<jsp:useBean id="dataManager" scope="application" class="editora.database.DataManager"/>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <title>Check Out-Editora</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css" integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4" crossorigin="anonymous">
    </head>
    <body style="background-color: rgb(0, 17, 28)">
        <jsp:include page="menu.jsp" flush="true"/>
        <%
            String base = (String) application.getAttribute("base");
        %>

        <div style="text-align: center; color:white;" class="content">
            <h2>CheckOut</h2>

            <%
                boolean flag = false;
                HashMap carrinho = (HashMap) session.getAttribute("carrinho");
                long referencia = System.currentTimeMillis();
                if (carrinho != null && !carrinho.isEmpty()) {
                    Iterator it = carrinho.entrySet().iterator();
                    while (it.hasNext()) {
                        Map.Entry pair = (Map.Entry) it.next();
                        Compra c = (Compra) pair.getValue();
                        if (!dataManager.buyArticle(c.getArtigo().getId(), c.getQuantidade(), referencia)) {
                            flag = false;
                            break;
                        }
                        flag = true;
                        it.remove(); // avoids a ConcurrentModificationException
                    }

                    if (flag) {
            %><p> Compra efectuada</p>
            <p>A sua referência <%= referencia%></p><%
                }

            } else {
            %><p class="error">Não pode fazer checkout sem comprar algum artigo!</p><%
            }
            %>
        </div>
        <button class="btn btn-primary btn-block"style="position: fixed; left: 0; bottom: 0; width: 100%; background-color: #e7e7e7; color: black; text-align: center; border-color: #e7e7e7;" onclick="window.location.href = '/editora_WebApp/'">Página Inicial</a></button>
</body>
</html>
