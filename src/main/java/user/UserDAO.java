package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {
	// 오라클 접속
	String url = "jdbc:oracle:thin:@localhost:1521:xe";
	String user = "prologue";
	String pass = "12345";

	Connection con; // 접속 설정
	PreparedStatement pstmt; // String -> Sql 로 형변환
	ResultSet rs; // 데이터 즉 결과값 리턴 받는 객체

	// ------------------------------------------------

	public void getCon() {
		
		try {

			Class.forName("oracle.jdbc.driver.OracleDriver");
			con = DriverManager.getConnection(url, user, pass);

		} catch (Exception e) {
			e.printStackTrace();
		}
	}// getCon
	
	public UserinfoDTO getOneUserinfo(String user_id){
		getCon();
		
		UserinfoDTO bean = new UserinfoDTO();
		
		try {
			String sql = "select * from userinfo where user_id=? ";
			pstmt = con.prepareStatement(sql);
			
			pstmt.setString(1, user_id);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				bean.setUser_id(rs.getString(1));
				bean.setUser_pw(rs.getString(2));
				bean.setGender(rs.getString(3));
				bean.setPhone_number(rs.getString(4));
				bean.setBirthday(rs.getString(5));
				
			}
			
			con.close();
			} catch (Exception e) {
				e.printStackTrace();
		}
		return bean;
	}
	
	public void userinfoUpdate(String user_id, String user_pw, String gender, String phone_number, String birthday ) {
		getCon();
		
		try {
			String sql = "update userinfo set user_pw = ?, gender = ?, phone_number = ?, birthday = ? where user_id = ?";
		
			pstmt = con.prepareStatement(sql);
			
			pstmt.setString(1, user_pw);
			pstmt.setString(2, gender);
			pstmt.setString(3, phone_number);
			pstmt.setString(4, birthday);
			pstmt.setString(5, user_id);
			
			pstmt.executeUpdate();
			
			con.close();
		
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void userinfoDelete(String user_id) {
		getCon();
		
		try {
			String sql = "delete from userinfo where user_id = ?";
			
			pstmt = con.prepareStatement(sql);
			
			pstmt.setString(1, user_id);
		} catch (Exception e) {
			
		}
	}
}
