drop table if exists shares;
create table shares (
  id integer primary key autoincrement,
  user text not null,
  share text not null,
  created integer not null,
  description text not null
);
