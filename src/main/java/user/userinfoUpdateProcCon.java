package user;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/userinfoUpdateProcCon")
public class userinfoUpdateProcCon extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
   
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		reqPro(request, response);
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		reqPro(request, response);
	}
	
	protected void reqPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		
		String user_id = request.getParameter("user_id");
		
		String user_pass = request.getParameter("user_pass"); // 유저가 입력한 유저 비번  
		String user_pw = request.getParameter("user_pw"); // 오라클에 등록된 유저 비번 
		String gender = request.getParameter("gender");
		String phone_number = request.getParameter("phone_number");
		String birthday = request.getParameter("birthday");
		
		if(user_pw.equals(user_pass)) {
			UserDAO uDAO = new UserDAO();
		}
	}

}
