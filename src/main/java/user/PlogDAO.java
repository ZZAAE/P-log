package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class PlogDAO {
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
	
	public void insert_Member(UserinfoDTO uDTO) {
		try {
			getCon();
			
			String sql = "insert into userinfo values(?,?,?,?,?)";
			pstmt = con.prepareStatement(sql);
			
			pstmt.setString(1, uDTO.getUser_id());
			pstmt.setString(2, uDTO.getUser_pw());
			pstmt.setString(3, uDTO.getGender());
			pstmt.setString(4, uDTO.getPhone_number());
			pstmt.setString(5, uDTO.getBirthday());
			
			pstmt.executeUpdate();
			con.close();
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
