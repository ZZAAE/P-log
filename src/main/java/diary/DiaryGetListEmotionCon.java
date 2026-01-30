package diary;


import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/DiaryReadEmotionListProc.do")
public class DiaryGetListEmotionCon extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		
		DiaryDAO dDao = new DiaryDAO();
		
		String user_id = request.getParameter("user_id");
		int emotion = Integer.parseInt(request.getParameter("emotion"));
		
		List<DiaryinfoDTO> beans = dDao.getDirayInfoEmotion(user_id, emotion);
		
		request.setAttribute("beans", beans);
		RequestDispatcher dis = request.getRequestDispatcher("");
		dis.forward(request, response);
	}

}
