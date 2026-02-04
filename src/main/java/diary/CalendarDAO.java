package diary;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Vector;

public class CalendarDAO {
	String url = "jdbc:oracle:thin:@localhost:1521:xe";
	String user = "ProjectTester";
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
	        while(rs.next()) {
	            DiaryinfoDTO dDTO = new DiaryinfoDTO();
	            String date = rs.getString(1);
	            int emotion = rs.getInt(2);
	            
	            dDTO.setCreate_date(date);
	            dDTO.setEmotion(emotion);
	            v.add(dDTO);
	            count++;
	            
	            System.out.println("조회된 데이터 " + count + ": " + date + ", 감정=" + emotion);
	        }
	        
	        System.out.println("총 " + count + "개의 일기 조회됨");
	        con.close();
	        
	    } catch (Exception e) {
	        System.out.println("!!! 에러 발생 !!!");
	        e.printStackTrace();
	    }
	    return v;
	}

	// select_Diary_Preview 
	public DiaryinfoDTO select_Diary_Preview(String id, String date) {
	    DiaryinfoDTO dDTO = new DiaryinfoDTO();
	    dDTO = null;
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
	        con.close();

	    } catch (Exception e) {
	        System.out.println("!!! 프리뷰 조회 에러 !!!");
	        e.printStackTrace();
	    }
	    return dDTO;
	}
	
	
	
}
