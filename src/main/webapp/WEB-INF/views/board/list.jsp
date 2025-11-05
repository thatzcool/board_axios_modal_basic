<%--
    list.jsp의 전체 역할:

    1) 서버에서 넘어온 게시글 목록(list)을 테이블로 출력한다.
    2) "새 글 작성" 버튼을 누르면 빈 모달을 띄워서 글을 입력할 수 있게 한다.
    3) 각 행의 "수정" 버튼을 누르면 해당 글의 상세 정보를
       /api/board/{bno} 로 GET 요청 → JSON 응답을 받아 모달에 채운다.
    4) 모달에서 "저장" 버튼을 누르면
       - bno가 비어 있으면 새 글: POST /api/board (JSON 전송)
       - bno가 있으면 수정:      PUT /api/board/{bno} (JSON 전송)
    5) "삭제" 버튼을 누르면 DELETE /api/board/{bno} 로 삭제 요청을 보낸다.
--%>

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>게시판 목록</title>

    <!-- Bootstrap CSS 
         - 테이블, 버튼, 모달 등을 예쁘게 꾸미기 위한 CSS 프레임워크
         - CDN 방식으로 불러온다. -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>

    <!-- Axios (CDN 방식 라이브러리 적용)
         - 브라우저에서 AJAX 요청(비동기 HTTP 요청)을 보내기 위한 라이브러리
         - axios.get/post/put/delete 형태로 사용 -->
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>

</head>
<body class="container py-4"><%-- Bootstrap의 컨테이너 클래스와 상하 여백(py-4) 적용 --%>

<h1>게시판</h1>

<%-- 새 글 작성 버튼: 클릭 시 openCreateModal() 자바스크립트 함수 실행 --%>
<button class="btn btn-primary mb-3" onclick="openCreateModal()">새 글 작성</button>

<%-- 게시글 목록을 테이블로 출력 --%>
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
    <%-- 
        서버 컨트롤러에서 model.addAttribute("list", ...); 로 넘겨준 list를 JSTL로 반복 출력.
        var="board" : 각 요소를 board라는 이름으로 사용
     --%>
    <c:forEach items="${list}" var="board">
        <%-- data-bno 속성에 글 번호를 넣어두면 나중에 JS로 필요시 꺼내 쓸 수도 있다. --%>
        <tr data-bno="${board.bno}">
            <td>${board.bno}</td>
            <td>${board.title}</td>
            <td>${board.writer}</td>
            <td>${board.regDate}</td>
            <td>
                <%-- 수정 버튼: 클릭 시 openEditModal(해당 글번호) 호출 --%>
                <button class="btn btn-sm btn-secondary"
                        onclick="openEditModal(${board.bno})">수정</button>
                <%-- 삭제 버튼: 클릭 시 deleteBoard(해당 글번호) 호출 --%>
                <button class="btn btn-sm btn-danger"
                        onclick="deleteBoard(${board.bno})">삭제</button>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>

<!-- 모달 영역
     - Bootstrap 5에서 제공하는 모달 레이아웃
     - id="boardModal"인 모달을 JS에서 제어(열기/닫기)한다.
-->
<div class="modal fade" id="boardModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content"><%-- 흰색 박스 부분 --%>
            <div class="modal-header">
                <%-- 모달 제목. "새 글 작성" / "글 수정" 등으로 JS에서 변경 --%>
                <h5 class="modal-title" id="boardModalLabel">글 작성/수정</h5>
                <%-- X 닫기 버튼 --%>
                <button type="button" class="btn-close"
                        data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body">
                <%-- 숨겨진 입력: 글 번호(bno). 새 글일 땐 비워두고, 수정일 땐 값 채움 --%>
                <input type="hidden" id="bno"/>

                <%-- 제목 입력 --%>
                <div class="mb-3">
                    <label class="form-label">제목</label>
                    <input type="text" id="title" class="form-control"/>
                </div>

                <%-- 내용 입력 --%>
                <div class="mb-3">
                    <label class="form-label">내용</label>
                    <textarea id="content" class="form-control" rows="4"></textarea>
                </div>

                <%-- 작성자 입력 --%>
                <div class="mb-3">
                    <label class="form-label">작성자</label>
                    <input type="text" id="writer" class="form-control"/>
                </div>

            </div>

            <div class="modal-footer">
                <%-- 모달 닫기 버튼 (단순히 모달만 닫고 아무 동작 안 함) --%>
                <button type="button"
                        class="btn btn-secondary"
                        data-bs-dismiss="modal">닫기</button>

                <%-- 저장 버튼: saveBoard() 함수 실행
                     - 새 글인지 수정인지 구분해서 POST 또는 PUT 요청 보내기 --%>
                <button type="button"
                        class="btn btn-primary"
                        onclick="saveBoard()">저장</button>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS (Modal 동작에 필요한 자바스크립트 번들)
     - 이 스크립트를 통해 #boardModal 같은 모달을 JS에서 열고 닫을 수 있다.
