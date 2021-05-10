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

-- 修改 s表 的表结构

-- 添加新列
ALTER TABLE s ADD COLUMN native VARCHAR(40) NOT NULL; -- 默认在最后一列添加一列
ALTER TABLE s ADD COLUMN dna VARCHAR(40) NOT NULL AFTER sex; -- 设置在sex后添加一列

CALL getFT('s'); -- 查看表s的结构
CALL getData('s'); -- 查看表s的数据


-- 改变原有的列：
-- ALTER TABLE s CHANGE COLUMN 列名 新列表 新属性

ALTER TABLE s CHANGE COLUMN native nat CHAR(40);

CALL getData('s'); -- 查看表s的数据

-- 删除列
ALTER TABLE s DROP nat, DROP dna;

-- 修改s表的性别 改为枚举型 要么男 要么女
ALTER TABLE s CHANGE sex sex ENUM('男','女') NOT NULL;

-- 交互方式向s表添加数据 先显示出当前的数据 然后在结果表中双击即可填写数据
SELECT * FROM s;
/*
数据内容为
s1，赵亦， 女，1995-01-01，计算机
s2，钱尔， 男，1996-01-10，信息
s3，张小明,男，1995-12-10，信息
s4，李思， 男，1995-06-01，自动化
s5，周武， 男，1994-12-01，计算机
*/




-- 命令的方式向表t插入数据
-- INSERT INTO 表名(列名1，列名2，..) VALUES(值1，值2，..)
-- 若对所有列赋值 则可省略表名后的东西
SELECT * FROM t;
-- 修改t表的性别 改为枚举型 要么男 要么女
ALTER TABLE t CHANGE sex sex ENUM('男','女') NOT NULL;
/*
数据内容为
t5，张兰， 女， 39， 副教授,1300，2000， 信息
t4，张雪， 女， 51， 教授， 1600，3000， 自动化
t3，刘伟， 男， 30， 讲师， 900， 1200， 计算机
t2，王平， 男， 28， 教授， 1900，2200， 信息
t1，李力， 男， 47， 教授， 1500，3000， 计算机
*/
INSERT INTO t VALUES('t5','张兰','女',39,'副教授',1300,2000,'信息');
INSERT INTO t VALUES('t4','张雪','女',51,'教授',1600,3000,'自动化');
INSERT INTO t VALUES('t3','刘伟','男',30,'讲师',900,1200,'计算机');
INSERT INTO t VALUES('t2','王平','男',28,'教授',1900,2200,'信息');
INSERT INTO t VALUES('t1','李力','男',47,'教授',1500,3000,'计算机');
CALL getData('t');

-- 命令录入一些课程数据c表

/*
c1，程序设计，60，3，null
c2，微机原理，60，3，c1
c3，数据库， 90，4，c1
c5，高等数学,80，4，null
*/
CALL getFT('c');
INSERT INTO c VALUES ('c1','程序设计',60,3,null),('c2','微机原理',60,3,'c1'),
('c3','数据库',90,4,'c1'),('c5','高等数学',80,4,null);
CALL getData('c');

-- 复制表
SHOW CREATE TABLE s; -- 获取s表的创建语句

CREATE TABLE `stu` ( -- 将获取到的语句 更改表明为复制后的表名 stu
  `sno` varchar(20) NOT NULL COMMENT '学号',
  `sn` varchar(10) NOT NULL COMMENT '学生名',
  `sex` enum('男','女') NOT NULL,
  `birthday` date DEFAULT '2000-01-01' COMMENT '出生日期',
  `dept` varchar(10) DEFAULT NULL COMMENT '所在系名',
  PRIMARY KEY (`sno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CALL getData('stu'); -- 查看复制后的表的内容 
INSERT INTO stu (SELECT * FROM s); -- 把s表的数据内容也复制到stu

DROP TABLE stu; -- 删除stu


















-- 查看表的结构
DESC s; -- 等价于 SHOW COLUMNS FROM s; 简要表结构
SHOW FULL COLUMNS FROM s; -- 显示完整的表结构 包括注释
SHOW FULL COLUMNS FROM sc;

SHOW CREATE TABLE s;
delimiter $
CREATE PROCEDURE getFT(IN target VARCHAR(20))
BEGIN
	SHOW FULL COLUMNS FROM target;
END$
delimiter ;
-- CALL getFT(sc); 报错 识别不出sc为表名
-- DROP PROCEDURE getFT; 删除存储过程

/*
如何将表明作为参数呢 若这样直接写是不行的
CREATE PROCEDURE getFT(IN target VARCHAR(20)) -- 传入表target 输出该表的详细信息
BEGIN
	SHOW FULL COLUMNS FROM target
END$


正解:
只需要把SHOW FULL COLUMNS FROM target 替换为
SET @STMT =CONCAT("SHOW FULL COLUMNS FROM ",target,";"); 
PREPARE stmt FROM @STMT; 
EXECUTE stmt; 
DEALLOCATE PREPARE stmt;
*/
delimiter $
CREATE PROCEDURE getFT(IN target VARCHAR(20)) -- 传入表target 输出该表的详细信息
BEGIN
	SET @STMT =CONCAT("SHOW FULL COLUMNS FROM ",target,";"); 
	PREPARE stmt FROM @STMT; 
	EXECUTE stmt; 
    DEALLOCATE PREPARE stmt;
END$
delimiter ;
CALL getFT('sc');

delimiter $
CREATE PROCEDURE getData(IN target VARCHAR(20)) -- 传入表target 输出该表保存的数据
BEGIN
	SET @STMT =CONCAT("SELECT * FROM ",target,";"); 
	PREPARE stmt FROM @STMT; 
	EXECUTE stmt; 
    DEALLOCATE PREPARE stmt;
END$
delimiter ;