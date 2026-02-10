package diary;

import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Connection;
import java.util.ArrayList;

public class GalleryDAO {
	String url = "jdbc:oracle:thin:@localhost:1521:xe";
	String user = "prologue";
	String pass = "12345";

   Connection con; // 접속 설정
   PreparedStatement pstmt; // String -> Sql 로 형변환
   ResultSet rs; // 데이터 즉 결과값 리턴 받는 객체

   // --------------------------------

   public void connect() {
      try {

         Class.forName("oracle.jdbc.driver.OracleDriver");
         con = DriverManager.getConnection(url, user, pass);

      } catch (Exception e) {
         e.printStackTrace();
      }
   }// getCon

   public ArrayList<GalleryDTO> selectImages(String userId) {
      ArrayList<GalleryDTO> list = new ArrayList<>();

      // 이미지명, 이미지 경로 가져오기
      try {
         connect();
         System.out.println("GalleryDAO - userId: " + userId);
         
         // image_id가 NULL이 아닌 경우만 조회
         String sql = "select i.image_id, i.image_path from imageinfo i, diaryinfo d where i.image_id = d.image_id and d.user_id = ? and d.image_id is not null order by d.create_date desc";

         pstmt = con.prepareStatement(sql);

         pstmt.setString(1, userId);
         rs = pstmt.executeQuery();

         System.out.println("GalleryDAO - 쿼리 실행 완료");
         
         while(rs.next()) {
            GalleryDTO dto = new GalleryDTO();

            dto.setImage_id(rs.getString("image_id"));
            dto.setImage_path(rs.getString("image_path"));
            
            System.out.println("GalleryDAO - image_id: " + dto.getImage_id() + ", path: " + dto.getImage_path());

            list.add(dto);
         }
         
         System.out.println("GalleryDAO - 총 이미지 수: " + list.size());

         rs.close();
         pstmt.close();
         con.close();
      } catch (Exception e) { e.printStackTrace(); }

      return list;
   }
}
