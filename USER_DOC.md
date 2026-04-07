# User Documentation

## Services provided

This project runs 3 services:

| Service | Role |
|---------|------|
| **Nginx** | Web server — receives all incoming requests and serves the website over HTTPS |
| **WordPress** | The website and its administration panel |
| **MariaDB** | The database — stores all WordPress content (articles, users, settings) |

---

## Start and stop the project

**Start:**
```bash
make
```

**Stop (keeps data):**
```bash
make clean
```

**Stop and delete everything (data included):**
```bash
make fclean
```

**Full rebuild:**
```bash
make re
```

---

## Access the website

Once the project is running, open your browser and go to:

```
https://artperez.42.fr
```

> Note: The certificate is self-signed, your browser may show a security warning. Click "Advanced" and "Proceed" to continue.

---

## Access the administration panel

The administration panel allows you to manage the entire website without touching any code. From there you can create and edit articles, manage users, change the site appearance, install plugins and configure all WordPress settings.

The WordPress admin panel is available at:

```
https://artperez.42.fr/wp-admin
```

Log in with the admin credentials defined in your `.env` file:

```
Username → WP_ADMIN_USER
Password → WP_ADMIN_PASSWORD
```

---

## Access the website as a user

A regular author account is also available to write articles without access to the administration settings.

Login page:

```
https://artperez.42.fr/wp-login.php
```

Log in with the author credentials defined in your `.env` file:

```
Username → WP_USER
Password → WP_USER_PASSWORD
```

---

## Credentials

All credentials are stored in the `.env` file located in `srcs/`.

| Variable | Description |
|----------|-------------|
| `WP_ADMIN_USER` | WordPress admin username |
| `WP_ADMIN_PASSWORD` | WordPress admin password |
| `WP_ADMIN_EMAIL` | WordPress admin email |
| `WP_USER` | WordPress author username |
| `WP_USER_PASSWORD` | WordPress author password |
| `MYSQL_USER` | MariaDB user for WordPress |
| `MYSQL_PASSWORD` | MariaDB user password |
| `MYSQL_ROOT_PASSWORD` | MariaDB root password |

> Never share or commit your `.env` file publicly.

---

## Check that services are running

**List running containers:**
```bash
make status
```

You should see 3 containers with the status **Up**:
```
NAME        STATUS
nginx       Up
wordpress   Up
mariadb     Up
```

**Check logs of a specific service:**
```bash
make logs_nginx
make logs_wordpress
make logs_mariadb
```

**Enter a container to inspect it:**
```bash
docker exec -it nginx bash
docker exec -it wordpress bash
docker exec -it mariadb bash
```
