package user;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;   

@WebServlet("/UserinfoDeleteProcCon.do")
public class UserinfoDeleteProcCon extends HttpServlet {
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
		request.setCharacterEncoding("utf-8");

		HttpSession session = request.getSession();

		String user_id = (String) session.getAttribute("user_id");
		String user_pw = (String) session.getAttribute("user_pw");

		String current_pw = request.getParameter("current_pw"); // 입력한 비밀번호

		UserDAO uDAO = new UserDAO();
		UserinfoDTO bean = uDAO.getOneUserinfo(user_id);

		if (user_pw.equals(current_pw)) {
			uDAO.userinfoDelete(user_id);
			request.setAttribute("msg", "delsuccess");
			response.sendRedirect("UserinfoDeleteCon.do");
		}
		else {
			request.setAttribute("msg", "delfail");

			RequestDispatcher dis = request.getRequestDispatcher("/user/main.jsp");
			dis.forward(request, response);
		}
	}
}
