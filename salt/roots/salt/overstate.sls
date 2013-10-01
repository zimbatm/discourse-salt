# http://docs.saltstack.com/ref/states/overstate.html
mysql:
  match: 'db*'
  sls:
    - mysql.server
    - drbd
webservers:
  match: 'web*'
  require:
    - mysql
all:
  match: '*'
  require:
    - mysql
    - webservers