-->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script type="text/javascript">
    // 모달 DOM 요소를 가져와서 Bootstrap Modal 객체 생성
    const modalElement = document.getElementById('boardModal');
    const modal = new bootstrap.Modal(modalElement);

    /**
     * 폼 내용을 초기화하는 함수
     * - 숨겨진 bno, 제목, 내용, 작성자 입력값을 모두 비운다.
     * - 주로 새 글 작성 시작할 때나 수정 모달 열기 전에 호출.
     */
    function clearForm() {
        document.getElementById('bno').value = '';
        document.getElementById('title').value = '';
        document.getElementById('content').value = '';
        document.getElementById('writer').value = '';
    }

    /**
     * "새 글 작성" 버튼 클릭 시 호출되는 함수.
     * - 기존에 입력되어 있을지도 모르는 값들을 모두 지우고(clearForm),
     * - 작성자 입력창을 수정 가능 상태로 만들고(readonly 제거),
     * - 모달 제목을 "새 글 작성"으로 바꾸고,
     * - 모달을 화면에 보여준다.
     */
    function openCreateModal() {
        clearForm();
        // 새 글에서는 작성자도 사용자가 직접 입력해야 하므로 readonly 제거
        document.getElementById('writer').removeAttribute('readonly');
        document.getElementById('boardModalLabel').innerText = '새 글 작성';
        modal.show();
    }

    /**
     * "수정" 버튼 클릭 시 호출되는 함수.
     * - 먼저 폼을 초기화한 뒤,
     * - /api/board/{bno} 로 GET 요청을 보내서 해당 글 정보를 JSON으로 받아온다.
     * - 응답 데이터(data)를 각 input/textarea에 채워 넣는다.
     * - 수정일 때는 작성자를 못 바꾸게 readonly로 설정한다.
     * - 마지막에 모달을 띄운다.
     *
     * @param bno 수정할 글 번호
     */
    function openEditModal(bno) {
        clearForm();
        document.getElementById('boardModalLabel').innerText = '글 수정';

        // axios.get으로 /api/board/{bno} 요청 → JSON 응답 받기
        axios.get('/api/board/' + bno)
            .then(function (response) {
                const data = response.data; // 서버에서 넘긴 BoardVO JSON

                // 응답 데이터를 폼에 채우기
                document.getElementById('bno').value = data.bno;
                document.getElementById('title').value = data.title;
                document.getElementById('content').value = data.content;
                document.getElementById('writer').value = data.writer;

                // 수정 시 작성자를 바꾸지 못하게 막고 싶다면 readonly로 설정
                document.getElementById('writer').setAttribute('readonly', 'readonly');

                // 모달 보여주기
                modal.show();
            })
            .catch(function (error) {
                alert('글 정보를 불러오는데 실패했습니다.');
                console.log(error);
            });
    }

    /**
     * 모달의 "저장" 버튼 클릭 시 실행되는 함수.
     * - 숨겨진 bno 값이 비어 있으면 "새 글 작성" → POST /api/board
     * - bno 값이 있으면 "기존 글 수정" → PUT /api/board/{bno}
     * - 성공하면 alert 후 페이지 전체 새로고침(location.reload())로 목록 갱신.
     */
    function saveBoard() {
        const bno = document.getElementById('bno').value;
        const title = document.getElementById('title').value;
        const content = document.getElementById('content').value;
        const writer = document.getElementById('writer').value;

        // 서버에 보낼 JSON payload 객체 생성
        const payload = {
            title: title,
            content: content,
            writer: writer
        };

        // bno가 없으면 새 글 작성(POST)
        if (!bno) {
            // POST /api/board
            axios.post('/api/board', payload)
                .then(function (response) {
                    alert('등록 완료!');
                    // 새 글이 추가되었으니 전체 목록을 새로고침
                    location.reload();
                })
                .catch(function (error) {
                    alert('등록 중 오류가 발생했습니다.');
                    console.log(error);
                });
        } else {
            // bno가 존재하면 수정(= PUT /api/board/{bno})
            axios.put('/api/board/' + bno, payload)
                .then(function (response) {
                    alert('수정 완료!');
                    // 수정 후 변경 내용 반영을 위해 목록 새로고침
                    location.reload();
                })
                .catch(function (error) {
                    alert('수정 중 오류가 발생했습니다.');
                    console.log(error);
                });
        }
    }

    /**
     * "삭제" 버튼 클릭 시 실행되는 함수.
     * - confirm()으로 사용자의 최종 확인을 받은 뒤,
     * - axios.delete('/api/board/{bno}') 로 삭제 요청을 보낸다.
     * - 성공 시 알림 후 페이지 새로고침으로 목록 갱신.
     *
     * @param bno 삭제할 글 번호
     */
    function deleteBoard(bno) {
        // 확인창에서 취소 누르면 삭제 중단
        if (!confirm('정말 삭제하시겠습니까?')) return;

        // DELETE /api/board/{bno} 호출
        axios.delete('/api/board/' + bno)
            .then(function () {
                alert('삭제 완료!');
                location.reload();
            })
            .catch(function (error) {
                alert('삭제 중 오류가 발생했습니다.');
                console.log(error);
            });
    }
</script>

</body>
</html>
