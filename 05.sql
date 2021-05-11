-- -----------实验五---------------
CALL getData('sc');
-- 1 用SQL命令实现以下操作
-- 1.1 查询计算机系的所有教师
SELECT * FROM t WHERE dept = '计算机';
-- 1.2 查询所有女同学的姓名，年龄
SELECT sn,age FROM s WHERE sex = '女';
-- 1.3 查询计算机系教师开设的所有课程的课程号和课程名
SELECT tno FROM t WHERE dept = '计算机';

SELECT * FROM tc 
WHERE tc.tno IN (SELECT tno FROM t WHERE dept = '计算机');



SELECT tc.tno,tc.cno, c.cn FROM tc JOIN c ON tc.cno = c.cno
WHERE tc.tno IN (SELECT tno FROM t WHERE dept = '计算机');
-- 1.4 查询年龄在 18~20岁（包括 18和 20）之间的所有学生的信息
UPDATE s SET age = 19 WHERE sno = 's5' or sno = 's6';

SELECT * FROM s WHERE age BETWEEN 18 AND 20;
-- 1.5 查询年龄小于 20岁的所有男同学的学号和姓名
INSERT INTO `jxsk`.`s` (`sno`, `sn`, `sex`, `birthday`, `age`, `dept`) VALUES ('s7', '王伟', '男', '2003-03-04', '18', '信息');
INSERT INTO `jxsk`.`s` (`sno`, `sn`, `sex`, `birthday`, `age`, `dept`) VALUES ('s8', '李胡', '男', '2004-01-20', '17 ', '自动化');
SELECT sno, sn FROM s WHERE age < 20 AND sex = '男';
-- 1.6 查询姓“李”的所有学生的姓名、年龄和性别
SELECT sn,age,sex FROM s WHERE sn LIKE '李%';
-- 1.7 查询所有女同学所选课程的课程号
SELECT s.sn,s.sex,sc.cno FROM s JOIN sc ON sc.sno = s.sno
WHERE s.sex = '女';
-- 1.8 查询至少有一门成绩高于 90分的学生姓名和年龄
SELECT s.sn,s.age,MAX(sc.score) FROM s JOIN sc ON s.sno = sc.sno
GROUP BY sc.sno HAVING MAX(sc.score) > 90; 

-- 1.9 查询选修“微机原理”的所有学生的姓名和成绩
SELECT s.sn, sc.score FROM s JOIN sc ON s.sno = sc.sno
WHERE sc.cno = (SELECT cno FROM c WHERE cn = '微机原理');

-- 1.10 试算所有“数据库”成绩统一增加 10%后（超过 100分按 100计算），全班平均分是多少？

INSERT INTO `jxsk`.`sc` (`sno`, `cno`, `score`, `grade`) VALUES ('s1', 'c3', '70', 'C');
INSERT INTO `jxsk`.`sc` (`sno`, `cno`, `score`, `grade`) VALUES ('s2', 'c3', '80', 'B');
INSERT INTO `jxsk`.`sc` (`sno`, `cno`, `score`, `grade`) VALUES ('s4', 'c3', '40', 'E');
INSERT INTO `jxsk`.`s` (`sno`, `sn`, `sex`, `birthday`, `age`, `dept`) VALUES ('s10', 'lili', '男', '1993-07-01', '22', '计算机');
INSERT INTO `jxsk`.`sc` (`sno`, `cno`, `score`, `grade`) VALUES ('s10', 'c3', '80', 'B');

-- 查找数据库的课程编号
SELECT cno FROM c WHERE cn = '数据库';
-- 数据库的全班平均成绩
SELECT dept,AVG(sc.score*1.1) FROM s JOIN sc ON s.sno = sc.sno WHERE sc.cno = (SELECT cno FROM c WHERE cn = '数据库')
GROUP BY dept;

-- 1.11试算所有“数据结构”成绩 60分以下的统一增加 10分后，仍有多少人不及格。
-- 查询选修了数据结构这门课的学号和成绩
SELECT COUNT(*) '仍不及格人数' FROM c JOIN sc ON c.cno = sc.cno
WHERE c.cn = '数据结构' AND sc.score+10 < 60;






