nginx-repo:
  pkgrepo.managed:
    - humanname: Nginx repo
    - name: deb http://nginx.org/packages/ubuntu/ {{ grains['oscodename'] }} nginx
    - dist: {{ grains['oscodename'] }}
    - file: /etc/apt/sources.list.d/nginx.list
    - key_url: http://nginx.org/keys/nginx_signing.key
    - require_in:
      - pkg: nginx

nginx:
  pkg:
    - installed
  service:
    - running
    - require:
      - pkg: nginx

# Not needed with the upstream package
old-nginx-config:
  file.absent:
    - names:
      - /etc/nginx/sites-enabled/default
      - /etc/nginx/conf.d/default.conf
      - /etc/nginx/conf.d/example_ssl.conf
    - watch_in:
      - service: nginx

# adds server_names_hash_bucket_size 64; to the http section
/etc/nginx/nginx.conf:
  file.patch:
    - source: salt://discourse/nginx.conf.diff
    - hash: md5=8909db9f905ecfc1bbe6f9ac27cc5028
    - watch_in:
      - service: nginx
    - require:
      - pkg: nginx

/etc/nginx/conf.d/discourse.conf:
  file.managed:
    - source: salt://discourse/nginx.conf.jinja
    - template: jinja
    - watch_in:
      - service: nginx
    - require:
      - pkg: nginx
