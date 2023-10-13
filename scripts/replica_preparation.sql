BEGIN;
    ALTER TABLE orders RENAME TO old_orders;
    ALTER TABLE old_orders SET(autovacuum_enabled = false, toast.autovacuum_enabled = false);
    CREATE VIEW orders AS
    SELECT id, product_name, quantity, order_date FROM old_orders
    UNION ALL
    SELECT id, product_name, quantity, order_date FROM orders_partitioned;
COMMIT;