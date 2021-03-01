create user winning@'172.%.%.%' identified by 'Maria@win60.DB';
grant all privileges on *.* to winning@'172.%.%.%' identified by 'Maria@win60.DB';
flush privileges;
create user winning@'192.%.%.%' identified by 'Maria@win60.DB';
grant all privileges on *.* to winning@'172.%.%.%' identified by 'Maria@win60.DB';
flush privileges;
create user root@'172.%.%.%' identified by '11';
grant all privileges on *.* to root@'172.%.%.%' identified by '11';
flush privileges;
create user root@'192.%.%.%' identified by '11';
grant all privileges on *.* to root@'172.%.%.%' identified by '11';
flush privileges;


CREATE DATABASE `cdp`  DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci ;

CREATE DATABASE `cdp_dev`  DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci ;

CREATE DATABASE `cloud`  DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin ;

CREATE DATABASE `pmph`  DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
