package diary;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class GalleryCon
 */
@WebServlet("/diary/GalleryCon.do")
public class GalleryCon extends HttpServlet {
   private static final long serialVersionUID = 1L;

   protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      reqPro(request, response);
   }

   protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      reqPro(request, response);
   }

   protected void reqPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      HttpSession session = request.getSession();
      String userId = (String) session.getAttribute("user_id");
      
      System.out.println("GalleryCon - userId from session: " + userId);

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }

        GalleryDAO dao = new GalleryDAO();
        List<GalleryDTO> images = dao.selectImages(userId);
        
        System.out.println("GalleryCon - images size: " + images.size());

        request.setAttribute("images", images);
        request.getRequestDispatcher("/diary/gallery.jsp").forward(request, response);
   }
}
