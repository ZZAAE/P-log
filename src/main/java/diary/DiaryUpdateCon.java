package diary;


import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/DiaryUpdateProc.do")
public class DiaryUpdateCon extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		reqPro(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		reqPro(request, response);
	}
	
	protected void reqPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
				
		int diary_id = Integer.parseInt(request.getParameter("diary_id"));
		String user_id = request.getParameter("user_id");
		int advise_id = Integer.parseInt(request.getParameter("advise_id"));
		int emotion = Integer.parseInt(request.getParameter("emotion"));
		String content = request.getParameter("content");
		String image_id = request.getParameter("image_id");
		String create_date = request.getParameter("create_date");
		
		DiaryinfoDTO bean = new DiaryinfoDTO();
		
		bean.setDiary_id(diary_id);
		bean.setUser_id(user_id);
		bean.setAdvise_id(advise_id);
		bean.setEmotion(emotion);
		bean.setContent(content);
		bean.setImage_id(image_id);
		bean.setCreate_date(create_date);
		
		DiaryDAO dDao = new DiaryDAO();
		dDao.updateDiaryInfo(bean);
	}

}
