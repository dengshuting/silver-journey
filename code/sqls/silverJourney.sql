drop table if exists orderform;
drop table if exists session;
drop table if exists film_comment;
drop table if exists cinema_comment;
drop table if exists cinema_film_rlt;
drop table if exists cinema;
drop table if exists soundtrack;
drop table if exists preview;
drop table if exists picture;
drop table if exists film;
drop table if exists actor;
drop table if exists user;

/*==============================================================*/
/* 用户表                                                        */
/*==============================================================*/
create table user
(
   id                   bigint not null auto_increment,
   username             varchar(20) not null,
   password             varchar(50) not null,
   email                varchar(50) default null,
   sex                  int default 0,    /*0:男 1:女*/
   type                 int default 0,    /*0:普通用户*/
   create_time          timestamp not null default CURRENT_TIMESTAMP,
   primary key (id)
) character set = utf8mb4;

/*==============================================================*/
/* 演员表                                                        */
/*==============================================================*/
create table actor
(
   id                   bigint not null auto_increment,
   name                 varchar(20) not null,
   picture              varchar(200) default null,
   description          varchar(1000) default null,
   primary key (id)
) character set = utf8mb4;


/*==============================================================*/
/* 电影表                                                        */
/*==============================================================*/
create table film
(
   id                   bigint not null auto_increment,
   name_cn              varchar(100) default null,       /*中文名*/
   name_en              varchar(100) default null,       /*英文名*/
   director             varchar(20) default null,
   actors               varchar(5000) default null,      /*演员列表，json格式*/
   types                varchar(200) default null,       /*类型(动作、科幻等)列表，json格式*/
   duration             int default null,                /*时长，分钟数*/
   slogan               varchar(100) default null,       /*一句话简介*/
   description          varchar(3000) default null,      /*剧情介绍*/
   score                float default 5.0,
   country              varchar(20) default null,        /*来源国家*/
   language             varchar(100) default null,       /*语言列表，json格式*/
   on_date              timestamp not null default CURRENT_TIMESTAMP, /*上映时间*/
   primary key (id)
) character set = utf8mb4;

/*==============================================================*/
/* 电影图片表                                                     */
/*==============================================================*/
create table picture
(
   id                   bigint not null auto_increment,
   film_id              bigint not null,
   posters              varchar(200) default null,    /*海报url列表，json格式*/
   hd_still             varchar(200) default null,    /*高清剧照url*/
   stills               varchar(3000) default null,   /*剧照url列表，json格式*/
   primary key (id),
   constraint FK_film_id_pic foreign key (film_id) references film(id)
) character set = utf8mb4;

/*==============================================================*/
/* 电影预告片表                                                   */
/*==============================================================*/
create table preview
(
   id                   bigint not null auto_increment,
   film_id              bigint not null,
   url                  varchar(200) default null,    /*一个预告片的url*/
   primary key (id),
   constraint FK_film_id_prv foreign key (film_id) references film(id)
) character set = utf8mb4;

/*==============================================================*/
/* 电影原声表                                                     */
/*==============================================================*/
create table soundtrack
(
   id                   bigint not null auto_increment,
   film_id              bigint not null,              
   url                  varchar(200) default null,    /*一个原声的url*/
   primary key (id),
   constraint FK_film_id_sdtk foreign key (film_id) references film(id)
) character set = utf8mb4;

/*==============================================================*/
/* 电影院表                                                       */
/*==============================================================*/
create table cinema
(
   id                   bigint not null auto_increment,
   name                 varchar(50) default null,
   picture              varchar(200) default null,
   address              varchar(500) default null,    /*用于显示的地址*/
   location             varchar(500) default null,    /*用于定位的位置信息*/
   telephone            varchar(20) default null,
   score                float default 5.0,
   service              varchar(100)  default null,   /*提供的服务(退票，3D眼镜)列表*/
   primary key (id)
) character set = utf8mb4;

/*==============================================================*/
/* 电影院与电影的关系表                                            */
/*==============================================================*/
create table cinema_film_rlt
(
   id                   bigint not null auto_increment,
   cinema_id            bigint not null,
   film_id              bigint not null,
   primary key (id),
   constraint FK_film_id_rlt foreign key (film_id) references film(id),
   constraint FK_cimema_id foreign key (cinema_id) references cinema(id)
) character set = utf8mb4;

/*==============================================================*/
/* 电影院评论表                                                   */
/*==============================================================*/
create table cinema_comment
(
   id                   bigint not null auto_increment,
   cinema_id            bigint not null,
   user_id              bigint not null,
   score                float default 10.0,
   content              varchar(2000) default null,
   like_number          int default 0,
   dislike_number       int default 0,
   primary key (id),
   constraint FK_cinema_id foreign key (cinema_id) references cinema(id),
   constraint FK_user_id_cc foreign key (user_id) references user(id)
) character set = utf8mb4;

