# 实验3 创建表及维护表
## 3.1 创表

> 在数据库 jxsk中创建如下数据表
>
> 教师表：t，学生表 s，课程表：c，选课表 sc，授课表：tc。
>
> 各数据表的结构如下：（其中中文为部分字段的解释，字段名一律使用字母，类型由你自定）
> t（tno教师号，tn姓名，Sex，age，prof职称，sal工资，comm岗位津贴，dept系名）
> s（sno学号，sn姓名，sex,dirthday,dept院系）
> c（cno课程号，cn课程名，time课时数，credit学分，prevCno先行课）
> sc（sno，cno，Score成绩）
> tc（tno，cno，weekday周几，preriod节次，room教室，Eval评价）

### SQL语句:

```mysql
USE jxsk;
-- 创建教师表
CREATE TABLE IF NOT EXISTS t(
	tno VARCHAR(20) PRIMARY KEY comment '教师编号 ',
    tn VARCHAR(10) NOT NULL comment '教师名',
    sex TINYINT(1) UNSIGNED NOT NULL comment '性别 0-女 1-男 Tinyint只占1个字节 性能更高 无符号修饰 0-255',
    age TINYINT comment 'tingint为0~255 符合年龄要求',
    prof VARCHAR(10) comment '教师职称',
    sal INT(7) comment '工资',
    comm INT(7) comment '岗位津贴',
    dept VARCHAR(10) comment '所在系名'
);
-- 创建学生表
CREATE TABLE IF NOT EXISTS s(
	sno VARCHAR(20) PRIMARY KEY comment '学号',
    sn VARCHAR(10) NOT NULL comment '学生名',
    sex TINYINT(1) UNSIGNED NOT NULL comment '性别 0-女 1-男 Tinyint只占1个字节 性能更高 无符号修饰 0-255',
	birthday DATE DEFAULT '2000-01-01' comment '出生日期',
    dept VARCHAR(10) comment '所在系名'
);
-- 创建课程表
CREATE TABLE IF NOT EXISTS c(
	cno VARCHAR(20) PRIMARY KEY COMMENT '课程号',
    cn VARCHAR(20) UNIQUE NOT NULL COMMENT '课程名',
    time TINYINT UNSIGNED COMMENT ' 课时数',
    credit TINYINT UNSIGNED COMMENT '学分',
    prevCno VARCHAR(20) 
);
-- 创建学生选课表
CREATE TABLE IF NOT EXISTS sc(
	sno VARCHAR(20) COMMENT '学生的学号',
    cno VARCHAR(20) COMMENT '该学生选定课程号',
    score TINYINT UNSIGNED DEFAULT 0 COMMENT '该学生该门课的成绩',
    PRIMARY KEY (sno,cno) COMMENT '组合主键 不允许全部相同'
);
-- 创建教师授课表
CREATE TABLE IF NOT EXISTS tc(
	tno VARCHAR(20) COMMENT '教师编号',
    cno VARCHAR(20) COMMENT '课程编号',
    weekday TINYINT(1) UNSIGNED COMMENT '周几上课',
    preriod TINYINT(1) UNSIGNED COMMENT '节次',
    room VARCHAR(20)  COMMENT '教室',
    eval VARCHAR(100) COMMENT '评价', 
    PRIMARY KEY (tno,cno)
);
```

### 运行后的ER图如下：

<img src="https://pic-1256879969.cos.ap-nanjing.myqcloud.com/image-20210510163711886.png" alt="image-20210510163711886" style="zoom: 80%;" />

***

## 3.2 加列

> 向 s表中追加可以存放 20个汉字的学籍（native）列，类型 char(40)不允许为空。

- ### SQL语句:

```mysql
ALTER TABLE s ADD COLUMN native VARCHAR(40) NOT NULL; -- 默认在最后一列添加一列
```

- **拓展**

```mysql
ALTER TABLE s ADD COLUMN dna VARCHAR(40) NOT NULL AFTER sex; -- 设置在sex后添加一列
```

