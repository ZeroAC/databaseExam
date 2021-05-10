/*
事务： 原子性 一致性 隔离性 持久化
*/
CALL getData('sc');
START TRANSACTION;
UPDATE sc SET score = score + 1 WHERE sno='s1'; 
COMMIT;

SHOW VARIABLES LIKE '%transaction%';




-- 总结
-- 1.read uncommitted 此时事务会读到另外一个事务未提交的数据 也就是【脏读】 
-- 解决方法: 设为 read committed 只会读到已提交的数据
-- 2.read commiteed 也会产生问题 比如事务A查询了两次score 但在此过程中 另外一个事务修改了并提交了score 导致A的两次查询结果不一致 也就是产生 不可重复读的问题
-- 解决方法: 设为repeatable read 可重复读 保证每次读到的都是事务刚开启时的数据 如有更新则不显示
-- 3.repeatable read 也会产生问题 如果在事务A 向根据score来发钱 但事务B突然改了score并提交 那么事务A依然是根据旧的分数来发钱 也就是幻读的问题
-- 解决方法：设为serializable 序列化 也就是串行 一个事务读写完毕后才能进行其它事务的读写
-- 4.serializable 会丧失并发性 完全的串行