/*==============================================================*/
/* 电影院评论表                                                   */
/*==============================================================*/
create table film_comment
(
   id                   bigint not null auto_increment,
   film_id              bigint not null,
   user_id              bigint not null,
   score                float default 10.0,
   content              varchar(2000) default null,
   like_number          int default 0,
   dislike_number       int default 0,
   primary key (id),
   constraint FK_user_id_fc foreign key (user_id) references user(id),
   constraint FK_film_id_cmt foreign key (film_id) references film(id)
) character set = utf8mb4;

/*==============================================================*/
/* 电影的场次表                                                   */
/*==============================================================*/
create table session
(
   id                   bigint not null auto_increment,
   cinema_film_rlt_id   bigint not null,
   session_date                 timestamp not null default CURRENT_TIMESTAMP,   /*场次日期*/
   start_time           time default null,                  /*场次开始时间*/
   end_time             time default null,                  /*场次结束时间*/
   occupied_seats       varchar(3000) default null,         /*已选座位*/
   video_hall_name      varchar(20) default null,           /*放映厅名*/
   price                int default null,                   /*单位是分，如32.8元，则存为3280*/
   version_lang         varchar(20) default null,           /*语言(中文、英文等)*/
   version_view         varchar(20) default null,           /*2D或3D*/
   primary key (id),
   constraint FK_cinema_film_rlt_id foreign key (cinema_film_rlt_id) references cinema_film_rlt(id)
) character set = utf8mb4;

/*==============================================================*/
/* 订单表                                                        */
/*==============================================================*/
create table orderform
(
   id                   bigint not null auto_increment,
   session_id           bigint not null,
   user_id              bigint not null,
   seats                varchar(1000) default null,         /*选择的座位列表，一个订单可选多个座位*/
   telephone            varchar(20) default null,           /*取票手机号码*/
   primary key (id),
   constraint FK_session_id foreign key (session_id) references session(id),
   constraint FK_user_id_order foreign key (user_id) references user(id)
) character set = utf8mb4;




/*=====*/
/*=测试=*/
/*=====*/


/*==============================================================*/
/* 插入                                                          */
/*==============================================================*/
-- 用户
insert into user (username, password, email, sex, type)
            values('吴傲天', '123', 'wat@1.com', 1, 0);
insert into user (username, password)
            values('mgz', '123');
-- 演员
insert into actor (name, picture, description)
            values('范·迪塞尔', 'pic/fan.png', 'good');
insert into actor (name)
            values('道恩·强森');
insert into actor (name)
            values('周星驰');
insert into actor (name)
            values('朱茵');          
-- 电影
insert into film (name_cn, name_en, director, actors, types, duration, slogan, description, score, country, language, on_date)
            values('速度与激情8', 'The Fate of the Furious', 'F·加里·格雷', 
               '[{"id": "1","rolename": "多米尼克·托莱多"},{"id": "2","name": "卢克·霍布斯"}]',
               '["动作", "剧情","惊悚","犯罪"]', 120, "硬汉豪车再纵横，依旧燃爆荷尔蒙",
               '该片讲述了神秘冷艳的黑科技高手赛弗的出现，导致多米尼克心里叛变，直接使整个飞车家族陷入危险境地的故事。', 
               '9.1', '法国', '["英语","国语"]', "2017-04-14");
insert into film (name_cn, name_en, director, actors, types, duration, slogan, description, score, country, language, on_date)
            values('大话西游之大圣娶亲', 'A Chinese Odyssey Part Two - Cinderella', '刘镇伟', 
               '[{"id": "3","rolename": "至尊宝"},{"id": "4","name": "紫霞仙子"}]',
               '["动作", "剧情","惊悚","犯罪"]', 120, "从一世到一生，大圣提前娶妻",
               '至尊宝被月光宝盒带回到五百年前，遇见紫霞仙子，被对方打上烙印成为对方的人，并发觉自己已变成孙悟空。
               紫霞与青霞本是如来佛祖座前日月神灯的灯芯（白天是紫霞，晚上是青霞），二人虽然同一肉身却仇恨颇深，
               因此紫霞立下誓言，谁能拔出她手中的紫青宝剑，谁就是她的意中人。紫青宝剑被至尊宝于不经意间拔出，
               紫霞决定以身相许，却遭一心记挂白晶晶的至尊宝拒绝。后牛魔王救下迷失在沙漠中的紫霞，并逼紫霞与他成婚，
               关键时刻，至尊宝现身。', 
               '9.0', '中国香港', '["国语","粤语"]', "2017-04-13");
