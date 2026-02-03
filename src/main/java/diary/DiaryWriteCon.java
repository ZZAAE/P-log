package diary;


import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import image.ImageDAO;
import image.ImageinfoDTO;

@MultipartConfig
@WebServlet("/DiaryWriteProc.do")
public class DiaryWriteCon extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		reqPro(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		reqPro(request, response);
	}
	
	protected void reqPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		
		//DB단에서 시퀀스로 업데이트 해야함
		//int diary_id = Integer.parseInt(request.getParameter("diary_id"));
		String user_id = request.getParameter("user_id");
		int advise_id = Integer.parseInt(request.getParameter("advise_id"));
		int emotion = Integer.parseInt(request.getParameter("emotion"));
		String content = request.getParameter("content");
		//String image_id = request.getParameter("image_id");
		String create_date = request.getParameter("create_date");
		
		String path = "../resources/img";
		
		Part imgFile = request.getPart("file");
		
		InputStream fileContent = imgFile.getInputStream();
		OutputStream outputStream = null;
		String fileName = "";
		
		try {
			fileName = System.nanoTime() + imgFile.getSubmittedFileName();
			
			File file = new File(path, fileName);
			outputStream = new FileOutputStream(file);
			byte[] buffer = new byte[1024];
			
			int length;
			
			while((length = fileContent.read(buffer))!= 1) {
				outputStream.write(buffer,0,length);
			}
			
			fileContent.close();
			if(outputStream != null) {
				outputStream.flush();
				outputStream.close();
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	
		
		DiaryinfoDTO bean = new DiaryinfoDTO();
		
		bean.setUser_id(user_id);
		bean.setAdvise_id(advise_id);
		bean.setEmotion(emotion);
		bean.setContent(content);
		bean.setImage_id(fileName);
		bean.setCreate_date(create_date);
		
		DiaryDAO dDao = new DiaryDAO();
		dDao.insertDiaryInfo(bean);
		
		ImageinfoDTO imgBean = new ImageinfoDTO();
		imgBean.setImage_id(fileName);
		imgBean.setImage_path(path+"/"+fileName);
		
		ImageDAO iDao = new ImageDAO();
		iDao.insertImageinfo(imgBean);		
		
		
		request.setAttribute("user_id", user_id);
		
		RequestDispatcher dis = request.getRequestDispatcher("");
		dis.forward(request, response);
	}
	

}
