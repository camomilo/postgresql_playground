CREATE TABLE orders (
          id serial,
product_name text,
    quantity integer,
  order_date date,
  CONSTRAINT pk_orders PRIMARY KEY(id)
);
CREATE ROLE repl_user WITH REPLICATION LOGIN PASSWORD 'repl_user';
GRANT ALL PRIVILEGES ON DATABASE testdb TO repl_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO repl_user;