package com.ssg.board_axios_modal.controller;

import com.ssg.board_axios_modal.domain.BoardVO;
import com.ssg.board_axios_modal.service.BoardService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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
 *
 * /api/board/list ⇒ JSP로 게시판 목록
 *
 * /api/board/{bno} ⇒ GET: JSON 한 건 조회 (모달 수정용)
 *
 * /api/board ⇒ POST: JSON으로 새 글 등록
 *
 * /api/board/{bno} ⇒ PUT: JSON으로 수정
 *
 * /api/board/{bno} ⇒ DELETE: 삭제
 *
 *
 *
 *
 * */

@RestController    //Controller + @ResponseBody (전부 JSON 으로 통일)
@RequestMapping("/api/board")
@RequiredArgsConstructor
public class BoardController {

         private final BoardService boardService;

    // JSP 목록 페이지
    @GetMapping
    public ResponseEntity<List<BoardVO>> list(org.springframework.ui.Model model) {

        List<BoardVO> list = boardService.getList();
        //model.addAttribute("list", list);
        return ResponseEntity.ok(list);
    }


    // ---------- JSON API (모달 + axios) ----------

    // 1. 글 한 건 조회 (모달에 값 채우기)
    @GetMapping("/{bno}")
    public ResponseEntity<BoardVO> getBoard(@PathVariable("bno") Integer bno ) {
           BoardVO  vo = boardService.get(bno);
           if (vo == null) {
               return ResponseEntity.notFound().build();

           }
          return ResponseEntity.ok(vo);
    }


    // 2. 글 등록 (모달에서 등록)
       @PostMapping
          public ResponseEntity<BoardVO> createBoard(@RequestBody BoardVO boardVO) {
            BoardVO saved = boardService.register(boardVO);
            return ResponseEntity.ok(saved);
       }

    // 3. 글 수정 (모달에서 수정)
    @PutMapping("/{bno}")
          public ResponseEntity<BoardVO> updateBoard(@PathVariable("bno") Integer bno, @RequestBody BoardVO boardVO) {
                     boardVO.setBno(bno);
                     boolean result = boardService.modify(boardVO);
                     if(!result) {
                         return ResponseEntity.notFound().build();
                     }
                     BoardVO updated = boardService.get(bno);
                     return ResponseEntity.ok(updated);
          }



    // 4. 글 삭제
    @DeleteMapping("/{bno}")
    public ResponseEntity<BoardVO> deleteBoard(@PathVariable("bno") Integer bno) {
        boolean result = boardService.remove(bno);
        if(!result) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok().build();
    }


}