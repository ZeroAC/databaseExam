-- 1.1 查询至少选修课程号为“21”和“41”两门课程的学生的学号
-- 选修了21和41的人的学号
SELECT s1.sno FROM sc s1 JOIN sc s2 ON s1.sno = s2.sno
WHERE s1.cno = '21' AND s2.cno = '41';

-- 1.2 查询选修了“高等数学”或“普通物理”的学生姓名
-- 查找“高等数学”和“普通物理”的课程号
SELECT * FROM c WHERE cn = '高等数学' OR cn = '普通物理';

SELECT s.sn,sc.cno FROM sc JOIN s ON sc.sno = s.sno
WHERE sc.cno IN 
(SELECT c.cno FROM c WHERE cn = '高等数学' OR cn = '普通物理');

-- 1.3 查询选修了王平老师所讲授所有课程的学生的学号和成绩
CALL getData('t');
-- 查找王平老师所教的课的课程号
SELECT tc.cno FROM t JOIN tc ON t.tno = tc.tno
WHERE t.tn = '王平';

-- 查找选修了该课程号的学生成绩
SELECT sc.sno, sc.cno, sc.score FROM sc WHERE sc.cno IN (SELECT tc.cno FROM t JOIN tc ON t.tno = tc.tno
WHERE t.tn = '王平') ;

-- 1.4 查询未选修王老师所讲授任意课程的学生的学号和成绩
SELECT sc.sno, sc.cno, sc.score FROM sc WHERE sc.cno NOT IN (SELECT tc.cno FROM t JOIN tc ON t.tno = tc.tno
WHERE t.tn = '王平');

-- 1.5 查询选修了计算机系教师所讲授的课程的学生姓名和成绩
-- 查询计算机系教师所讲授的课程号
SELECT tc.cno FROM t JOIN tc ON t.tno = tc.tno
WHERE t.dept = '计算机';

-- 根据课程号查学生姓名和成绩
SELECT s.sn,sc.cno,sc.score FROM s JOIN sc ON s.sno = sc.sno
WHERE sc.cno IN (SELECT tc.cno FROM t JOIN tc ON t.tno = tc.tno
WHERE t.dept = '计算机');

-- 1.6 查询学号比“张小明”同学大而年龄比他小的学生姓名

-- 把张小明和其它同学的信息比较
SELECT * FROM s s1 JOIN s s2 ON s1.sn = '张小明' AND s2.sn <> '张小明';

SELECT s1.sn,s1.age,s2.sn,s2.age FROM s s1 JOIN s s2 ON s1.sn = '张小明' AND s2.sn <> '张小明'
WHERE s2.sno > s1.sno AND s2.age < s1.age;

-- 1.7 查询年龄大于所有女同学年龄的男学生的姓名和年龄
SELECT * FROM s WHERE sex = '男' AND 
age > (SELECT MAX(age) FROM s WHERE sex = '女'); 

-- 1.8 查询未选修“高等数学”的学生的学号和姓名
-- 选修了高等数学的学号
SELECT sno FROM c JOIN sc USING(cno)
WHERE c.cn = '高等数学';
-- 
SELECT sno, sn FROM s WHERE 
sno NOT IN (SELECT sno FROM c JOIN sc USING(cno)
WHERE c.cn = '高等数学');

-- 1.9 查询不是计算机系教师所讲授的课程的课程名和课程号
-- 查询计算机系老师讲的课程号
SELECT tc.cno FROM t JOIN tc USING(tno)
WHERE dept = '计算机';

SELECT cno, cn FROM c WHERE cno NOT IN(SELECT tc.cno FROM t JOIN tc USING(tno)
WHERE dept = '计算机');

-- 1.10 查询未选修“21”号课程的学生的学号和姓名
-- 选修了21课的学生学号
SELECT sno FROM sc WHERE sc.cno = '21';

SELECT sno,sn FROM s WHERE 
sno NOT IN (SELECT sno FROM sc WHERE sc.cno = '21');

-- 1.11 从学生表和教师表可以了解到哪些院系名称
(SELECT  dept FROM s)
UNION 
(SELECT  dept FROM t);
-- 1.12 查询哪些学生所选的课程是由本院系的教师教的，列举学生姓名、课程名和教师名
-- 根据学号查部门
SELECT sno,sn,dept FROM s;

-- 根据课程号查是哪个系的老师教的 并显示课程名
SELECT c.cn,tt.dept,tt.tn FROM c JOIN 
(SELECT tc.cno, t.tn, dept FROM t JOIN tc USING(tno)) tt USING(cno);

-- 根据院系相同来连接两个结果表
SELECT a.sn, b.cn, b.tn,dept FROM (SELECT sno,sn,dept FROM s) a
JOIN (SELECT c.cn,tt.dept,tt.tn FROM c JOIN 
(SELECT tc.cno, t.tn, dept FROM t JOIN tc USING(tno)) tt USING(cno)) b USING(dept);




-- 1.13 如果在同一个班上课就认定为同学，请列举所有可能的同学关系，至少包含三列：学生姓名、同学姓名、共同课程名

-- 列出每个课都那些人选了
CREATE OR REPLACE VIEW cn_cno AS
(SELECT c.cn,sc.sno FROM sc JOIN c USING(cno) ORDER BY c.cn);

SELECT * FROM cn_cno;

-- 自连接查询所有同学关系
SELECT cc1.cn,cc1.sno sno1, cc2.sno sno2  FROM cn_cno cc1 JOIN cn_cno cc2 USING(cn)
WHERE cc1.sno <> cc2.sno ORDER BY cn,cc1.sno;

-- 查询两个人姓名学号
SELECT s1.sno,s1.sn,s2.sno,s2.sn FROM s s1 JOIN s s2 WHERE s1.sno = 's1' AND s2.sno = 's2';

SELECT tt.cn,s1.sno,s1.sn,s2.sno,s2.sn FROM s s1 JOIN s s2 JOIN (SELECT cc1.cn,cc1.sno sno1, cc2.sno sno2  FROM cn_cno cc1 JOIN cn_cno cc2 USING(cn)
WHERE cc1.sno <> cc2.sno ORDER BY cn,cc1.sno) tt 
WHERE s1.sno = tt.sno1 AND s2.sno = tt.sno2 ORDER BY tt.cn,s1.sn,s2.sn;

SELECT * FROM jxsk.c;
-- 1.14 由于课程有上下承接关系，请列举课程先后关系，必须先上的在前，后上的在后，无承接关系的不列举
SELECT * FROM c ORDER BY (
CASE prevCno
WHEN NULL THEN 0
WHEN 'c6' THEN 3
WHEN 'c5' THEN 2
ELSE 1
END
) ASC;