-- 电影图片（海报 高清剧照 剧照列表）
insert into picture (film_id, posters, hd_still, stills)
            values('1', 'pic/1.png', 'pic/2.png', '["pic/3.png", "pic/4.png"]');
-- 预告片
insert into preview (film_id, url)
            values('1', 'someurl');
-- 电影原声
insert into soundtrack (film_id, url)
            values('1', 'someurl');
-- 电影院
insert into cinema (name, picture, address, location, telephone, score, service)
            values('金逸珠江国际影城广州大学店', 'pic/1.png', '番禺区小谷街道贝岗村中二横路1号GOGO新天地商业广场二期二楼',
                   '用于定位', '020-39340185', '7.9', '["3D眼镜", "休息区"]');
insert into cinema (name, picture, address, location, telephone, score, service)
            values('广州白云万达电影城', 'pic/1.png', '白云区云城东路503号白云万达广场3楼',
                   '用于定位', '020-36689666', '7.0', '["3D眼镜", "退票"]');
-- 影院-电影关系
insert into cinema_film_rlt (cinema_id, film_id)
            values('1', '1');
insert into cinema_film_rlt (cinema_id, film_id)
            values('1', '2');
insert into cinema_film_rlt (cinema_id, film_id)
            values('2', '1');
-- 影院评价
insert into cinema_comment (cinema_id, user_id, score, content)
            values('1', '1', '9.0', '好');
-- 电影评价
insert into film_comment (film_id, user_id, score, content)
            values('1', '2', '8.0', '不错');
-- 场次
insert into session (cinema_film_rlt_id, session_date, start_time, end_time, occupied_seats, video_hall_name, price, version_lang, version_view)
                           values('1', '2017-4-15', '16:30:00', '18:30:00', '["3,5", "3,6", "4,5", "4,6"]',
                              '3号厅', '3180', '英语', '3D');
insert into session (cinema_film_rlt_id, session_date, start_time, end_time, occupied_seats, video_hall_name, price, version_lang, version_view)
                           values('1', '2017-4-15', '19:00:00', '21:00:00', '["3,5", "3,6", "4,5", "4,6"]',
                              '4号厅', '3280', '英语', '3D');
insert into session (cinema_film_rlt_id, session_date, start_time, end_time, occupied_seats, video_hall_name, price, version_lang, version_view)
                           values('2', '2017-4-16', '19:00:00', '21:00:00', '["3,5", "3,6", "4,5", "4,6"]',
                              '4号厅', '3280', '英语', '2D');
insert into session (cinema_film_rlt_id, session_date, start_time, end_time, occupied_seats, video_hall_name, price, version_lang, version_view)
                           values('3', '2017-4-16', '18:00:00', '20:00:00', '["3,5", "3,6", "4,5", "4,6"]',
                              '4号厅', '3380', '英语', '2D');
-- 订单
insert into orderform (session_id, user_id, seats, telephone)
               values('1', '1', '["6, 6"]', '18888888888');


/*==============================================================*/
/* 更改                                                          */
/*==============================================================*/
-- 电影评论点赞
set SQL_SAFE_UPDATES = 0;
update film_comment set like_number = like_number + 1;


/*==============================================================*/
/* 删除                                                          */
/*==============================================================*/
-- 过时场次
insert into session (cinema_film_rlt_id, session_date)
            values('1', '2017-1-15');
delete from session where date(session_date) < '2017-2-1';


/*==============================================================*/
/* 查询                                                          */
/*==============================================================*/
-- 某个影院的所有电影
select film.* from film, cinema_film_rlt as r 
      where r.cinema_id = '1' and r.film_id = film.id;

-- 播放某部电影的所有影院
select cinema.* from cinema, cinema_film_rlt as r
      where r.film_id = '1' and r.cinema_id = cinema.id;

-- 某个电影的所有评论
select * from film_comment where film_id = '1';

-- 某个影院的所有评论
select * from cinema_comment where cinema_id = '1';

-- 正在热映的电影（已经上映）
select * from film where date(on_date) <= curdate();

-- 即将上映电影
select * from film where date(on_date) > curdate();

-- 某部电影 某个影院 某天 的所有场次
select session.* from cinema_film_rlt as r, session
      where r.cinema_id = '1' and r.film_id = '1' and date(session.session_date) = '2017-04-15'
      and r.id = session.cinema_film_rlt_id;

-- 某部电影 某个影院 某天 的所用场次的最低价
select min(session.price) from cinema_film_rlt as r, session
      where r.cinema_id = '1' and r.film_id = '1' and date(session.session_date) = '2017-04-15'
      and r.id = session.cinema_film_rlt_id;

-- 播放某部电影的影院 按评分排序
select cinema.* from cinema_film_rlt as r, cinema 
         where r.film_id = '1' and cinema.id = r.cinema_id 
         order by cinema.score desc;










