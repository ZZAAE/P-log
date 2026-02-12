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
			String query = "insert into diaryinfo (DIARY_ID, USER_ID, ADVISE_ID, EMOTION, CONTENT, IMAGE_ID, CREATE_DATE, IS_SHARE) "
                    + "values (diary_seq.nextval, ?, ?, ?, ?, ?, ?, ?)";
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, dDto.getUser_id());
			pstmt.setInt(2, dDto.getAdvise_id());
			pstmt.setInt(3, dDto.getEmotion());
			pstmt.setString(4, dDto.getContent());
			pstmt.setString(5, dDto.getImage_id());
			Date date = Date.valueOf(dDto.getCreate_date());
			pstmt.setDate(6, date);
			pstmt.setString(7, dDto.getIs_share());
			int result = pstmt.executeUpdate();
			con.close();
			System.out.println("insert 수행 결과: " + result);
			
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
			pstmt.setInt(1, id);
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
			String query = "update diaryinfo set advise_id=?, emotion=?, content=?, image_id=?, is_share=? where diary_id=?";
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, dDto.getAdvise_id());
			pstmt.setInt(2, dDto.getEmotion());
			pstmt.setString(3, dDto.getContent());
			pstmt.setString(4, dDto.getImage_id());
			pstmt.setString(5, dDto.getIs_share());
			pstmt.setInt(6, dDto.getDiary_id());
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
				
				String query = "select diary_id from diaryinfo where user_id=? and create_date = ?";
				System.out.println(query);
				pstmt = con.prepareStatement(query);
				pstmt.setString(1, userID);
				pstmt.setDate(2, Date.valueOf(date));
				rs = pstmt.executeQuery();

				if(rs.next()) {
					id = rs.getInt(1);
				}
				con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return id;
	}
	
	// 월간차트 계산기
	public int[] getMonthlyEmotionSummary(String user_id, int year, int month) {
		CalendarDAO cdao = new CalendarDAO();
		// 1) 날짜 계산 로직
		java.util.Calendar mc = java.util.Calendar.getInstance();
		mc.set(year, month - 1, 1);
		int lastDay = mc.getActualMaximum(java.util.Calendar.DATE);

		String start = String.format("%04d-%02d-01", year, month);
		String end = String.format("%04d-%02d-%02d", year, month, lastDay);

		// 2) DB 조회 로직
		return  cdao.selectMonthEmotionCounts(user_id, start, end);
		
		
	}
	
	// 매겨변수로 받은 유저를 제외한 다른 유저들의 일기정보들을 모두 받아옴
	public List<DiaryinfoDTO> getOtherUserDiaryInfoList(String user_id){
		List<DiaryinfoDTO> list = new ArrayList<DiaryinfoDTO>();
		
		try {
			connect();
			//String query = "select * from diaryinfo where user_id not in ?";
			String query = "select * from diaryinfo WHERE user_id <> ? "
					+ "AND create_date >= TRUNC(SYSDATE) AND is_share like 'Y' "
					+ "AND create_date < TRUNC(SYSDATE) + 1 ORDER BY create_date DESC, diary_id DESC";
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, user_id);
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
				
				list.add(ddto);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return list;
	}
	
}