package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserinfoDAO {
	 	String url = "jdbc:oracle:thin:@localhost:1521:xe";
	    String user = "prologue";
	    String pass = "12345";

	    Connection con;
	    PreparedStatement pstmt;
	    ResultSet rs;

	    // DB 연결 
	    public void getCon() {
	        try {
	            Class.forName("oracle.jdbc.driver.OracleDriver");
	            con = DriverManager.getConnection(url, user, pass);
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }

	    public boolean userCheck(UserinfoDTO uDTO) {

	        boolean result = false;

	        try {
	            getCon();

	            String sql = "select * from userinfo where user_id=? and user_pw=?";
	            pstmt = con.prepareStatement(sql);
	            pstmt.setString(1, uDTO.getUser_id());
	            pstmt.setString(2, uDTO.getUser_pw());

	            rs = pstmt.executeQuery();

	            if (rs.next()) {
	                result = true;
	            }
	            rs.close();
	            pstmt.close();
				con.close();
				
				
	        } catch (Exception e) {
	            e.printStackTrace();
	        }

	        return result;
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
				pstmt.close();
				con.close();
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	    
}
