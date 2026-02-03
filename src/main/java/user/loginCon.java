package user;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/user/loginCon.do")
public class loginCon extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		reqPro(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		reqPro(request, response);
	}

	protected void reqPro(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		String user_id = request.getParameter("user_id");
		String user_pw = request.getParameter("user_pw");

		UserinfoDTO uDTO = new UserinfoDTO();
		uDTO.setUser_id(user_id);
		uDTO.setUser_pw(user_pw);

		LoginDAO lDAO = new LoginDAO();
		boolean user_check = lDAO.userCheck(uDTO);

		if (user_check) {
			// 세션에 저장
			HttpSession session = request.getSession();
			session.setAttribute("user_id", user_id); 
			
			// 메인 페이지 이동
			response.sendRedirect("main.jsp");
		} else {
			request.setAttribute("msg", "아이디 또는 비밀번호가 일치하지 않습니다.");

			RequestDispatcher dis = request.getRequestDispatcher("/user/login.jsp");
			dis.forward(request, response);
		}
	}
}
