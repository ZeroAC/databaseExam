-- 1.1 查询女同学的人数
SELECT COUNT(*) FROM s WHERE sex = '女';
-- 1.2 查询男同学的平均年龄
SELECT AVG(age) FROM s WHERE sex = '男';
-- 1.3 查询男、女同学各有多少人
SELECT COUNT(*) FROM s GROUP BY sex;
-- 1.4 查询年龄大于女同学平均年龄的男学生的姓名和年龄
-- 女同学平均年龄
SELECT AVG(age) FROM s WHERE sex = '女';

SELECT sn,age FROM s WHERE sex = '男' AND age > (SELECT AVG(age) FROM s WHERE sex = '女');

-- 1.5 查询所有学生选修的课程门数
SELECT sno, COUNT(*) '选修门数' FROM sc GROUP BY sno;

-- 1.6 查询每门课程的学生选修人数（只输出超过2人(10人的数据不好造)的课程），要求输出课程号和
-- 课程名及选修人数，查询结果按人数降序排列，若人数相同，按课程号升序排列
SELECT cno,cn, COUNT(*) '选修人数' FROM sc JOIN c USING(cno) GROUP BY cno HAVING 选修人数 > 2
ORDER BY 选修人数 DESC,cno ASC;

-- 1.7 查询只选修了一门课程的学生学号和姓名
SELECT s.sno,s.sn,COUNT(*) '选修门数' FROM s JOIN sc USING(sno) 
GROUP BY sno HAVING 选修门数=1;

-- 1.8 查询至少选修了两门课程的学生学号
SELECT s.sno,s.sn,COUNT(*) '选修门数' FROM s JOIN sc USING(sno) 
GROUP BY sno HAVING 选修门数>=2;

-- 1.9 查询至少讲授两门课程的教师姓名和其所在系
SELECT tno,t.tn,t.dept, COUNT(*) '讲授门数' FROM tc JOIN t USING(tno) 
GROUP BY tno HAVING 讲授门数>=2;

-- 1.10 查询高等数学课程的平均分
SELECT cno,c.cn,AVG(score) FROM sc JOIN c USING(cno)
WHERE c.cn = '高等数学' GROUP BY cno;

-- 1.11 查询每个学生的总分，要求输出学号和分数，并按分数由高到低排列，分数相同时按学号升序排列
SELECT sno,SUM(score) 总分 FROM sc 
GROUP BY sno ORDER BY 总分 DESC, sno ASC; 

-- 1.12 查询各科成绩等级分布情况，即看每门课程 A等多少人、B等多少人
SELECT cno,grade,COUNT(*) FROM sc GROUP BY cno,grade ORDER BY cno;

-- 1.13  统计各科成绩等级分布情况存入新表 statgrade，即看每门课程 A等多少人、B等多少人
CREATE TABLE IF NOT EXISTS statgrade (SELECT cno,grade,COUNT(*) FROM sc GROUP BY cno,grade ORDER BY cno);
SELECT * FROM statgrade;

-- 1.14 统计各科课程号、课程名、选课人数、平均分、最高分、最低分，并存入新表 statscore

CREATE TABLE IF NOT EXISTS statscore SELECT sc.cno,c.cn,COUNT(*),AVG(score),MAX(score),MIN(score) 
FROM sc JOIN c USING(cno) GROUP BY cno;
SELECT * FROM statscore;

