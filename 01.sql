/*
   1. mysql的开启与关闭 新建用户
*/
-- 查看mysql服务是否开启 ps -aux | grep mysqld
-- 开启服务 service mysql start
-- 关闭服务 service mysql stop

/*
 2 查看系统数据库的物理文件位置
*/
show global variables like "%datadir%"; -- 可找到数据库的保存位置

/*
 3 4 交互式创建数据库
*/

/*
5 命令创建数据库
*/
CREATE DATABASE IF NOT EXISTS testbase1;