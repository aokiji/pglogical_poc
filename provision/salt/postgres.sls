install postgres repo:               
  pkg.installed:
    - pkgs: 
      - "https://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-3.noarch.rpm"
      - "http://packages.2ndquadrant.com/pglogical/yum-repo-rpms/pglogical-rhel-1.0-2.noarch.rpm"

install postgres packages:               
  pkg.installed:
    - pkgs:
      - postgresql95-server
      - postgresql95-contrib
      - postgresql95-pglogical

add postgres bin to path:
  environ.setenv:
    - name: PATH
    - value: "/sbin:/bin:/usr/sbin:/usr/bin:/usr/pgsql-9.5/bin"

pgsql-data-dir:
  postgres_initdb.present:
    - name: /var/lib/pgsql/9.5/data
    - auth: password
    - user: postgres
    - password: {{ pillar['pg_password'] }}
    - encoding: UTF8
    - locale: C
    - runas: postgres

/var/lib/pgsql/9.5/data/pg_hba.conf:
  file.managed:
    - source: salt://data/pg_hba.conf
    - template: jinja
    - defaults:
      ip: {{ pillar['pghba_ip'] }}
    - watch_in:
      - service: postgresql-9.5

activate logical replication:
  file.append:
    - name: /var/lib/pgsql/9.5/data/postgresql.conf
    - text: 
      - "wal_level = 'logical'"
      - "shared_preload_libraries = 'pglogical'"
      - "listen_addresses = '*'"
      - "max_replication_slots = 10"
      - "max_wal_senders = 10"
    - watch_in:
      - service: postgresql-9.5

start postgres service:
  service.running:
    - name: postgresql-9.5
    - enable: True

create db:
  postgres_database.present:
    - name: {{ pillar['dbname'] }}
    - db_user: postgres
    - db_password: {{ pillar['pg_password'] }}


/tmp/schema.sql:
  file.managed:
    - source: salt://data/schema.sql
    - template: jinja
    - defaults:
      ip: {{ pillar['ip'] }}
      node_name: {{ pillar['dbname'] }}
      db_name: {{ pillar['dbname'] }}
      rp_password: {{ pillar['rp_password'] }}
      

create schema:
  cmd.run:
    - name: psql -Upostgres -d{{ pillar['dbname'] }} < /tmp/schema.sql
    - source: salt://data/schema.sql
    - env: 
      - PGPASSWORD: {{ pillar['pg_password'] }}


{% if pillar['dbname'] == 'master' %}
/tmp/data.sql:
  file.managed:
    - source: salt://data/datos.sql

create data:
  cmd.run:
    - name: psql -Upostgres -d{{ pillar['dbname'] }} < /tmp/data.sql
    - source: salt://data/data.sql
    - env: 
      - PGPASSWORD: {{ pillar['pg_password'] }}
{% endif %}
