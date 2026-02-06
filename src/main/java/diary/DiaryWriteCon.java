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
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;


import image.ImageDAO;
import image.ImageinfoDTO;

@MultipartConfig
@WebServlet("/diary/DiaryWriteCon.do")
public class DiaryWriteCon extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		reqPro(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		reqPro(request, response);
	}
	
	protected void reqPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		
		System.out.println("DiaryWriteCon 진입");
		HttpSession session = request.getSession();  
		
		String user_id = (String)session.getAttribute("user_id");
		int advise_id = 1002; //임시
		int emotion = Integer.parseInt(request.getParameter("emotion"));
		String content = request.getParameter("content");
		String create_date = request.getParameter("create_date");
		Part imgFile = request.getPart("file");
		
		DiaryDAO dDao = new DiaryDAO();
		ImageDAO iDao = new ImageDAO();
		
		String jspPath = request.getContextPath() + "/resources/img/";
		String realPath = request.getServletContext().getRealPath("/resources/img/");
		String fileName = "";
		
		
		InputStream fileContent = imgFile.getInputStream();
		OutputStream outputStream = null;
		
		if(!imgFile.getSubmittedFileName().equals("")) {
			try {
				int fileExtentionDotIndex = imgFile.getSubmittedFileName().lastIndexOf(".");
				String pureFilename = imgFile.getSubmittedFileName().substring(0, fileExtentionDotIndex);
				String extentionName = imgFile.getSubmittedFileName().substring(fileExtentionDotIndex);
				fileName = pureFilename + "_" + System.nanoTime() + extentionName;
				
				File file = new File(realPath, fileName);
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
				imgBean.setImage_id(fileName);
				imgBean.setImage_path(jspPath+fileName);
				iDao.insertImageinfo(imgBean);
				
			} catch (Exception e) {
				e.printStackTrace();
				return;
			}
		}
		
			
		DiaryinfoDTO bean = new DiaryinfoDTO();
		
		bean.setUser_id(user_id);
		bean.setAdvise_id(advise_id);
		bean.setEmotion(emotion);
		bean.setContent(content);
		bean.setImage_id(fileName);
		bean.setCreate_date(create_date);
		
		
		dDao.insertDiaryInfo(bean);
				
		System.out.println("DiaryWriteCon.do의 create_date: " + create_date);
		request.setAttribute("create_date", create_date);
		RequestDispatcher dis = request.getRequestDispatcher("Preview.do");
		dis.forward(request, response);
	}
}
