package com.ssg.board_axios_modal.service;

import com.ssg.board_axios_modal.domain.BoardVO;
import com.ssg.board_axios_modal.mapper.BoardMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class BoardServiceImpl implements BoardService {

    private final BoardMapper boardMapper;

    @Override
    public List<BoardVO> getList() {
        return boardMapper.getList();
    }

    @Override
    public BoardVO get(Integer bno) {
        return boardMapper.read(bno);
    }

    @Transactional
    @Override
    public BoardVO register(BoardVO vo) {
        boardMapper.insert(vo);  // useGeneratedKeys 로 bno 세팅
        return vo;
    }

    @Transactional
    @Override
    public boolean modify(BoardVO vo) {
        return boardMapper.update(vo) == 1;
    }

    @Transactional
    @Override
    public boolean remove(Integer bno) {
        return boardMapper.delete(bno) == 1;
    }
}