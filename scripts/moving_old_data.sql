--> Moving old data
insert into orders_partitioned select * from old_orders;delete from old_orders;