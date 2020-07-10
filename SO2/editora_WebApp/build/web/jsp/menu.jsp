<%@page import="java.util.ArrayList"%>
<%@page import="editora.beans.Artigo"%>
<%@page language="java" contentType="text/html"%>
<%String base = (String) application.getAttribute("base");%>


<div class = "row" style="margin-bottom: 4%">
    <button type="button" class="btn btn-group button" style ="width: 33%; margin: 0 auto; padding: 0; display: table-cell; vertical-align: middle;" onclick="window.location.href = '<%=base%>?action=listAutor'">Autor</button>

    <button type="button" class="btn btn-group button" style ="width: 33%; margin: 0 auto; padding: 0; display: table-cell; vertical-align: middle;" onclick="window.location.href = '<%=base%>?action=listArtigos'">Artigo</button>

    <button type="button" class="btn btn-group button" style ="width: 33%; margin: 0 auto; padding: 0; display: table-cell; vertical-align: middle;" onclick="window.location.href = '<%=base%>?action=checkout'">Checkout</button>

</div>