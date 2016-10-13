CREATE TABLE IF NOT EXISTS tabla (numero integer, cadena text, PRIMARY KEY (numero));
CREATE ROLE replicator WITH login superuser replication password '{{ rp_password }}';
CREATE EXTENSION pglogical;
SELECT pglogical.create_node(node_name := '{{ node_name }}',dsn := 'host={{ ip }} port=5432 dbname={{ db_name }} user=replicator password={{ rp_password }}');
SELECT pglogical.replication_set_add_all_tables('default', ARRAY['public']);