此时学生表`s`的结构为

### 查表结构

```mysql
SHOW  FULL COLUMNS FROM s; -- 查询s的详细表结构
```

![image-20210510171419547](https://pic-1256879969.cos.ap-nanjing.myqcloud.com/image-20210510171419547.png)

***

## 3.3 改列

> 将 native列修改为 Unicode字符类型 nchar的列,宽度仍然是存放 20个汉字。

- ### SQL语句

```mysql
ALTER TABLE s CHANGE COLUMN native native CHAR(40);-- 修改列
-- 拓展 修改t表的性别 改为枚举型 要么男 要么女
ALTER TABLE t CHANGE sex sex ENUM('男','女') NOT NULL;
```
***
## 3.4 删列

> 删除 native列

- ### SQL语句

```mysql
ALTER TABLE s DROP native, DROP dna; -- 拓展 删除多列
```

此时的`s`表结构为：

![image-20210510214505242](https://pic-1256879969.cos.ap-nanjing.myqcloud.com/image-20210510214505242.png)

***

## 3.5 插入数据

>输入下面这些数据，再输入一些自定义数据
>1)交互方式录入一些学生数据：
>s1，赵亦， 女，1995-01-01，计算机
>s2，钱尔， 男，1996-01-10，信息
>s3，张小明,男，1995-12-10，信息
>s4，李思， 男，1995-06-01，自动化
>s5，周武， 男，1994-12-01，计算机
>2)用 SQL命令录入一些教师数据：
>t5，张兰， 女， 39， 副教授,1300，2000， 信息
>t4，张雪， 女， 51， 教授， 1600，3000， 自动化
>t3，刘伟， 男， 30， 讲师， 900， 1200， 计算机
>t2，王平， 男， 28， 教授， 1900，2200， 信息
>t1，李力， 男， 47， 教授， 1500，3000， 计算机
>3)用命令录入一些课程数据：
>c1，程序设计，60，3，null
>c2，微机原理，60，3，c1
>c3，数据库， 90，4，c1
>c5，高等数学,80，4，null

- ### SQL语句

```mysql
-- 向表s录入学生数据 交互式录入
-- 向表t录取教师数据 SQL
INSERT INTO t VALUES ('t5','张兰','女',39,'副教授',1300,2000,'信息'),
('t4','张雪','女',51,'教授',1600,3000,'自动化'),
('t3','刘伟','男',30,'讲师',900,1200,'计算机'),
('t2','王平','男',28,'教授',1900,2200,'信息'),
('t1','李力','男',47,'教授',1500,3000,'计算机');
-- 向表c录入课程数据 SQL
INSERT INTO c VALUES ('c1','程序设计',60,3,null),
('c2','微机原理',60,3,'c1'),
('c3','数据库',90,4,'c1'),
('c5','高等数学',80,4,null);
```

***

## 3.6复制表

> 用 SQL命令再创建一个学生表 stu，结构同 S表

- ### SQL语句

```mysql
-- 复制表结构
SHOW CREATE TABLE s; -- 获取s表的创建语句
CREATE TABLE `stu` ( -- 将获取到的语句 更改表明为复制后的表名 stu
  `sno` varchar(20) NOT NULL COMMENT '学号',
  `sn` varchar(10) NOT NULL COMMENT '学生名',
  `sex` enum('男','女') NOT NULL,
  `birthday` date DEFAULT '2000-01-01' COMMENT '出生日期',
  `dept` varchar(10) DEFAULT NULL COMMENT '所在系名',
  PRIMARY KEY (`sno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
