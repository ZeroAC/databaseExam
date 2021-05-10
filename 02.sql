-- 数据库的备份与还原
-- mysqldump -u 用户名 -p 数据库名 > 备份位置/自定义名.sql
/*
数据库名处 常见选项：
--all-databases, -A： 备份所有数据库
--databases, -B： 用于备份多个数据库，如果没有该选项，mysqldump把第一个名字参数作为数据库名，后面的作为表名。使用该选项，mysqldum把每个名字都当作为数据库名。
--force, -f：即使发现sql错误，仍然继续备份
--host=host_name, -h host_name：备份主机名，默认为localhost
--no-data, -d：只导出表结构
--password[=password], -p[password]：密码
--port=port_num, -P port_num：制定TCP/IP连接时的端口号
--quick, -q：快速导出
--tables：覆盖 --databases or -B选项，后面所跟参数被视作表名
--user=user_name, -u user_name：用户名
*/
-- 若备份所有数据库 则数据库名处写   --all-databases 或 -A

-- 下面在命令行备份数据库
-- mysqldump -u exam -p -A  > ./Desktop/examDatabase/allDataBases.sql
-- 备份多个数据库 jxsk 和 testbase1
-- mysqldump -u exam -p -B jxsk testbase1 > ./Desktop/examDatabase/jx_tb1.sql

-- 删除数据库jxsk和testbase1
DROP DATABASE jxsk ; -- 删除jsxk
DROP DATABASE testbase1 ; -- 删除testbase1

-- 在命令行下导入备份的文件 从而恢复数据库 jxsk和testbase1
-- mysql -u exam -p  < ./Desktop/examDatabase/jxsk.sql