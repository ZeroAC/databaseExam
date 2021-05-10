-- 4.1 修改表内数据 UPDATE 表名 SET 列名1=新值1，列名2=新值2，.. WHERE 筛选条件
SET SQL_SAFE_UPDATES = 0; -- 关闭安全更新模式
CALL getData('t');
-- 4.1.1 把学生“周武”的年龄改为 19，系别改为“信息”
UPDATE s SET birthday = '2002-12-01',dept = '信息' WHERE sn='周武';
-- 4.1.2 将教师“王平”的职称改为“副教授"
UPDATE t SET prof = '副教授' WHERE tn = '王平';

-- 4.1.3 删除表中数据 DELECT FROM 表 WHERE 条件
-- 一旦删除数据，它就会永远消失。因此，在执行DELETE语句之前，应该先备份数据库，以防万一要找回删除过的数据。
-- zeroac@zeroUbuntu:~$ mysqldump -u exam -p jxsk > ./Desktop/examDatabase/before04.sql
DELETE FROM s WHERE sn = '周武';
DELETE FROM t WHERE tn = '王平';
-- 4.2 输入一些数据
-- 4.3 综合练习题
CALL getData('sc');
-- 4.3.1 向表 T中插入一个教师元组（t6，李红， 女， 30， 副教授,1300，2000， 英语）
INSERT INTO t VALUES('t6','李红','女',30,'副教授',1300,2000,'英语');
-- 4.3.2 将“英语”课程的任课教师号修改为"t6"
UPDATE tc SET tno = 't6' WHERE cno IN (SELECT cno FROM c WHERE cn = '英语');

-- 4.3.3 增加年龄字段 age，并计算并填充所有学生的 age字段
ALTER TABLE s ADD COLUMN age TINYINT AFTER birthday;
UPDATE s SET age = TIMESTAMPDIFF(YEAR, birthday, CURDATE()); 

-- 4.3.4 再将所有学生的年龄增加 1岁
UPDATE s SET age = age + 1 ;

-- 4.3.5 将“高等数学”课程不及格的成绩修改为 0分
INSERT INTO sc VALUES('s1','c5',59),('s2','c5',89),('s4','c5',22);-- 插入几个不及格的成绩
UPDATE sc SET score = 0 WHERE 
(score< 60 AND cno = (SELECT cno FROM c WHERE cn = '高等数学'));

-- 4.3.6 将低于总平均分成绩的女同学成绩提高5%  ！！！未完成
CALL getData('s');
-- 交互式 插入一些女同学 及其成绩
SELECT cno,AVG(score)  FROM sc GROUP BY sc.cno; -- 获取各科的平均成绩
SELECT s.sno,s.sn,s.sex,sc.cno,sc.score FROM s JOIN sc ON s.sno = sc.sno WHERE s.sex = '女'; -- 获取女生的各科成绩

SELECT s.sno, s.sn, s.sex, sc.cno, sc.score, temp.avgsc 
FROM s JOIN sc ON s.sno = sc.sno JOIN (SELECT cno,AVG(score) avgsc FROM sc GROUP BY sc.cno) temp ON sc.cno = temp.cno ; -- 获取各科成绩以及该科目的平均成绩

SELECT s.sno, s.sn, s.sex, sc.cno, sc.score, temp.avgsc 
FROM s JOIN sc ON s.sno = sc.sno JOIN (SELECT cno,AVG(score) avgsc FROM sc GROUP BY sc.cno) temp ON sc.cno = temp.cno 
WHERE s.sex = '女' AND sc.score < temp.avgsc; -- 获取低于平均成绩的女生


CREATE VIEW s_avgAS AS (SELECT s.sno, s.sn, s.sex, sc.cno, sc.score, temp.avgsc 
FROM s JOIN sc ON s.sno = sc.sno JOIN (SELECT cno,AVG(score) avgsc FROM sc GROUP BY sc.cno) temp ON sc.cno = temp.cno 
WHERE s.sex = '女' AND sc.score < temp.avgsc); -- 将低于平均成绩的女生创建视图

SELECT * FROM s_avgAS; -- 使用视图 当表内的数据发生变化时 视图里的内容也会随之变化

CALL getData('sc');

SELECT * FROM sc WHERE (sc.sno,sc.cno) IN (SELECT sno,cno FROM s_avgAS); -- 在sc表中找出低于平均成绩的人
UPDATE sc SET score = 1.05*score WHERE sno IN (SELECT sno FROM s_avgAS) AND cno IN (SELECT cno FROM s_avgAS); -- 将低于总平均分成绩的女同学成绩提高5%


-- 将“张小明”同学的信息分别从基本表 sc和 s中删除
CALL getData('t');
DELETE FROM s WHERE sn = '张小明';
DELETE FROM sc WHERE sno = 's3';

-- 从基本表 c中删除“张雪”老师的任课信息
DELETE FROM t WHERE tn = '张雪';

-- 4.4 综合操作

-- 4.4.1 )为 tc表添加“Term”字段，表示此授课是针对哪一级学生的第几学期开课的，如：2018
-- 级第 5学期开课，则填写 20185
ALTER TABLE tc
ADD Term VARCHAR(10);
CALL getData('tc');
CALL getFT('tc');

ALTER TABLE tc CHANGE COLUMN preriod preriod VARCHAR(10); -- 插入时发现数据类型错误 故而把tinyint改为varchar
UPDATE tc SET term = '20181';

-- 按 score填充 grade,100~90为 A，80以上为 B，70分以上为 C，60分以上为 D，60
-- 分以下为 E。

-- 首先定义一个存储函数 来显示输入分数 按照要求输出等级
-- 如不设置会出错 具体参考 https://stackoverflow.com/questions/26015160/deterministic-no-sql-or-reads-sql-data-in-its-declaration-and-binary-logging-i
SET GLOBAL log_bin_trust_function_creators = 1; 
DELIMITER $
CREATE FUNCTION getGrade(score TINYINT UNSIGNED)
RETURNS VARCHAR(1)
BEGIN
	IF score >= 90 THEN RETURN 'A';
    ELSEIF score >= 80 THEN RETURN 'B';
	ELSEIF score >= 70 THEN RETURN 'C';
	ELSEIF score >= 60 THEN RETURN 'D';
	ELSE RETURN 'E';
    END IF;
END$
DELIMITER ;

CALL getData('sc');

ALTER TABLE sc
ADD grade VARCHAR(1); -- 设置新字段 grade
UPDATE sc SET grade = getGrade(score);



