package diary;


import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;


@WebServlet("/diary/CalendarMain.do")
//@WebServlet("/CalendarMain.do")
public class CalendarMain extends HttpServlet {
	private static final long serialVersionUID = 1L;
 
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	      reqPro(request, response);
	   }

	   protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	      reqPro(request, response);
	   }

	   protected void reqPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		    request.setCharacterEncoding("UTF-8");
		    
		    HttpSession session = request.getSession();
			String user_id = (String)session.getAttribute("user_id");
		    String selectedDate = request.getParameter("selectedDate");
		    String yearParam = request.getParameter("year");
		    String monthParam = request.getParameter("month");

		    // 1. 기본값 세팅
		    java.util.Calendar cal = java.util.Calendar.getInstance();
		    int year = (yearParam != null) ? Integer.parseInt(yearParam) : cal.get(java.util.Calendar.YEAR);
		    int month = (monthParam != null) ? Integer.parseInt(monthParam) : cal.get(java.util.Calendar.MONTH) + 1;

		    // 2. 월 범위 보정 로직 (여기서 미리 처리)
		    if (month > 12) {
		        year++;
		        month = 1;
		    } else if (month < 1) {
		        year--;
		        month = 12;
		    }

		    // 3. DAO 호출 (보정된 year, month 기반)
		    CalendarDAO cdao = new CalendarDAO();
		    Vector<DiaryinfoDTO> bean = cdao.select_Diary_inDate(user_id);
		    
		    // 4. JSP로 보낼 데이터 세팅
		    request.setAttribute("user_id", user_id);
		    request.setAttribute("selectedDate", selectedDate);
		    request.setAttribute("bean", bean);
		    request.setAttribute("year", year); // 보정된 연도
		    request.setAttribute("month", month); // 보정된 월

		    RequestDispatcher dis = request.getRequestDispatcher("/diary/calendarMain.jsp");
		    dis.forward(request, response);
		}
	
	  // 오늘의 날씨 크롤링
//	   private Map<String, String> getNaverWeather() {
//	    	// 결과값 담을 Map 객체 생성
//	    	Map<String, String> weather = new HashMap<String, String>();
//		    try {
//		        // 네이버에서 '서울 날씨' 검색 결과 페이지 주소
//		        String url = "https://search.naver.com/search.naver?query=서울+날씨";
//		        
//		        // Jsoup으로 HTML 문서 가져오기
//		        Document doc = Jsoup.connect(url).get();
//		        
//		        // select를 이용해 데이터 추출 (네이버 페이지 구조에 따라 변경될 수 있음)
//		        String temp = doc.select(".today_area .today_temp").text(); // 현재 기온
//		        String desc = doc.select(".today_area .cast_txt").text();  // 날씨 상태 정보
//		        String descImg = ""; // 날씨 상태에 따른 이미지 경로
//		        String yesterday = doc.select(".today_area .summary").text();  // 어제와 비교했을때 온도 차이
//		        
//		        
//		        /*
//		        맑음 계열	맑음, 대체로 맑음
//				구름 계열	흐림, 구름많음, 구름조금
//				강수 계열	비, 약한 비, 강한 비, 소나기, 곳에 따라 비
//				겨울 계열	눈, 진눈깨비, 눈/비, 약한 눈
//				특수 기상	안개, 박무(옅은 안개), 연무(먼지 안개), 황사
//				낙뢰 계열	뇌우, 천둥번개
//		         */
//		        
//		        if(desc.contains("맑음")) {
//		        	descImg = "";
//		        } else if(desc.contains("흐림") || desc.contains("비")) {
//		        	descImg = "";
//		        } else if(desc.contains("비") || desc.contains("소나기")) {
//		        	descImg = "";
//		        } else if(desc.contains("눈")) {
//		        	descImg = "";
//		        } else if(desc.contains("안개") || desc.contains("황사")) {
//		        	descImg = "";
//		        } else {
//		        	descImg = "";
//		        }
//		        
//		        weather.put("temp", temp);
//		        weather.put("desc", desc);
//		        weather.put("descImg", descImg);
//		        weather.put("yesterday", yesterday);
//		        
//		        return weather;
//		    } catch (Exception e) {
//		        e.printStackTrace();
//		        return weather;
//		    }
//		}

}
