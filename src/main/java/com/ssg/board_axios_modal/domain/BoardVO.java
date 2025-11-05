package com.ssg.board_axios_modal.domain;

import lombok.Data;

import java.util.Date;

@Data
public class BoardVO {
    private Integer bno;
    private String title;
    private String content;
    private String writer;
    private Date regDate;
    private Date updateDate;
}