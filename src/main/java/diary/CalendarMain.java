package diary;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
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
import org.jsoup.select.Elements;

@WebServlet("/diary/CalendarMain.do")
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
      String user_id = (String) session.getAttribute("user_id");

      // ✅ 테스트 하드코딩 제거: 로그인 안 했으면 로그인으로
      if (user_id == null || user_id.trim().isEmpty()) {
         response.sendRedirect(request.getContextPath() + "/user/login.jsp");
         return;
      }

      String selectedDate = request.getParameter("selectedDate");
      String yearParam = request.getParameter("year");
      String monthParam = request.getParameter("month");

      // 1) 기본값
      java.util.Calendar cal = java.util.Calendar.getInstance();
      int year = (yearParam != null) ? Integer.parseInt(yearParam) : cal.get(java.util.Calendar.YEAR);
      int month = (monthParam != null) ? Integer.parseInt(monthParam) : cal.get(java.util.Calendar.MONTH) + 1;

      // 2) 월 범위 보정
      if (month > 12) { year++; month = 1; }
      else if (month < 1) { year--; month = 12; }

      // 3) DAO
      CalendarDAO cdao = new CalendarDAO();
      DiaryDAO ddao = new DiaryDAO();
      Vector<DiaryinfoDTO> bean = cdao.select_Diary_inDate(user_id);

      // ✅ 날씨 (descImg = "sunny.png" 이런 식으로 파일명만 내려줌)
      Map<String, String> weather = getNaverWeather();

      // ===========================
      // ✅ 차트 데이터(Ajax 없음)
      // ===========================
      // 주간(월~일)
      java.util.Calendar wc = java.util.Calendar.getInstance();
      int dow = wc.get(java.util.Calendar.DAY_OF_WEEK); // 일1 월2 ... 토7
      int mondayOffset = (dow == java.util.Calendar.SUNDAY) ? -6 : (java.util.Calendar.MONDAY - dow);
      wc.add(java.util.Calendar.DATE, mondayOffset);

      String[] weekDates = new String[7];
      for (int i = 0; i < 7; i++) {
         weekDates[i] = String.format("%04d-%02d-%02d",
               wc.get(java.util.Calendar.YEAR),
               wc.get(java.util.Calendar.MONTH) + 1,
               wc.get(java.util.Calendar.DATE));
         wc.add(java.util.Calendar.DATE, 1);
      }

      // 월간(start/end)
      java.util.Calendar mc = java.util.Calendar.getInstance();
      mc.set(year, month - 1, 1);
      int lastDay = mc.getActualMaximum(java.util.Calendar.DATE);

      String start = String.format("%04d-%02d-01", year, month);
      String end = String.format("%04d-%02d-%02d", year, month, lastDay);

      int[] weekEmotions = cdao.selectWeekEmotions(user_id, weekDates);
      int[] monthCounts = ddao.getMonthlyEmotionSummary(user_id, year, month);

      // 점수(기록 있는 날만 평균 -> 30점 환산)
      int sum = 0, cnt = 0;
      for (int e : weekEmotions) {
         if (e != 0) { sum += e; cnt++; }
      }
      int weekScore = 0;
      if (cnt > 0) {
         double avg = (double) sum / cnt; // 1~5
         weekScore = (int) Math.round((avg / 7.0) * 35.0);
      }
      
      //소식기능을 위한 타유저 일기정보 리스트 받음
      List<DiaryinfoDTO> otherUserBeans = ddao.getOtherUserDiaryInfoList(user_id);

      // 4) JSP로
      request.setAttribute("user_id", user_id);
      request.setAttribute("selectedDate", selectedDate);
      request.setAttribute("bean", bean);
      request.setAttribute("year", year);
      request.setAttribute("month", month);
      request.setAttribute("weather", weather);

      request.setAttribute("weekEmotions", weekEmotions);
      request.setAttribute("monthCounts", monthCounts);
      request.setAttribute("weekScore", weekScore);
      
      request.setAttribute("otherUserBeans", otherUserBeans);

      RequestDispatcher dis = request.getRequestDispatcher("/diary/calendarMain.jsp");
      dis.forward(request, response);
   }

   // 오늘의 날씨 크롤링
    private Map<String, String> getNaverWeather() {
        // 결과값 담을 Map 객체 생성
        Map<String, String> weather = new HashMap<String, String>();
        try {
           String query = "서울 날씨";
            String url = "https://m.search.naver.com/search.naver?where=m&query=" +
                         java.net.URLEncoder.encode(query, "UTF-8");
            Document doc = Jsoup.connect(url)
                                .userAgent("Mozilla/5.0")
                                .get();
            
             Elements tempElem = doc.select(".temperature_text"); // 기온
             Elements descElem = doc.select(".weather_main"); // 상태 (맑음/비 등)
             Elements yesterdayElem = doc.select(".temperature_info"); // 어제 기온과 비교
             
             String temp="정보 없음";
             String desc="정보 없음";
             String yesterday="정보 없음";
            String descImg = "정보 없음"; // 날씨 상태에 따른 이미지 경로
            
             if (!tempElem.isEmpty() && !descElem.isEmpty()) {
                 temp = tempElem.first().text().replace("현재 온도", "").trim();
                 desc = descElem.first().text(); // e.g. "맑음"
                 
               //어제와 날씨 비교 부분 가공
               if (!yesterdayElem.isEmpty()) {
                   String rawYesterday = yesterdayElem.first().text(); // 전체 문장 가져오기
                   
                   // "요 " (요+공백)를 기준으로 나누어 첫 번째 배열 요소만 취함
                   if(rawYesterday.contains("요 ")) {
                       yesterday = rawYesterday.split("요 ")[0] + "요";
                   } else {
                       yesterday = rawYesterday; // 구조가 다를 경우 대비
                   }
               }
                 
                 System.out.println("현재 날씨: " + desc);
                 System.out.println("현재 기온: " + temp);
                 System.out.println("어제와 비교 기온: " + yesterday);
             } else {
                 System.out.println("날씨 정보를 가져오지 못했습니다.");
             }
             
            
            /*
            맑음 계열   맑음, 대체로 맑음
          구름 계열   흐림, 구름많음, 구름조금
          강수 계열   비, 약한 비, 강한 비, 소나기, 곳에 따라 비
          겨울 계열   눈, 진눈깨비, 눈/비, 약한 눈
          특수 기상   안개, 박무(옅은 안개), 연무(먼지 안개), 황사
          낙뢰 계열   뇌우, 천둥번개
             */
            
            if(desc.contains("맑음")) {
               descImg = "../image/sunny.png";
            } else if(desc.contains("흐림")) {
               descImg = "../image/cloud.png";
            } else if(desc.contains("비") || desc.contains("소나기")) {
               descImg = "../image/rain.png";
            } else if(desc.contains("눈")) {
               descImg = "../image/snow.png";
            } else if(desc.contains("안개") || desc.contains("황사")) {
               descImg = "../image/mist.png";
            } else {
               descImg = "1";
            }
            
            weather.put("temp", temp);
            weather.put("desc", desc);
            weather.put("descImg", descImg);
            weather.put("yesterday", yesterday);
            return weather;
            
        } catch (Exception e) {
            e.printStackTrace();
            weather.put("temp", "정보 없음");
            weather.put("desc", "정보 없음");
            weather.put("descImg", "정보 없음");
            weather.put("yesterday", "연결 실패");
            return weather;
        }
    }
}
