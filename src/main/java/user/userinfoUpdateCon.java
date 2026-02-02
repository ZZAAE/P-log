package user;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/userinfoUpdateCon")
public class userinfoUpdateCon extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		reqPro(request, response);
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		reqPro(request, response);
	}
	
	protected void reqPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8"); 
		
		
		
		String user_id = request.getParameter("user_id");
		
		UserDAO userDAO = new UserDAO();
		UserinfoDTO bean = userDAO.getOneUserinfo(user_id);
		
		request.setAttribute("bean", bean);
		
		RequestDispatcher dis = request.getRequestDispatcher("userinfo_update.jsp");
		dis.forward(request, response);
	}

}
