package diary;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class DiaryDAO {
	// 오라클 접속
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
	
	//일기 정보 삽입
	public void insertDiaryInfo(DiaryinfoDTO dDto) {
		try {
			connect();
			String query = "insert into diaryinfo values(?, ?, ?, ?, ?, ?, ?)";
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, dDto.getDiary_id());
			pstmt.setString(2, dDto.getUser_id());
			pstmt.setInt(3, dDto.getAdvise_id());
			pstmt.setInt(4, dDto.getEmotion());
			pstmt.setString(5, dDto.getContent());
			pstmt.setString(6, dDto.getImage_id());
			Date date = Date.valueOf(dDto.getCreate_date());
			pstmt.setDate(7, date);
			pstmt.executeUpdate(query);
			con.close();
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	//setDiary_id로 일기 정보 하나만
	public DiaryinfoDTO getDiaryInfo(int id) {
		DiaryinfoDTO ddto = new DiaryinfoDTO();
		
		try {
			connect();
			String query = "select * from diaryinfo where diary_id=?";
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				ddto.setDiary_id(Integer.parseInt(rs.getString(1)));
				ddto.setUser_id(rs.getString(2));
				ddto.setAdvise_id(Integer.parseInt(rs.getString(3)));
				ddto.setEmotion(Integer.parseInt(rs.getString(4)));
				ddto.setContent(rs.getString(5));
				ddto.setImage_id(rs.getString(6));
				ddto.setCreate_date(rs.getDate(7).toString());
			}
			con.close();
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return ddto;
	}
	
	//특정 emotion과 일치하는 모든 일기정보 리스트로 반환
	public List<DiaryinfoDTO> getDirayInfoEmotion(String userId, int emotionID){
		List<DiaryinfoDTO> dList = new ArrayList<DiaryinfoDTO>();
			
		try {
			connect();
			String query = "select * from diaryinfo where emotion=? and user_id=?";
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, emotionID);
			pstmt.setString(2, userId);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				DiaryinfoDTO ddto = new DiaryinfoDTO();
				ddto.setDiary_id(Integer.parseInt(rs.getString(1)));
				ddto.setUser_id(rs.getString(2));
				ddto.setAdvise_id(Integer.parseInt(rs.getString(3)));
				ddto.setEmotion(Integer.parseInt(rs.getString(4)));
				ddto.setContent(rs.getString(5));
				ddto.setImage_id(rs.getString(6));
				ddto.setCreate_date(rs.getDate(7).toString());
				
				dList.add(ddto);
			}
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
				
		return dList;
	}
	
	//해당 아이디의 모든 일기정보를 리스트로 반환
	public List<DiaryinfoDTO> getDirayInfoAll(String userId){
		List<DiaryinfoDTO> dList = new ArrayList<DiaryinfoDTO>();
		
		try {
			connect();
			String query = "select * from diaryinfo where user_id=?";
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, userId);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				DiaryinfoDTO ddto = new DiaryinfoDTO();
				ddto.setDiary_id(Integer.parseInt(rs.getString(1)));
				ddto.setUser_id(rs.getString(2));
				ddto.setAdvise_id(Integer.parseInt(rs.getString(3)));
				ddto.setEmotion(Integer.parseInt(rs.getString(4)));
				ddto.setContent(rs.getString(5));
				ddto.setImage_id(rs.getString(6));
				ddto.setCreate_date(rs.getDate(7).toString());
				
				dList.add(ddto);
			}
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
				
		return dList;
	}
	
	//일기정보 업데이트
	public void updateDiaryInfo(DiaryinfoDTO dDto) {
		try {
			connect();
			String query = "update diaryinfo set advise_id=?, emotion=?, content=?, image_id=? where diary_id=?";
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, dDto.getAdvise_id());
			pstmt.setInt(2, dDto.getEmotion());
			pstmt.setString(3, dDto.getContent());
			pstmt.setString(4, dDto.getImage_id());
			pstmt.setInt(5, dDto.getDiary_id());
			pstmt.executeUpdate();
			con.close();
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	//일기정보 삭제
	public void deleteDirayInfo(int diaryId) {
		try {
			connect();
			String query = "delete from diaryinfo where diary_id=?";
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, diaryId);
			pstmt.executeUpdate();
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}		
	}
	
	//사용자 아이디와 일기작성 날짜로 다이어리 고유아이디를 받아옴 (없으면 -1 반환)
	public int getDiaryID(String userID, String date) {
		int id = -1;
		try {
				connect();
				String query = "select diary_id from diaryinfo where user_id=? AND create_date=?";
				pstmt = con.prepareStatement(query);
				pstmt.setString(1, userID);
				pstmt.setDate(2, Date.valueOf(date));
				pstmt.executeQuery();
				con.close();
				if(rs.next()) {
					id = rs.getInt(1);
				}
				con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return id;
	}
	
}