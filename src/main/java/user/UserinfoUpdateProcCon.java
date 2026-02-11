package user;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/UserinfoUpdateProcCon.do")
public class UserinfoUpdateProcCon extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		reqPro(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		reqPro(request, response);
	}

	protected void reqPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    request.setCharacterEncoding("utf-8");

	    HttpSession session = request.getSession();

	    String user_id = (String) session.getAttribute("user_id");
	    String current_pw = request.getParameter("current_pw");

	    String user_pw = request.getParameter("user_pw");
	    String gender = request.getParameter("gender");
	    String phone_number = request.getParameter("phone_number");
	    String birthday = request.getParameter("birthday");
	   
	    UserinfoDAO uDAO = new UserinfoDAO();
	    UserinfoDTO bean = uDAO.getOneUserinfo(user_id);

	    if (bean != null && bean.getUser_pw() != null && bean.getUser_pw().equals(current_pw)) {
	        uDAO.userinfoUpdate(user_id, user_pw, gender, phone_number, birthday);

	        request.setAttribute("msg", "success");	     

	        RequestDispatcher dis = request.getRequestDispatcher("/diary/CalendarMain.do");
	        dis.forward(request, response);
	        return;

	    } else {
	        request.setAttribute("msg", "fail");
	
	        RequestDispatcher dis = request.getRequestDispatcher("/diary/CalendarMain.do");
	        dis.forward(request, response);
	        return;
	    }
	}

}
