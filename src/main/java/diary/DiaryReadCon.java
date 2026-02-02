package diary;


import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import image.ImageDAO;

@WebServlet("/DiaryReadProc.do")
public class DiaryReadCon extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		reqPro(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		reqPro(request, response);
	}
	
	protected void reqPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		
		DiaryDAO dDao = new DiaryDAO();
		ImageDAO iDao = new ImageDAO();
		
		String user_id = request.getParameter("user_id");
		String create_date = request.getParameter("create_date");
		
		int diary_id = dDao.getDiaryID(user_id, create_date);
		
		DiaryinfoDTO bean = dDao.getDiaryInfo(diary_id);
		String imagePath = iDao.getImageinfoPath(bean.getImage_id());
	}

}
