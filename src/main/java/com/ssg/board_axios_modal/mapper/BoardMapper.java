package com.ssg.board_axios_modal.mapper;

import com.ssg.board_axios_modal.domain.BoardVO;

import java.util.List;

public interface BoardMapper {

    List<BoardVO> getList();

    BoardVO read(Integer bno);

    void insert(BoardVO board);

    int update(BoardVO board);

    int delete(Integer bno);
}