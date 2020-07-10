
<%@page import="editora.beans.Artigo"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:useBean id="dataManager" scope="application" class="editora.database.DataManager"/>
<!DOCTYPE html>
<% String bookId = request.getParameter("bookId");
    Artigo book = dataManager.obtainArticleData(Integer.parseInt(bookId));
    String base = (String) application.getAttribute("base");
    String imageURL = (String) application.getAttribute("imageURL");
%>
<html>
    <head style="color:white">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css" integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4" crossorigin="anonymous">
        <title>Detalhes do Artigo</title>
    </head>
    <body style="background-color: rgb(0, 17, 28); color:white;">
        <div class="container">
            <jsp:include page="menu.jsp" flush="true"/>

            <img src="images/imagem<%=book.getId()%>.jpg" style="width:200px;height:200px;float: left;">
            <h5 style="text-indent: 14px;"> Artigo: <%= book.getTitle()%></h5>
            <h5 style="text-indent: 14px;"> Autor: <%= book.getAutor()%></h5>
            <h5 style="text-indent: 14px;"> Stock: <%= book.getStock()%></h5>
            <a class="" href="<%=base%>?action=addItem&bookId=<%=book.getId()%>">
                Adicionar ao Carrinho
            </a>
        </div>
        <button class="btn btn-primary btn-block"style="position: fixed; left: 0; bottom: 0; width: 100%; background-color: #e7e7e7; color: black; text-align: center; border-color: #e7e7e7;" onclick="window.location.href = '/editora_WebApp/'">Página Inicial</a></button>                 
</body>
</html>
