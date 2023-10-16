create or replace procedure insert_sample_data()
language plpgsql    
as $$
begin
    for cnt in 1..1000000 loop
        insert into orders (product_name, quantity, order_date) values (md5(random()::text), floor(random() * 1000 + 1)::int, now());
        commit;
        PERFORM pg_sleep(0);
    end loop;
end;$$;