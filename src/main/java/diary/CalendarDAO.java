package diary;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import user.UserinfoDTO;

public class CalendarDAO {
	String url = "jdbc:oracle:thin:@localhost:1521:xe";
	String user = "prologue";
	String pass = "12345";

   Connection con; // 접속 설정
   PreparedStatement pstmt; // String -> Sql 로 형변환
   ResultSet rs; // 데이터 즉 결과값 리턴 받는 객체

   public void getCon() {
      try {
         Class.forName("oracle.jdbc.driver.OracleDriver");
         con = DriverManager.getConnection(url, user, pass);
      } catch (Exception e) {
         e.printStackTrace();
      }
   }

   // ✅ 자원 해제(누수 방지)
   private void close() {
      try {
         if (rs != null) rs.close();
         if (pstmt != null) pstmt.close();
         if (con != null) con.close();
      } catch (Exception e) {
         e.printStackTrace();
      }
   }

   // 유저 아이디 기반으로 일기가 작성된 일자와 기분 검색 (캘린더 표시용)
   public Vector<DiaryinfoDTO> select_Diary_inDate(String id) {
      Vector<DiaryinfoDTO> v = new Vector<DiaryinfoDTO>();
      try {
         System.out.println("=== select_Diary_inDate 시작 ===");
         System.out.println("조회할 user_id: " + id);

         getCon();

         // TO_CHAR 추가하여 날짜를 문자열로 변환
         String sql = "select TO_CHAR(create_date, 'YYYY-MM-DD'), emotion from diaryinfo where user_id=?";
         pstmt = con.prepareStatement(sql);
         pstmt.setString(1, id);
         rs = pstmt.executeQuery();

         int count = 0;
         while (rs.next()) {
            DiaryinfoDTO dDTO = new DiaryinfoDTO();
            String date = rs.getString(1);
            int emotion = rs.getInt(2);

            dDTO.setCreate_date(date);
            dDTO.setEmotion(emotion);
            v.add(dDTO);
            count++;

            //System.out.println("조회된 데이터 " + count + ": " + date + ", 감정=" + emotion);
         }

         //System.out.println("총 " + count + "개의 일기 조회됨");

      } catch (Exception e) {
         System.out.println("!!! 에러 발생 !!!");
         e.printStackTrace();
      } finally {
         close();
      }
      return v;
   }

   // select_Diary_Preview
   public DiaryinfoDTO select_Diary_Preview(String id, String date) {
      DiaryinfoDTO dDTO = null;
      try {
         System.out.println("=== select_Diary_Preview 시작 ===");
         System.out.println("조회할 user_id: " + id);
         System.out.println("조회할 날짜: [" + date + "]");

         getCon();

         String sql = "select diary_id, emotion, content, image_id from diaryinfo "
               + "where user_id=? and TO_CHAR(create_date, 'YYYY-MM-DD') = ?";
         pstmt = con.prepareStatement(sql);
         pstmt.setString(1, id);
         pstmt.setString(2, date);
         rs = pstmt.executeQuery();

         if (rs.next()) {
            dDTO = new DiaryinfoDTO();
            dDTO.setDiary_id(rs.getInt(1));
            dDTO.setEmotion(rs.getInt(2));
            dDTO.setContent(rs.getString(3));
            dDTO.setImage_id(rs.getString(4));

            System.out.println("프리뷰 조회 성공!");
            System.out.println("내용: " + dDTO.getContent());
         } else {
            System.out.println("해당 날짜의 일기가 없습니다.");
         }

      } catch (Exception e) {
         System.out.println("!!! 프리뷰 조회 에러 !!!");
         e.printStackTrace();
      } finally {
         close();
      }
      return dDTO;
   }

