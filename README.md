# cwa_PostgreSQL

container web application database provider postgresql- Mainfranken Racing basis system. Will provide database storage.

## Manage users

Login as postrges useer to the postrges server container. Then authentificate as the current db administrator. The excample uses **dbadmin** as administrator.

```bash
sudo docker exec -it -u postgres postgres /bin/bash
psql -U dbadmin
```

You can list all users with the ```\du``` command. To ad a user create a database fist and then the user.

```bash
create database gitlab_db;
create user gitlab with encrypted password 'HelloWorld';
grant all privileges on database gitlab_db to gitlab;
```

