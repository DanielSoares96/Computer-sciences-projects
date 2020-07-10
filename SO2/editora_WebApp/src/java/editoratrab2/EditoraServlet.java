package editoratrab2;

import editora.beans.Artigo;
import editora.database.DataManager;
import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

    public class EditoraServlet extends HttpServlet {

    public EditoraServlet() {
        super();
    }

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        ServletContext context = config.getServletContext();
        context.setAttribute("base", config.getInitParameter("base"));
        DataManager dataManager = new DataManager();
        context.setAttribute("dataManager", dataManager);
    }

    @Override
    public void destroy() {
        ServletContext context = this.getServletContext();
        DataManager dataManager = (DataManager) context.getAttribute("dataManager");
        if (dataManager != null) {
            try {
                dataManager.disconnect();
            } catch (Exception e) {
                System.err.println("PROBLEMA AO FINALIZAR: " + e.getMessage());
            }
        }
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String base = "/jsp/";
        String url = base + "index.jsp";
        String action = request.getParameter("action");
        
        //Verifica qual a acção pretendida e encaminha para o respectivo jsp
        if (action != null) {
            if (action.equals("detailArtigo")) {
                url = base + "detailArtigo.jsp";
            } else if (action.equals("listAutor")) {
                url = base + "listAutor.jsp";
            } else if (action.equals("listArtigos")) {
                url = base + "listArtigos.jsp";
            } else if (action.equals("checkout")) {
                url = base + "checkout.jsp";
            } else if (action.equals("checkbuy")) {
                url = base + "checkbuy.jsp";
            }else if (action.equals("searchC")) {
                url = base + "searchC.jsp";
            }else if (action.equals("searchID")) {
                url = base + "searchID.jsp";
            }else if (action.matches("(carrinho|(add|update|delete)Item)")) {
                url = base + "carrinho.jsp";
            }
        }
        // encaminhar o processamento para o Componente Web adequado
        RequestDispatcher requestDispatcher
                = getServletContext().getRequestDispatcher(url);
        requestDispatcher.forward(request, response);

    }

    // **********************************
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
