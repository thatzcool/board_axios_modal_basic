package com.ssg.board_axios_modal.service;

import com.ssg.board_axios_modal.domain.BoardVO;

import java.util.List;

public interface BoardService {
    List<BoardVO> getList();
    BoardVO get(Integer bno);
    BoardVO register(BoardVO vo);
    boolean modify(BoardVO vo);
    boolean remove(Integer bno);
}
