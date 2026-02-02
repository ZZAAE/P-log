package diary;

import java.io.IOException;
import java.util.Vector;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
		   String user_id = request.getParameter("user_id");
		   String selectedDate = request.getParameter("selectedDate");
		   Calender_DAO cdao = new Calender_DAO();
		   DiaryInfo_DTO bean = cdao.select_Diary_Preview(user_id, selectedDate);
		   
			// JSP저장:calenderMain.jsp에서 사용할 데이터를 저장(request);
		   request.setAttribute("user_id", user_id);
		   request.setAttribute("preview", bean);

			// JSP로 포워딩
		   RequestDispatcher dis = request.getRequestDispatcher("/diary/calenderMain.jsp");
			dis.forward(request, response);
	   }

}
