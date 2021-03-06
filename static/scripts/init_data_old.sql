USE cloudminer;

DELETE FROM worker_stats WHERE id BETWEEN 1 AND 8;
DELETE FROM worker WHERE id BETWEEN 1 AND 3;
DELETE FROM miner WHERE id BETWEEN 1 AND 6;
DELETE FROM currency WHERE id BETWEEN 1 AND 4;
DELETE FROM machine WHERE id BETWEEN 1 AND 4;
DELETE FROM platform WHERE id BETWEEN 1 AND 2;
DELETE FROM pool WHERE id BETWEEN 1 AND 4;
DELETE FROM auth_membership WHERE id BETWEEN 1 AND 1;
DELETE FROM auth_event WHERE id BETWEEN 1 AND 3;
DELETE FROM auth_group WHERE id BETWEEN 1 AND 1;
DELETE FROM auth_user WHERE id BETWEEN 1 AND 1;

-- password para el usuario 'tomas' es 'tomas'
INSERT INTO `auth_user` 
VALUES 
	(1,'Tomás','Restrepo','tomas@tomas.com','pbkdf2(1000,20,sha512)$aebb22315f01cfa8$8457bf0590788f65ad0568f09a13f57ece77f852','','','');

INSERT INTO `auth_group` VALUES (1,'user_1','Grupo asignado únicamente al usuario 1');

INSERT INTO `auth_event`
VALUES 
	(1,'2014-03-27 20:41:51','127.0.0.1',NULL,'auth','Group 1 created'),
	(2,'2014-03-27 20:41:51','127.0.0.1',1,'auth','User 1 Registered'),
	(3,'2014-03-27 22:45:36','127.0.0.1',1,'auth','User 1 Logged-in');

INSERT INTO `auth_membership` VALUES (1,1,1);


INSERT INTO `pool` (id,name,webpage,account_email,account_ID)
VALUES 
	(1,'benchmark','-','-','-'),
	(2,'Slush_s pool','http://mining.bitcoin.cz','cloudminer.ucm@gmail.com','cloudminer'),
	(3,'Mine-Litecoin','https://mine-litecoin.com','nilksermot@gmail.com','cloudminer'),
	(4,'BTC guild','https://www.btcguild.com','cloudminer.ucm@gmail.com','cloudminer');

INSERT INTO `platform` 
VALUES 
	(1,'Linux','LinuxMint','32bit','13'),
	(2,'Windows','unique','64bit','8');

INSERT INTO `machine` (id,name,ip,port,platform_id,alive)
VALUES 
	(1,'VM tomas','88.23.71.197','12345',1,'F'),
	(2,'tomas-virtual-machine','0.0.0.0','37940',1,'F'),
	(3,'test','111','111',1,'F'),
	(4,'Tom-PC','0.0.0.0','65332',2,'F');

INSERT INTO `currency` (id,name,name_short)
VALUES 
	(1,'BitCoin','BTC'),
	(2,'LiteCoin','LTC'),
	(3,'NovaCoin','NVC'),
	(4,'TerraCoin','TRC');

INSERT INTO `miner` (id,name,version,platform_id,command_line,currency_id, pool_id)
VALUES 
	(1,'minerd','2.3.2',1,'../Miners/minerd_2.3.2_linux32/minerd -a sha256d --benchmark',1,1),
	(2,'minerd','2.3.2',1,'../Miners/minerd_2.3.2_linux32/minerd -a sha256d -o stratum+tcp://stratum.bitcoin.cz:3333 -O cloudminer.worker1:9868UyAN',1,2),
	(3,'minerd','2.3.2',1,'../Miners/minerd_2.3.2_linux32/minerd -a scrypt -o stratum+tcp://europe.mine-litecoin.com -O cloudminer.worker1:x',2,3),
	(4,'minerd','2.3.2',2,'../Miners/minerd_2.3.2_win64/minerd.exe -a sha256d --benchmark',1,1),
	(5,'minerd','2.3.2',2,'../Miners/minerd_2.3.2_win64/minerd.exe -a sha256d -o stratum+tcp://stratum.bitcoin.cz:3333 -O cloudminer.worker1:9868UyAN',1,2),
	(6,'minerd','2.3.2',2,'../Miners/minerd_2.3.2_win64/minerd.exe -a scrypt -o stratum+tcp://europe.mine-litecoin.com -O cloudminer.worker1:x',2,3);

INSERT INTO `worker` (id,machine_id,miner_id,time_start,time_stop)
VALUES 
	(1,1,1,'2014-03-27 22:47:22','2014-03-30 13:44:00'),
	(2,2,1,'2014-03-30 13:35:47','2014-03-30 13:44:00'),
	(3,2,1,'2014-03-30 14:06:59','2014-03-30 14:16:11');

INSERT INTO `worker_stats` (id,worker_id,hash_rate,timestamp)
VALUES 
	(1,1,6,'2014-03-30 13:35:49'),
	(2,1,6,'2014-03-30 13:35:54'),
	(3,1,5,'2014-03-30 13:35:59'),
	(4,1,6,'2014-03-30 13:36:04'),
	(5,2,5,'2014-03-30 13:36:09'),
	(6,2,6,'2014-03-30 14:07:01'),
	(7,2,5,'2014-03-30 14:07:06'),
	(8,2,6,'2014-03-30 14:07:11');
