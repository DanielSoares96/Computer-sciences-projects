<%@page import="java.util.ArrayList"%>
<%@page import="editora.beans.Artigo"%>

<jsp:useBean id="dataManager" scope="application" class="editora.database.DataManager"/>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <title style="color: white">Autores - Editora</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css" integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4" crossorigin="anonymous">
    </head>

    <body style="background-color: rgb(0, 17, 28)">
        <div class="container">
            <jsp:include page="menu.jsp" flush="true"/>

            <h2 style="color: white; text-align: center" >Pesquise os Artigos do Autor</h2>

            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

            <form style="margin:auto;max-width:300px;margin-bottom: 25px;">
                <input type="hidden" name="action" value="searchC"/>
                <input id="text" type="text" name="keyword" size="15"/>
                <input type="submit" value="Pesquisar">        
            </form>

            <section>
                <div class="row" style="margin-bottom:200px" >
                    <%ArrayList<Artigo> v = dataManager.obtainAllArticles();
                        for (int i = 0; i < v.size(); i++) {
                            if (i % 4 == 0) {%>
                </div>
                <div class="row" style="margin-bottom:200px">
                    <%}%>   
                    <div class="col-md">
                        <div class="">
                            <div class="text-center text-white">
                                <img class="img-fluid" src="images/imagem<%=v.get(i).getId()%>.jpg" style="width:200px;height:200px;"> 
                                <h5 style="color:white"> Titulo: <%=(v.get(i).getTitle())%></h5>
                                <h6 style="color:white"> Autor: <%=(dataManager.obtainArticleData(v.get(i).getId()).getAutor())%></h6>
                                <h5 style="color:white"> Stock: <%=(v.get(i).getStock())%></h5>
                                <button type="button" class="btn btn-group button" style ="width: 33%; margin: 0 auto; padding: 0; display: table-cell; vertical-align: middle;" onclick="window.location.href = '/editora_WebApp/?action=detailArtigo&bookId=<%=(v.get(i).getId())%>'">Detalhes</button>
                            </div>
                        </div> 
                    </div>
                    <%}%>                                    
                </div>
            </section>

            <button class="btn btn-primary btn-block"style="position: fixed; left: 0; bottom: 0; width: 100%; background-color: #e7e7e7; color: black; text-align: center; border-color: #e7e7e7;" onclick="window.location.href = '/editora_WebApp/'">Página Inicial</a></button>
        </div>
    </body>
</html>