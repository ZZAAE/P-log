package diary;


import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.NoSuchFileException;
import java.nio.file.Path;
import java.nio.file.Paths;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import image.ImageDAO;

@WebServlet("/DiaryDeleteCon.do")
public class DiaryDeleteCon extends HttpServlet {
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
		
		String filePath = iDao.getImageinfoPath(bean.getImage_id());
		Path oldFilePath = Paths.get(filePath);
		try {
			Files.delete(oldFilePath);
		}
		catch(NoSuchFileException e){
			System.out.println("삭제하려는 파일이 존재하지 않음");
		}
		catch (IOException e) {            
			e.printStackTrace();
		}
		
		dDao.deleteDirayInfo(diary_id);
		iDao.deleteImageinfo(bean.getImage_id());
		
		request.setAttribute("user_id",user_id);
		RequestDispatcher dis = request.getRequestDispatcher("");
		dis.forward(request, response);		
	}
}
