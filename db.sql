drop type if exists user_status cascade;
create type user_status as enum ('new', 'registered', 'refused', 'unavailable');

drop sequence if exists users_seq cascade;
create sequence users_seq;

drop table if exists users cascade;
create table users (
	id integer not null default nextval('users_seq'::regclass) PRIMARY KEY,
	name character varying,
	phone character varying,
	status user_status not null default 'new',
	ctime timestamp with time zone not null default now()
);