package diary;


import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import image.ImageDAO;

@WebServlet("/DiaryReadCon.do")
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
		String image_path = iDao.getImageinfoPath(bean.getImage_id());
		
		request.setAttribute("bean", bean);
		request.setAttribute("image_path", image_path);
		
		RequestDispatcher dis = request.getRequestDispatcher("");
		dis.forward(request, response);
	}

}
