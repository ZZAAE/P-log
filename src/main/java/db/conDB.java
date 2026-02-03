package db;

import java.sql.Connection;
import java.sql.DriverManager;

public class conDB {
	
	private String url = "jdbc:oracle:thin:@localhost:1521:xe";
	private String user = "prologue";
	private String pass = "12345";
	

	public final void getCon() throws Exception{
		try {
			Connection con;
			Class.forName("oracle.jdbc.driver.OracleDriver");
			con = DriverManager.getConnection(this.url, this.user, this.pass);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
