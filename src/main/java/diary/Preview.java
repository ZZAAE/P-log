package diary;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/Preview.do")
public class Preview extends HttpServlet {
	private static final long serialVersionUID = 1L;
	 
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	      reqPro(request, response);
	   }

	   protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	      reqPro(request, response);
	   }

	   protected void reqPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		   request.setCharacterEncoding("UTF-8");
		    
		    HttpSession session = request.getSession();
			String user_id = (String)session.getAttribute("user_id");
		    String selectedDate = request.getParameter("selectedDate");
		    CalendarDAO cdao = new CalendarDAO();
		    DiaryinfoDTO preview = cdao.select_Diary_Preview(user_id, selectedDate);
		   
			// JSP저장:calenderMain.jsp에서 사용할 데이터를 저장(request);
		    request.setAttribute("preview", preview);
		    request.setAttribute("selectedDate", selectedDate);

			// JSP로 포워딩
		   RequestDispatcher dis = request.getRequestDispatcher("/diary/preview.jsp");
			dis.forward(request, response);
	   }

}