SHOW CREATE TABLE s;
-- 此时表stu的结构同s一样
```

**拓展：完全复制表**`s`

```sql
-- 1.如上步 先复制表结构位stu
-- 2.将表s的数据插入到stu中即可
INSERT INTO stu (SELECT * FROM s); -- 把s表的数据内容也复制到stu
```

***

## 3.7 删除表

> 用 SQL命令删除学生表 stu

- ### SQL语句

```mysql
DROP TABLE stu; -- 删除stu
```

***

***

# 实验4 表及数据操作

## 4.1 更改表数据

> 用命令实现以下操作：
> 1)把学生“周武”的年龄改为 19，系别改为“信息”
> 2)将教师“王平”的职称改为“副教授”
> 3)删除你自已添加的一些数据行或删除周武和王平两行，注意：删除之前请先备份，以便出错后恢复。

- ### SQL语句

```mysql
-- 4.1 修改表内数据 UPDATE 表名 SET 列名1=新值1，列名2=新值2，.. WHERE 筛选条件
SET SQL_SAFE_UPDATES = 0; -- 关闭安全更新模式 确保关闭 才能进行修改
```

#### 4.1.1 把学生“周武”的年龄改为 19，系别改为“信息”

```msyql
UPDATE s SET birthday = '2002-12-01',dept = '信息' WHERE sn='周武';
```

#### 4.1.2 将教师“王平”的职称改为“副教授"

```msysql
UPDATE t SET prof = '副教授' WHERE tn = '王平';
```

#### 4.1.3 除表中数据 DELECT FROM 表 WHERE 条件

```mysql
-- 一旦删除数据，它就会永远消失。因此，在执行DELETE语句之前，应该先备份数据库，以防万一要找回删除过的数据。
-- zeroac@zeroUbuntu:~$ mysqldump -u exam -p jxsk > ./Desktop/examDatabase/before04.sql
DELETE FROM s WHERE sn = '周武';
DELETE FROM t WHERE tn = '王平';
```
***
## 4.2 添加表数据

交互式操作，略，SQL插入数据知识点如下:

```mysql
-- 插单行
INSERT INTO tableName(column1,column2...) 
VALUES (value1,value2,...);

-- 插入所有属性 可省略属性名
INSERT INTO tableName VALUES (value1,value2,...);
-- 插入多行
INSERT INTO tableName(column1,column2...)
VALUES (value1,value2,...),
       (value1,value2,...),
...;
```

***

## 4.3 数据增删改练习1

> 用 SQL命令实现以下操作：
> 1） 向表 T中插入一个教师元组（t6，李红， 女， 30， 副教授,1300，2000， 英语）
> 2） 将“英语”课程的任课教师号修改为“t6”
> 3） 增加年龄字段 age，并计算并填充所有学生的 age字段（用 datediff(year,birthday,getdate()) 计算并填充 age字段）
> 4） 再将所有学生的年龄增加 1岁
> 5） 将“高等数学”课程不及格的成绩修改为 0分
> 6） 将低于总平均分成绩的女同学的成绩提高 5%
> 7） 将“张小明”同学的信息分别从基本表 sc和 s中删除（使用两个 DELETE语句）
> 8） 从基本表 c中删除“张雪”老师的任课信息

#### 4.3.1 向表 T中插入一个教师元组（t6，李红， 女， 30， 副教授,1300，2000， 英语）

```mysql
INSERT INTO t VALUES('t6','李红','女',30,'副教授',1300,2000,'英语');
```

#### 4.3.2 将“英语”课程的任课教师号修改为"t6"

```mysql
UPDATE tc SET tno = 't6' WHERE cno IN (SELECT cno FROM c WHERE cn = '英语');
```

#### 4.3.3 增加年龄字段 age，并计算并填充所有学生的 age字段

```mysql
ALTER TABLE s ADD COLUMN age TINYINT AFTER birthday;
UPDATE s SET age = TIMESTAMPDIFF(YEAR, birthday, CURDATE()); 
```

#### 4.3.4 再将所有学生的年龄增加 1岁

```mysql
UPDATE s SET age = age + 1 ;
```

#### 4.3.5 将“高等数学”课程不及格的成绩修改为 0分

```mysql
INSERT INTO sc VALUES('s1','c5',59),('s2','c5',89),('s4','c5',22);-- 插入几个不及格的成绩
UPDATE sc SET score = 0 WHERE 
(score< 60 AND cno = (SELECT cno FROM c WHERE cn = '高等数学'));
```

#### 4.3.6 将低于总平均分成绩的女同学成绩提高5%  ！！！未完成

```mysql
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


