package user;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/UserinfoList.do")
public class UserinfoList extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		reqPro(request, response);
	}

	protected void reqPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    request.setCharacterEncoding("utf-8");

	    HttpSession session = request.getSession();
	    String user_id = (String) session.getAttribute("user_id"); 

	    if (user_id == null) {
	        response.sendRedirect("login.jsp");
	        return;
	    }

	    UserinfoDAO udao = new UserinfoDAO();
	    UserinfoDTO bean = udao.getOneUserinfo(user_id);

	    request.setAttribute("bean", bean);

	    RequestDispatcher dis = request.getRequestDispatcher("/user/userinfo_update.jsp");
	    dis.forward(request, response);
	}

}