   public UserinfoDTO getOneUserinfo(String user_id) {
      UserinfoDTO bean = new UserinfoDTO();

      try {
         getCon();

         String sql = "select * from userinfo where user_id=? ";
         pstmt = con.prepareStatement(sql);

         pstmt.setString(1, user_id);
         rs = pstmt.executeQuery();

         if (rs.next()) {
            bean.setUser_id(rs.getString(1));
            bean.setUser_pw(rs.getString(2));
            bean.setGender(rs.getString(3));
            bean.setPhone_number(rs.getString(4));
            bean.setBirthday(rs.getString(5));
         }

      } catch (Exception e) {
         e.printStackTrace();
      } finally {
         close();
      }
      return bean;
   }

   public Map<Integer, Integer> getEmotionCountByMonth(String userId, String month) {

      Map<Integer, Integer> map = new HashMap<>();
      for (int i = 1; i <= 5; i++) map.put(i, 0);

      try {
         getCon();

         String sql =
               "SELECT emotion, COUNT(*) cnt " +
               "FROM diaryinfo " +
               "WHERE user_id = ? " +
               "AND create_date >= TO_DATE(?, 'YYYY-MM') " +
               "AND create_date < ADD_MONTHS(TO_DATE(?, 'YYYY-MM'), 1) " +
               "GROUP BY emotion";

         pstmt = con.prepareStatement(sql);
         pstmt.setString(1, userId);
         pstmt.setString(2, month);
         pstmt.setString(3, month);

         rs = pstmt.executeQuery();
         while (rs.next()) {
            map.put(rs.getInt("emotion"), rs.getInt("cnt"));
         }

      } catch (Exception e) {
         e.printStackTrace();
      } finally {
         close();
      }

      return map;
   }

   public int[] selectWeekEmotions(String userId, String[] weekDates) {
       int[] result = new int[7];

       try {
           getCon();

           // weekDates[0] = 월요일, weekDates[6] = 일요일
           String start = weekDates[0];
           String end = weekDates[6];

           String sql =
               "SELECT TO_CHAR(create_date,'YYYY-MM-DD') AS cdate, emotion " +
               "FROM diaryinfo " +
               "WHERE user_id=? " +
               "AND create_date >= TO_DATE(?, 'YYYY-MM-DD') " +
               "AND create_date <  TO_DATE(?, 'YYYY-MM-DD') + 1";

           pstmt = con.prepareStatement(sql);
           pstmt.setString(1, userId);
           pstmt.setString(2, start);
           pstmt.setString(3, end);

           rs = pstmt.executeQuery();

           Map<String, Integer> map = new HashMap<>();
           while (rs.next()) {
               map.put(rs.getString("cdate"), rs.getInt("emotion"));
           }

           for (int i = 0; i < 7; i++) {
               Integer e = map.get(weekDates[i]);
               result[i] = (e == null) ? 0 : e;
           }

       } catch (Exception e) {
           e.printStackTrace();
       } finally {
           close();
       }

       return result;
   }

   // 2) 월간(표시중인 year/month) emotion 1~5 분포 카운트
   // ✅ DATE 비교로 수정 (TO_CHAR BETWEEN 제거)
   public int[] selectMonthEmotionCounts(String userId, String start, String end) {
      int[] cnt = new int[5]; // index0 = emotion1

      try {
         getCon();

         String sql =
               "SELECT emotion, COUNT(*) AS c " +
               "FROM diaryinfo " +
               "WHERE user_id=? " +
               "AND create_date >= TO_DATE(?, 'YYYY-MM-DD') " +
               "AND create_date <  TO_DATE(?, 'YYYY-MM-DD') + 1 " +
               "GROUP BY emotion " +
               "ORDER BY emotion";

         pstmt = con.prepareStatement(sql);
         pstmt.setString(1, userId);
         pstmt.setString(2, start); 
         pstmt.setString(3, end);   

         rs = pstmt.executeQuery();
         while (rs.next()) {
            int e = rs.getInt("emotion"); // 1~5
            int c = rs.getInt("c");
            if (e >= 1 && e <= 5) cnt[e - 1] = c;
         }

      } catch (Exception e) {
         e.printStackTrace();
      } finally {
         close();
      }

      return cnt;
   }
}
