CREATE TABLE board (
                       bno        INT AUTO_INCREMENT PRIMARY KEY,
                       title      VARCHAR(200)   NOT NULL,
                       content    TEXT           NOT NULL,
                       writer     VARCHAR(50)    NOT NULL,
                       reg_date   DATETIME       NOT NULL DEFAULT NOW(),
                       update_date DATETIME      NULL
);
