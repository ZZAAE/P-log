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
		
}
