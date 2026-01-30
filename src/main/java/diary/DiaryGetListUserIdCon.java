package diary;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class DiaryGetListUserIdCon extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		reqPro(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		reqPro(request, response);
	}
	protected void reqPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		DiaryDAO dDao = new DiaryDAO();
		String user_id = request.getParameter("user_id");
		
		List<DiaryinfoDTO> beans = new ArrayList<DiaryinfoDTO>();
		beans = dDao.getDirayInfoAll(user_id);
		
		request.setAttribute("beans", beans);
		RequestDispatcher dis = request.getRequestDispatcher("");
		dis.forward(request, response);	
	}

}
