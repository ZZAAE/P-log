package advise;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import db.conDB;

public class AdviseinfoDAO {

	// 오라클 접속 정보
	Connection con;
	PreparedStatement pstmt;
	ResultSet rs;

	// DB 연결
	
	public String getAdviseininfo(int emotion) {
		AdviseinfoDTO bean = new AdviseinfoDTO();
		int advise_id = 0;
		String advise_content = "";
		
		if(emotion == 1) {
			advise_id = (int) (Math.random() * 10) + 1001;
		}else if(emotion == 2) {
			advise_id = (int) (Math.random() * 10) + 2001;
		}else if(emotion == 3) {
			advise_id = (int) (Math.random() * 10) + 3001;
		}else if(emotion == 4) {
			advise_id = (int) (Math.random() * 10) + 4001;
		}else if (emotion == 5) {
			advise_id = (int) (Math.random() * 10) + 5001;
		}

		try {
			new conDB().getCon();


			//쿼리
			String sql = "select * FROM adviseinfo WHERE advise_id = ?";
			pstmt =  con.prepareStatement(sql); //sql문으로 전환

			pstmt.setInt(1, advise_id);
			//쿼리 결과 받기
			rs= pstmt.executeQuery(); //sql결과 받아오기

			if(rs.next()) {
				bean.setAdvise_id(rs.getInt(1));
				bean.setAdvise_type(rs.getInt(2));
				bean.setAdvise_content(rs.getString(3));
			}
			
			advise_content = bean.getAdvise_content();

			
			con.close();

		} catch (Exception e) {
			e.printStackTrace();
		}return advise_content;
		
		


	}
}