SELECT * FROM sc WHERE (sc.sno,sc.cno) IN (SELECT sno,cno FROM s_avgAS); -- 在sc表中找出低于平均成绩的人
UPDATE sc SET score = 1.05*score WHERE sno IN (SELECT sno FROM s_avgAS) AND cno IN (SELECT cno FROM s_avgAS); -- 将低于总平均分成绩的女同学成绩提高5%
```

#### 4.3.7 将“张小明”同学的信息分别从基本表 sc和 s中删除

```mysql
DELETE FROM s WHERE sn = '张小明';
DELETE FROM sc WHERE sno = 's3';
```

#### 4.3.8 从基本表 c中删除“张雪”老师的任课信息

```mysql
DELETE FROM c WHERE cno IN (SELECT tc.cno FROM  tc JOIN t USING(tno) WHERE tn = '张雪';
```
***

## 4.4 数据增删改练习2

> .用 SQL命令实现以下操作：
> 1)为 tc表添加“Term”字段，表示此授课是针对哪一级学生的第几学期开课的，如：2018级第 5学期开课，则填写 20185
> 2)将 term字段统一填写 20181（表示 2018级第 1期）。
> 3)修改学生选课表 sc，添加 tno，term，grade字段。
> 4)将 term字段统一填写 20181（表示 2018级第 1学期）。
> 5按 score填充 grade,100~90为 A，80以上为 B，70分以上为 C，60分以上为 D，60分以下为 E。

#### 4.4.1 为 tc表添加“Term”字段，表示此授课是针对哪一级学生的第几学期开课的，如：2018级第 5学期开课，则填写 20185

```mysql
ALTER TABLE tc ADD Term VARCHAR(10);

-- 插入时发现数据类型错误 故而把tinyint改为varchar
ALTER TABLE tc CHANGE COLUMN preriod preriod VARCHAR(10); 
```

#### 4.4.2 将 term字段统一填写 20181（表示 2018级第 1期）。

```mysql
UPDATE tc SET term = '20181';
```

#### 4.4.3  修改学生选课表 sc，添加 tno，term，grade字段。

```mysql
ALTER TABLE sc ADD tno VARCHAR(20),
ADD term VARCHAR(10),
ADD grade VARCHAR(20);
```

#### 4.4.4 将 term字段统一填写 20181（表示 2018级第 1期）。

```mysql
UPDATE sc SET term = '20181';
```

#### 4.4.5 按 score填充 grade,100~90为 A，80以上为 B，70分以上为 C，60分以上为 D，60分以下为 E

##### step 1. 创建存储函数，根据分数返回等级

```mysql
-- 按 score填充 grade,100~90为 A，80以上为 B，70分以上为 C，60分以上为 D，60
-- 分以下为 E。

-- 首先定义一个存储函数 来显示输入分数 按照要求输出等级
-- 以下如不设置会出错 具体参考 https://stackoverflow.com/questions/26015160/deterministic-no-sql-or-reads-sql-data-in-its-declaration-and-binary-logging-i
SET GLOBAL log_bin_trust_function_creators = 1; 
DELIMITER $$ -- 设置新的分隔符
CREATE FUNCTION getGrade(score TINYINT UNSIGNED)
RETURNS VARCHAR(1)
BEGIN
	IF score >= 90 THEN RETURN 'A';
    ELSEIF score >= 80 THEN RETURN 'B';
	ELSEIF score >= 70 THEN RETURN 'C';
	ELSEIF score >= 60 THEN RETURN 'D';
	ELSE RETURN 'E';
    END IF;
END$$
DELIMITER ; -- 恢复分隔符

--
```

##### step 2. 调用存储函数 填充grade 

```mysql
UPDATE sc SET grade = getGrade(score);
```

**拓展:若想每次插入成绩时 自动填充grade等级 则可以利用触发器机制**

