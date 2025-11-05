package com.ssg.board_axios_modal.controller;

import com.ssg.board_axios_modal.domain.BoardVO;
import com.ssg.board_axios_modal.service.BoardService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * JSP 뷰 와 JSON API (Axios)
/board/list ⇒ JSP로 게시판 목록

/api/board/{bno} ⇒ GET: JSON 한 건 조회 (모달 수정용)

/api/board ⇒ POST: JSON으로 새 글 등록

/api/board/{bno} ⇒ PUT: JSON으로 수정

/api/board/{bno} ⇒ DELETE: 삭제
 *
 *
 * @RestController 대신 @Controller를 쓰고,  * JSON을 리턴하고 싶은 메서드에만 붙여도 된다.
 *
 * */


public class BoardController {



    // JSP 목록 페이지


    // ---------- JSON API (모달 + axios) ----------

    // 1. 글 한 건 조회 (모달에 값 채우기)


    // 2. 글 등록 (모달에서 등록)


    // 3. 글 수정 (모달에서 수정)


    // 4. 글 삭제

}