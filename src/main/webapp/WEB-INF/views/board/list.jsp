<%--
    list.jsp에서 테이블로 목록 출력

   각 행에 “수정” 버튼 → 클릭 시 모달 열고, Axios GET으로 JSON 받아와 폼 채운다.

   모달에서 “저장” 버튼 → 새 글이면 POST, 기존글이면 PUT

    삭제 버튼 → DELETE 요청
--%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>게시판 목록</title>

    <!-- Bootstrap CSS  -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>

    <!-- Axios (CDN방식 라이브러리 적용) -->
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>

</head>
<body class="container py-4">

<h1>게시판</h1>

<button class="btn btn-primary mb-3" onclick="openCreateModal()">새 글 작성</button>

<table class="table table-bordered table-hover">
    <thead>
    <tr>
        <th>번호</th>
        <th>제목</th>
        <th>작성자</th>
        <th>등록일</th>
        <th>관리</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${list}" var = "board">
    <tr>
        <td>${board.bno}</td>
        <td>${board.title}</td>
        <td>${board.writer}</td>
        <td>${board.regDate}</td>
        <td>
            <button class="btn btn-sm btn-secondary"
                    onclick="openEditModal(${board.bno})">수정
            </button>
            <button class="btn btn-sm btn-danger"
                    onclick="deleteBoard(${board.bno})">삭제
            </button>
        </td>
    </tr>
    </c:forEach>
    </tbody>
</table>

<!-- 모달-->
<div class="modal fade" id="boardModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="boardModalLabel">글 작성/수정</h5>
                <button type="button" class="btn-close"
                        data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">

                <input type="hidden" id="bno"/>

                <div class="mb-3">
                    <label class="form-label">제목</label>
                    <input type="text" id="title" class="form-control"/>
                </div>

                <div class="mb-3">
                    <label class="form-label">내용</label>
                    <textarea id="content" class="form-control" rows="4"></textarea>
                </div>

                <div class="mb-3">
                    <label class="form-label">작성자</label>
                    <input type="text" id="writer" class="form-control"/>
                </div>

            </div>
            <div class="modal-footer">
                <button type="button"
                        class="btn btn-secondary"
                        data-bs-dismiss="modal">닫기
                </button>
                <button type="button"
                        class="btn btn-primary"
                        onclick="">저장
                </button>
            </div>
        </div>
    </div>
</div>

<!-- 모달 작동 -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script type="text/javascript">
     // 새 글 작성 모달 열기
     const modalElement = document.getElementById('boardModal');
     const modal = new bootstrap.Modal(modalElement);

     function  clearForm() {
          document.getElementById('bno').value = '';
          document.getElementById('title').value = '';
          document.getElementById('content').value = '';
          document.getElementById('writer').value = '';
          document.getElementById('writer').removeAttribute('readonly');
     }

     function openCreateModal(){
         clearForm();
         document.getElementById('boardModalLabel').innerText = '새 글 작성';
         modal.show();
     }

    // 수정 모달 열기 – axios GET으로 JSON 받아오기
        function openEditModal(bno) {
            clearForm();
            document.getElementById('boardModalLabel').innerText ='글 수정';

           axios.get(`/api/board` + bno).then(
               function (response) {
                           const data = response.data;   //BoardVO JSON
                   if(!data) {
                       alert('해당 글을 찾을 수 없습니다.')
                       return;
                   }
                   document.getElementById('bno').value = data.bno;
                   document.getElementById('title').value = data.title;
                   document.getElementById('content').value = data.content;
                   document.getElementById('writer').value = data.writer;
                   document.getElementById('writer').setAttribute('readonly','readonly');
               }).catch(
                   function (error){
                       console.error(error);
                       alter('글 수정을 진행하는 도중 오류가 발생하였습니다.');
                   });
        }

    // 저장 버튼 (새 글인지 수정인지 구분)


    // 새 글 작성(POST) vs 수정(PUT) 구분

    // PUT /api/board/{bno}


    // 삭제

</script>

</body>
</html>

