CREATE OR REPLACE FUNCTION fTrigger()
returns trigger
language plpgsql
as
$TRIG$
begin
    IF ( TG_OP = 'INSERT' )
    THEN
        INSERT INTO orders_partitioned VALUES(nextval('orders_id_seq'), NEW.product_name, NEW.quantity, NEW.order_date);
        RETURN NEW;
    ELSIF ( TG_OP = 'DELETE' )
    THEN
        DELETE FROM orders_partitioned WHERE id = OLD.id;
        DELETE FROM old_orders WHERE id = OLD.id;
        RETURN OLD;
    ELSE -- UPDATE
        DELETE FROM old_orders WHERE id = OLD.id;
        IF FOUND
        THEN
            INSERT INTO orders_partitioned VALUES(NEW.id, NEW.product_name, NEW.quantity, NEW.order_date);
        ELSE
            UPDATE orders_partitioned SET id = NEW.id, product_name = NEW.product_name, quantity = NEW.quantity, order_date = NEW.order_date
                WHERE id = OLD.id;
        END IF;
        RETURN NEW;
    END IF;
end
$TRIG$;

BEGIN;
    ALTER TABLE orders RENAME TO old_orders;
    ALTER TABLE old_orders SET(autovacuum_enabled = false, toast.autovacuum_enabled = false);
    CREATE VIEW orders AS
    SELECT id, product_name, quantity, order_date FROM old_orders
    UNION ALL
    SELECT id, product_name, quantity, order_date FROM orders_partitioned;
    CREATE TRIGGER tOrders
    INSTEAD OF INSERT OR UPDATE OR DELETE on orders
    FOR EACH ROW
    EXECUTE FUNCTION fTrigger();
COMMIT;