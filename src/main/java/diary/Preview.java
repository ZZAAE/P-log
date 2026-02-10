package diary;

import java.io.IOException;
import java.util.Vector;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import image.ImageDAO;

@WebServlet("/diary/Preview.do")
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
		    
		   	System.out.println("Preview.do 진입");
		    HttpSession session = request.getSession();
			String user_id = (String)session.getAttribute("user_id");
			String selectedDate = request.getParameter("selectedDate");
			if(selectedDate == null) selectedDate = (String)request.getAttribute("create_date");
			int year = 0;
			int month = 0;

			// 만약 year, month 파라미터가 따로 안 넘어왔다면 selectedDate("2026-02-09")를 잘라서 사용
			if (request.getParameter("year") != null && request.getParameter("month") != null) {
			    year = Integer.parseInt(request.getParameter("year"));
			    month = Integer.parseInt(request.getParameter("month"));
			} else if (selectedDate != null && selectedDate.length() >= 7) {
			    year = Integer.parseInt(selectedDate.substring(0, 4)); // "2026"
			    month = Integer.parseInt(selectedDate.substring(5, 7)); // "02"
			} else {
			    // 둘 다 없다면 오늘 날짜 기준 기본값
			    java.util.Calendar now = java.util.Calendar.getInstance();
			    year = now.get(java.util.Calendar.YEAR);
			    month = now.get(java.util.Calendar.MONTH) + 1;
			}
		    System.out.println("Preview.java의 selectedDate: " + selectedDate);
		    CalendarDAO cdao = new CalendarDAO();
		    DiaryinfoDTO preview = cdao.select_Diary_Preview(user_id, selectedDate);
		    ImageDAO idao = new ImageDAO();
		    Vector<DiaryinfoDTO> bean = cdao.select_Diary_inDate(user_id);
		    
		    
		    //월간차트
		    DiaryDAO ddao = new DiaryDAO();
		    int[] monthCounts = ddao.getMonthlyEmotionSummary(user_id, year, month);
		    request.setAttribute("monthCounts", monthCounts);
		   
			// JSP저장:프리뷰 페이지에서 사용할 데이터를 저장(request);
		    request.setAttribute("preview", preview);
		    request.setAttribute("selectedDate", selectedDate);
		    request.setAttribute("bean", bean);
		    
		    if(preview == null) {
		    	RequestDispatcher dis = request.getRequestDispatcher("/diary/diarywrite.jsp");
				dis.forward(request, response);
		    	
		    }
		    else {
		    	String imagePath = idao.getImageinfoPath(preview.getImage_id());
		    	System.out.println("Preview imagePath: " + imagePath);
		    	request.setAttribute("imagePath", imagePath);
		    	// JSP로 포워딩
		    	RequestDispatcher dis = request.getRequestDispatcher("/diary/preview.jsp");
				dis.forward(request, response);
		    }
			
	   }

}
