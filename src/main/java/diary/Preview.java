package diary;

import java.io.IOException;

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
			String selectedDate = "";
			
			if(request.getAttribute("create_date")!=null) { //DirayWriteCon.do에서 값을 보내줄경우
				selectedDate = (String)request.getAttribute("create_date");
			}
			else { // calendarMain.jsp에서 값을 보내줄 경우
				selectedDate = request.getParameter("selectedDate");
			}
		    System.out.println("Preview.java의 selectedDate: " + selectedDate);
		    CalendarDAO cdao = new CalendarDAO();
		    DiaryinfoDTO preview = cdao.select_Diary_Preview(user_id, selectedDate);
		    ImageDAO idao = new ImageDAO();
		   
			// JSP저장:calenderMain.jsp에서 사용할 데이터를 저장(request);
		    request.setAttribute("preview", preview);
		    request.setAttribute("selectedDate", selectedDate);
		    
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
