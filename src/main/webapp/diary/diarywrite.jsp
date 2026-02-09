<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.Calendar"%>
<%
request.setCharacterEncoding("UTF-8");
String userId = (String)session.getAttribute("user_id");
if(userId == null){response.sendRedirect("../user/login.jsp");return;}

String date = request.getParameter("selectedDate");
if(date == null || date.trim().isEmpty()){
  date = java.time.LocalDate.now().toString();
}

// left calendar month/year = date 기준
int year = Integer.parseInt(date.substring(0,4));
int month = Integer.parseInt(date.substring(5,7));

Calendar cal = Calendar.getInstance();
cal.set(year, month - 1, 1);
int week = cal.get(Calendar.DAY_OF_WEEK);
int weekMon = (week == Calendar.SUNDAY) ? 7 : (week - 1); // Mon=1 ... Sun=7
int lastDay = cal.getActualMaximum(Calendar.DATE);

// 오늘
Calendar today = Calendar.getInstance();
int ty = today.get(Calendar.YEAR);
int tm = today.get(Calendar.MONTH) + 1;
int td = today.get(Calendar.DATE);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>일기 작성</title>

<link rel="stylesheet" href="<%=request.getContextPath()%>/css/diary_n.css">
<link rel="stylesheet"
  href="https://fonts.googleapis.com/css2?family=Inter:slnt,wght@-10..0,100..900&display=swap">

<script>
  /* 이미지 업로드 관련 JS 유지 */
  function openImage(){
    showImageUI(true);
    document.getElementById("file").click();
  }
  function showImageUI(on){
    const imgBox = document.querySelector(".imgBox");
    const textarea = document.querySelector("textarea");
    if(on){
      imgBox.classList.add("show");
      textarea.classList.add("hasImage");
    }else{
      imgBox.classList.remove("show");
      textarea.classList.remove("hasImage");
    }
  }
  function submitWrite(){
    document.getElementById("writeForm").submit();
  }
  window.addEventListener("DOMContentLoaded", ()=>{
    const fileInput = document.getElementById("file");
    const previewImg = document.getElementById("previewImg");

    showImageUI(false);

    fileInput.addEventListener("change",(e)=>{
      const f = e.target.files && e.target.files[0];
      if(!f){
        previewImg.src = "";
        previewImg.style.display = "none";
        showImageUI(false);
        return;
      }
      previewImg.src = URL.createObjectURL(f);
      previewImg.style.display = "block";
      showImageUI(true);
    });
  });
</script>
</head>

