# Pglogical PoC
This is a proof of concept for a pglogical setup. 

Two centos machines are provisioned with postgresql 9.5 and pglogical. One is the initial master and the other one the slave. Subscription is not initiated and left to the user.

## Getting started

```
vagrant up
```

Once both machine finish setup.
```
vagrant ssh db_slave
PGPASSWORD=strong_password psql -U postgres -d slavedb -c "select pglogical.create_subscription('subscription1', 'host=192.168.33.10 port=5432 dbname=master user=replicator password=replica64')"
```
