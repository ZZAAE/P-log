package diary;


import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

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
				
		//int diary_id = Integer.parseInt(request.getParameter("diary_id"));
		String user_id = request.getParameter("user_id");
		//int advise_id = Integer.parseInt(request.getParameter("advise_id"));
		int advise_id = 1001; //임시
		int emotion = Integer.parseInt(request.getParameter("emotion"));
		String content = request.getParameter("content");
		//String image_id = request.getParameter("image_id");
		String create_date = request.getParameter("create_date");
		
		DiaryDAO dDao = new DiaryDAO();
		
		int diary_id = dDao.getDiaryID(user_id, create_date);
		String image_id = dDao.getDiaryInfo(diary_id).getImage_id();
		String previousImage_id = image_id;
		ImageDAO iDao = new ImageDAO();
		String image_path = iDao.getImageinfoPath(image_id);
		
		Part imgFile = request.getPart("file");
		String path = "../resources/img";
		String fileName = "";
		
		if(imgFile != null) {			
			InputStream fileContent = imgFile.getInputStream();
			OutputStream outputStream = null;
						
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
				image_id = fileName;
				image_path = path+"/"+fileName;
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		if(image_id != previousImage_id) {
			ImageinfoDTO imgBean = new ImageinfoDTO();
			imgBean.setImage_id(fileName);
			imgBean.setImage_path(path+"/"+fileName);
			iDao.insertImageinfo(imgBean);
		}
		
		DiaryinfoDTO bean = new DiaryinfoDTO();
		
		bean.setDiary_id(diary_id);
		bean.setUser_id(user_id);
		bean.setAdvise_id(advise_id);
		bean.setEmotion(emotion);
		bean.setContent(content);
		bean.setImage_id(image_id);
		//bean.setCreate_date(create_date);
		
		
		
		
		dDao.updateDiaryInfo(bean);
	}

}
