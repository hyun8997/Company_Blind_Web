-- INSERT INTO go_member (mem_id, mem_pwd, mem_email, mem_level, com_name)
-- VALUES ('goott7', '1234', 'goott7@naver.com', 0, '구트아카데미');

-- INSERT INTO go_member (mem_id, mem_pwd, mem_email, com_name)
-- VALUES ('dong', '1234', 'goott3@naver.com', '구트아카데미');

-- INSERT INTO go_board_company
-- values ('구트아카데미');

-- insert into go_board (brd_title, brd_cont, com_name, mem_id)
-- values ('홍1', '홍2', '구트아카데미', 'hong');

-- insert into go_board (brd_title, brd_cont, com_name, mem_id)
-- values ('동1', '동2', '구트아카데미', 'dong');go_comment

-- insert into go_comment (com_cont, com_group, brd_num, mem_id)
-- values ('1번댓글', 0, 2, 'hong');

-- insert into go_comment (com_cont, com_group, brd_num, mem_id)
-- values ('2번댓글', 1, 2, 'hong');

-- insert into go_comment (com_cont, com_group, brd_num, mem_id)
-- values ('3번댓글', 0, 2, 'dong');

-- insert into go_comment (com_cont, com_group, brd_num, mem_id)
-- values ('4번댓글', 0, 2, 'gil');

-- insert into go_comment (com_cont, com_group, brd_num, mem_id)
-- values ('5번댓글', 1, 2, 'dong');

-- insert into go_comment (com_cont, com_group, brd_num, mem_id)
-- values ('6번댓글', 2, 2, 'dong');

-- insert into go_comment (com_cont, com_group, brd_num, mem_id)
-- values ('7번댓글', 6, 2, 'dong');

-- insert into go_comment (com_cont, com_group, brd_num, mem_id)
-- values ('8번댓글', 5, 2, 'gil');

-- insert into go_comment (com_cont, com_group, brd_num, mem_id)
-- values ('9번댓글', 4, 2, 'hong');










-- DROP FUNCTION IF EXISTS comment_hierarchi;
-- DELIMITER $$

-- CREATE FUNCTION  comment_hierarchi() RETURNS INT
-- NOT DETERMINISTIC
-- READS SQL DATA
-- BEGIN
--     DECLARE v_id INT;
--     DECLARE v_parent INT;   
--     DECLARE CONTINUE HANDLER FOR NOT FOUND SET @id = NULL;
--  
--     SET v_parent = @id;
--     SET v_id = -1;
--  
--     IF @id IS NULL THEN
--         RETURN NULL;
--     END IF;
--  
--     LOOP
--    
--     SELECT MIN(cmt_num)
--       INTO @id
--       FROM go_comment
--      WHERE com_group = v_parent
--        AND cmt_num > v_id;
--  
--     IF (@id IS NOT NULL) OR (v_parent = @start_with) THEN
--        SET @level = @level + 1;
--     RETURN @id;
--     END IF;
--    
--     SET @level := @level - 1;
--  
--     SELECT cmt_num, com_group
--       INTO v_id , v_parent
--         FROM go_comment
--        WHERE cmt_num = v_parent;
--     END LOOP;
-- END $$
-- DELIMITER ;


SELECT CASE WHEN LEVEL-1 > 0 then CONCAT(CONCAT(REPEAT('    ', level  - 1),'┗'), ani.com_cont)
                 ELSE ani.com_cont
           END AS com_cont
     , ani.cmt_num
     , ani.com_group
     , ani.mem_id
     , com_lev
     , fnc.level
  FROM
     (SELECT comment_hierarchi() AS id, @level AS level
        FROM (SELECT @start_with:=0, @id:=@start_with, @level:=0) vars
          JOIN go_comment
         WHERE @id IS NOT NULL) fnc
  JOIN go_comment ani ON fnc.id = ani.cmt_num
  where ani.brd_num =2;


-- update go_comment 	--안됨
-- set com_lev = (select fnc.level 
-- 				FROM (SELECT comment_hierarchi() AS id, @level AS level
-- 						FROM (SELECT @start_with:=0, @id:=@start_with, @level:=0) vars
-- 						JOIN go_comment
-- 						WHERE @id IS NOT NULL) fnc
-- 				JOIN go_comment ani ON fnc.id = ani.cmt_num
-- 				where ani.brd_num =2)
-- where cmt_num = 9;







































