
# Needed for the hstore extension
postgresql-contrib:
  pkg.installed

postgresql:
  pkg:
    - installed
  service.running:
    - enable: True
    - watch:
      - file: /etc/postgresql/9.1/main/pg_hba.conf

pg_hba.conf:
  file.managed:
    - name: /etc/postgresql/9.1/main/pg_hba.conf
    - source: salt://discourse/pg_hba.conf
    - user: postgres
    - group: postgres
    - mode: 644
    - require:
        - pkg: postgresql

discourse-db-user:
  postgres_user.present:
    - name: discourse
    - runas: postgres
    # The migration that enable the hstore extension doesn't work otherwise
    - superuser: True
    - require:
      - service: postgresql

discourse-db:
  postgres_database.present:
    - name: discourse_{{ pillar['discourse']['env'] }}
    - encoding: UTF8
    - lc_ctype: en_US.UTF8
    - lc_collate: en_US.UTF8
    - template: template0
    - owner: discourse
    - runas: postgres
    - require:
      - postgres_user: discourse-db-user

# Doesn't work in the migrations
#enable-hstore:
#  cmd.wait:
#    - name: psql -c "CREATE EXTENSION IF NOT EXISTS hstore"
#    - user: postgres
#    - watch:
#      - service: postgresql
