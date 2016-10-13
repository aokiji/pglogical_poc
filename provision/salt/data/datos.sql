insert into tabla select generate_series, 'Cadena ' || generate_series  from generate_series(0, (select case when count(*) = 0 then 1000 else 0 end from tabla));
