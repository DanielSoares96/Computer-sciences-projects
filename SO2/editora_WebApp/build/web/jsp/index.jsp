<%@page import="editora.beans.Compra"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="editora.beans.Artigo"%>

<jsp:useBean id="dataManager" scope="application" class="editora.database.DataManager"/>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <title>Editora</title>
        <link rel="stylesheet" href="css/estilo.css" type="text/css"/>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css" integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4" crossorigin="anonymous">
        <div  class="tables" style="text-align: center;color:white;">
            <h1> Bem vindo à Editora </h1>
        </div>
    </head>
    <body style="background-color: rgb(0, 17, 28); color:white;">
    <div class="container">
        <jsp:include page="menu.jsp" flush="true"/>

        
        <section>
            
            <div class="row">
                <%Artigo artigo = dataManager.bestSellerArtigo();
                    HashMap<String, Compra> carrinho = (HashMap) application.getAttribute("carrinho");
                    if ( carrinho == null )
                    {
                        carrinho = new HashMap<String, Compra>(10);
                    }%>

                <div class="col-md align-self-center">
                    <a class="">
                        <div class="">
                            <div class="text-center text-white">
                                <h3>Best Seller</h3>
                                <h4 style="color:white"><%=(artigo.getTitle())%></h4>
                                <img class="img-fluid" src="images/imagem<%= artigo.getId()%>.jpg" style="width:200px;height:200px;"> 
                                <h5> Titulo: <%=(artigo.getTitle())%></h5>
                                <h5> Stock: <%=(artigo.getStock())%></h5>
                                <button type="button" class="btn btn-group button" style ="width: 8%; margin: 0 auto; padding: 0; display: table-cell; vertical-align: middle;" onclick="window.location.href = '/editora_WebApp/?action=detailArtigo&bookId=<%=(artigo.getId())%>'">Detalhes</button>
                            </div>
                        </div> 
                </div>
            </div>
        </section>
        <section>
            <div class="row" style="margin-bottom:20px">
                <%ArrayList<Artigo> v = dataManager.obtainAllArticles();
                    for (int i = 0; i < v.size(); i++) {
                        if (i % 4 == 0) {%>
            </div>
            <div class="row" style="margin-bottom:20px" >
                <%}%>
                <div class="col-md">
                    <div class="">
                        <div class="text-center text-white">
                            <img class="img-fluid" src="images/imagem<%=(v.get(i).getId())%>.jpg" style="width:200px;height:200px;"> 
                            <h5> Titulo: <%=(v.get(i).getTitle())%></h5>
                            <h6> Autor: <%=(dataManager.obtainArticleData(v.get(i).getId()).getAutor())%></h6>
                            <h5> Stock: <%=(v.get(i).getStock())%></h5>
                            <button type="button" class="btn btn-group button" style ="width: 33%; margin: 0 auto; padding: 0; display: table-cell; vertical-align: middle;" onclick="window.location.href = '/editora_WebApp/?action=detailArtigo&bookId=<%=(v.get(i).getId())%>'">Detalhes</button>
                        </div>
                    </div> 
                </div>
                <%}%>                                    
            </div>
        </section>
    </div>

    </body>

</html>