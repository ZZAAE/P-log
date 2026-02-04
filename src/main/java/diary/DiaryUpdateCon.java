package diary;


import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.NoSuchFileException;
import java.nio.file.Path;
import java.nio.file.Paths;

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
@WebServlet("/DiaryUpdateCon.do")
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
				
		String user_id = request.getParameter("user_id");
		int advise_id = 1002; //임시
		int emotion = Integer.parseInt(request.getParameter("emotion"));
		String content = request.getParameter("content");
		String create_date = request.getParameter("create_date");
		
		DiaryDAO dDao = new DiaryDAO();
		ImageDAO iDao = new ImageDAO();
		
		int diary_id = dDao.getDiaryID(user_id, create_date);
		String image_id = dDao.getDiaryInfo(diary_id).getImage_id();
		String prevImage_id = image_id;

		String prevImage_path = iDao.getImageinfoPath(prevImage_id);
		
		
		Part imgFile = request.getPart("file");
		String path = "../resources/img";
		String fileName = "";
		
		InputStream fileContent = imgFile.getInputStream();
		OutputStream outputStream = null;
		
		if(!fileName.equals("")) {
			try {
				int fileExtentionDotIndex = imgFile.getSubmittedFileName().lastIndexOf(".");
				String pureFilename = imgFile.getSubmittedFileName().substring(0, fileExtentionDotIndex);
				String extentionName = imgFile.getSubmittedFileName().substring(fileExtentionDotIndex);
				fileName = pureFilename + System.nanoTime() + extentionName;
				
				File file = new File(path, fileName);
				outputStream = new FileOutputStream(file);
				byte[] buffer = new byte[1024];
				
				int length;
				
				while((length = fileContent.read(buffer))!= -1) {
					outputStream.write(buffer,0,length);
				}
				
				fileContent.close();
				if(outputStream != null) {
					outputStream.flush();
					outputStream.close();
				}
				
				ImageinfoDTO imgBean = new ImageinfoDTO();
				imgBean.setImage_id(prevImage_id);
				imgBean.setImage_path(path+"/"+fileName);
				iDao.updateImageinfo(imgBean);
				
				//이미지 수정후 이전 파일 삭제
				Path oldFilePath = Paths.get(prevImage_path);
				try {
					Files.delete(oldFilePath);
				}
				catch(NoSuchFileException e){
					System.out.println("삭제하려는 파일이 존재하지 않음");
				}
				catch (IOException e) {            
					e.printStackTrace();
				}
				
			} catch (Exception e) {
				e.printStackTrace();
				return;
			}
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
		
		request.setAttribute("user_id", user_id);

		RequestDispatcher dis = request.getRequestDispatcher("");
		dis.forward(request, response);
	}

}