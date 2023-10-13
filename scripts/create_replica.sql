CREATE TABLE orders (
          id serial,
product_name text,
    quantity integer,
  order_date date,
  CONSTRAINT pk_orders PRIMARY KEY(id)
);
CREATE TABLE orders_partitioned (
          id serial,
product_name text,
    quantity integer,
  order_date date,
  CONSTRAINT pk_orders_partitioned PRIMARY KEY(id, order_date)
)PARTITION BY RANGE (order_date);
CREATE TABLE orders_partitioned_2023_10 PARTITION OF orders_partitioned
    FOR VALUES FROM ('2023-10-01') TO ('2023-10-31');
CREATE TABLE orders_partitioned_2023_11 PARTITION OF orders_partitioned
    FOR VALUES FROM ('2023-11-01') TO ('2023-11-30');
CREATE ROLE repl_user WITH REPLICATION LOGIN PASSWORD 'repl_user';
GRANT ALL PRIVILEGES ON DATABASE testdb TO repl_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO repl_user;
CREATE SUBSCRIPTION sub_testdb CONNECTION 'host=pg_master port=5432 user=repl_user password=repl_user dbname=testdb' PUBLICATION pub_testdb;