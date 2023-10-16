--> Renaming
--> execute on both fisr pg_master than pg_replica
BEGIN;
ALTER VIEW orders RENAME TO view_orders;
SELECT setval('orders_partitioned_id_seq', max(id)) FROM orders_partitioned;
ALTER TABLE orders_partitioned RENAME TO orders;
ALTER TABLE orders_partitioned_2023_10 RENAME TO orders_2023_10;
ALTER TABLE orders_partitioned_2023_11 RENAME TO orders_2023_11;
ALTER SEQUENCE orders_id_seq RENAME TO orders_id_seq_old;
ALTER SEQUENCE orders_partitioned_id_seq RENAME TO orders_id_seq;
COMMIT;