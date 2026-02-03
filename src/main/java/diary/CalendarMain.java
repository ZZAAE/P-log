package diary;


import java.io.IOException;
import java.util.Vector;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@WebServlet("/CalendarMain.do")
public class CalendarMain extends HttpServlet {
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
		    String yearParam = request.getParameter("year");
		    String monthParam = request.getParameter("month");

		    // 1. 기본값 세팅
		    java.util.Calendar cal = java.util.Calendar.getInstance();
		    int year = (yearParam != null) ? Integer.parseInt(yearParam) : cal.get(java.util.Calendar.YEAR);
		    int month = (monthParam != null) ? Integer.parseInt(monthParam) : cal.get(java.util.Calendar.MONTH) + 1;

		    // 2. 월 범위 보정 로직 (여기서 미리 처리)
		    if (month > 12) {
		        year++;
		        month = 1;
		    } else if (month < 1) {
		        year--;
		        month = 12;
		    }

		    // 3. DAO 호출 (보정된 year, month 기반)
		    CalendarDAO cdao = new CalendarDAO();
		    Vector<DiaryinfoDTO> bean = cdao.select_Diary_inDate(user_id);
		    
		    // 4. JSP로 보낼 데이터 세팅
		    request.setAttribute("user_id", user_id);
		    request.setAttribute("selectedDate", selectedDate);
		    request.setAttribute("bean", bean);
		    request.setAttribute("year", year); // 보정된 연도
		    request.setAttribute("month", month); // 보정된 월

		    RequestDispatcher dis = request.getRequestDispatcher("/diary/calendarMain.jsp");
		    dis.forward(request, response);
		}
	

}
