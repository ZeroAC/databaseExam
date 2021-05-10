# 实验3
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

## 3.7 删除表

> 用 SQL命令删除学生表 stu

- ### SQL语句

```mysql
DROP TABLE stu; -- 删除stu
```