<body>
  <!-- 상단바(메인과 동일) -->
  <div class="topbar">
    <div class="topbar__inner">
      <div class="topbar__logo">P-log</div>
      <a class="topbar__profile" href="#" aria-label="프로필">
        <span class="topbar__profileIcon" aria-hidden="true"></span>
      </a>
    </div>
  </div>

  <div class="desktop-layout">

    <!-- 좌측 패널: 캘린더 + 월간 현황(기능 페이지 기준) -->
    <aside class="desktop-side desktop-side--left">
      <div class="left-cal">
        <div class="left-cal__nav">
          <a class="left-cal__btn" href="<%=request.getContextPath()%>/diary/DiaryWriteCon?date=<%= (month==1 ? (year-1)+"-12-01" : year+"-"+String.format("%02d", (month-1))+"-01") %>">‹</a>
          <div class="left-cal__title"><%=year%>. <%=String.format("%02d", month)%>.</div>
          <a class="left-cal__btn" href="<%=request.getContextPath()%>/diary/DiaryWriteCon?date=<%= (month==12 ? (year+1)+"-01-01" : year+"-"+String.format("%02d", (month+1))+"-01") %>">›</a>
        </div>

        <div class="left-cal__dow">
          <div>Mo</div><div>Tu</div><div>We</div><div>Th</div><div>Fr</div><div>Sa</div><div>Su</div>
        </div>

        <div class="left-cal__grid">
          <%
          // prev month filler
          Calendar preCal = (Calendar)cal.clone();
          preCal.add(Calendar.MONTH, -1);
          int preLastDay = preCal.getActualMaximum(Calendar.DATE);
          int preStartDay = preLastDay - (weekMon - 2);

          for(int i=0;i<weekMon-1;i++){
          %>
            <div class="d inactive"><%=preStartDay+i%></div>
          <%
          }

          int dayCount = weekMon - 1;
          for(int d=1; d<=lastDay; d++){
            String todayClass = (year==ty && month==tm && d==td) ? " today" : "";
          %>
            <a class="d no_diary<%=todayClass%>"
               href="<%=request.getContextPath()%>/diary/DiaryWriteCon?date=<%=year%>-<%=String.format("%02d",month)%>-<%=String.format("%02d",d)%>"><%=d%></a>
          <%
            dayCount++;
          }

          // next month filler
          int remain = 1;
          while(dayCount % 7 != 0){
          %>
            <div class="d inactive"><%=remain++%></div>
          <%
            dayCount++;
          }
          %>
        </div>
      </div>

      <div class="panel-card panel-card--month">
        <p class="panel-cardTitle">1월 달 기분 현황</p>
        <div class="panel-month" aria-label="월간 기분 현황 차트 영역"></div>
      </div>
    </aside>

    <!-- 중앙: 작성 UI (390 고정) -->
    <main class="desktop-center">
      <div class="phone">
        <!-- 작성 상단바 -->
        <header class="write-top">
          <button type="button" class="icon-btn back" onclick="history.back()">‹</button>

          <div class="date-wrap">
            <div class="date-text"><%=date%></div>
            <div class="date-line"></div>
          </div>

          <div class="actions">
            <button type="button" class="icon-btn circle" onclick="openImage()">＋</button>
            <button type="button" class="icon-btn circle" onclick="submitWrite()">✓</button>
          </div>
        </header>

        <!-- 폼 -->
        <form id="writeForm"
              action="<%=request.getContextPath()%>/diary/DiaryWriteCon.do"
              method="post"
              enctype="multipart/form-data">

          <input type="hidden" name="create_date" value="<%=date%>">

          <!-- 표정 선택 -->
          <section class="emoji-row emoji-pick">
            <input type="checkbox" id="emo1" name="emotion" value="1" class="emo" hidden>
            <label for="emo1" class="emoji-btn">
              <img src="<%=request.getContextPath()%>/resources/mood/mood1.png" alt="아주 나쁨">
            </label>

            <input type="checkbox" id="emo2" name="emotion" value="2" class="emo" hidden>
            <label for="emo2" class="emoji-btn">
              <img src="<%=request.getContextPath()%>/resources/mood/mood2.png" alt="나쁨">
            </label>

            <input type="checkbox" id="emo3" name="emotion" value="3" class="emo" hidden>
            <label for="emo3" class="emoji-btn">
              <img src="<%=request.getContextPath()%>/resources/mood/mood3.png" alt="보통">
            </label>

            <input type="checkbox" id="emo4" name="emotion" value="4" class="emo" hidden>
            <label for="emo4" class="emoji-btn">
              <img src="<%=request.getContextPath()%>/resources/mood/mood4.png" alt="좋음">
            </label>

            <input type="checkbox" id="emo5" name="emotion" value="5" class="emo" hidden>
            <label for="emo5" class="emoji-btn">
              <img src="<%=request.getContextPath()%>/resources/mood/mood5.png" alt="아주 좋음">
            </label>
          </section>

          <input type="file" name="file" id="file" accept="image/*" style="display:none;">

          <!-- 이미지 -->
          <div class="photo-area imgBox">
            <img id="previewImg" class="photo" style="display:none;">
          </div>

          <!-- 내용 -->
          <section class="content-area">
            <div class="content-box">
              <textarea name="content" class="diary-input"
                placeholder="오늘 하루를 기록해보세요." required></textarea>
            </div>
          </section>
        </form>
      </div>
    </main>

    <!-- 우측 패널: 메인과 동일(소식) -->
    <aside class="desktop-side desktop-side--right">
      <h2 class="panel-title">소식</h2>

      <div class="news-list">
        <article class="news-card">
          <div class="news-avatar" aria-hidden="true"></div>
          <div class="news-body">
            <div class="news-name">smile1225 님</div>
            <div class="news-text">
              <span class="news-message">
                혼자 산책 다녀왔다... 요즘 날씨가 춥네 내일은 해피 공원에 가야겠다. 요즘 혼자 산책을 즐기는 중...
              </span>
              <span class="news-emoji">
                <img src="<%=request.getContextPath()%>/images/emotion_angry.png" alt="emotion">
              </span>
            </div>
          </div>
        </article>

        <article class="news-card">
          <div class="news-avatar" aria-hidden="true"></div>
          <div class="news-body">
            <div class="news-name">smile1225 님</div>
            <div class="news-text">
              <span class="news-message">
                혼자 산책 다녀왔다... 요즘 날씨가 춥네 내일은 해피 공원에 가야겠다. 요즘 혼자 산책을 즐기는 중...
              </span>
              <span class="news-emoji">
                <img src="<%=request.getContextPath()%>/images/emotion_angry.png" alt="emotion">
              </span>
            </div>
          </div>
        </article>
      </div>
    </aside>

  </div>
</body>
</html>
