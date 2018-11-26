package retrieval;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class ClickRetriever
 */
@WebServlet("/ClickRetriever")
public class ClickRetriever extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ClickRetriever() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		HttpSession sess = request.getSession();
		String q = request.getParameter("q");
		if ("clicks".equals(q)) {
			DBHelper dbh = (DBHelper) sess.getAttribute("DBHelper");
			UserInfo ui = dbh.user;
			try {
				int sid = Integer.parseInt(request.getParameter("here"));
				dbh.retrieveClicks(sid, response.getWriter());
			}finally{}
		}else if ("currRating".equals(q)) {
			DBHelper dbh = (DBHelper) sess.getAttribute("DBHelper");
			try {
				dbh.retrieveRating(response.getWriter());
			}finally{}
		}else if("places".equals(q)) {
			DBHelper dbh = (DBHelper) sess.getAttribute("DBHelper");
			UserInfo ui = dbh.user;
			try {
				int sid = Integer.parseInt(request.getParameter("here"));
				dbh.retrievePlaces(sid, response.getWriter());
			}finally{}
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
