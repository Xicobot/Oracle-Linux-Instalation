# Oracle Installation

## Operating System (OS) Installation

First, create a virtual machine with the following requirements:

- **4GB RAM**
- **20GB hard disk**
- **2 cores** (optional but recommended for better performance, you can also use 1 core)

Once the machine starts, let all the initial ISO scripts load and wait.

Then, log in as **root**.

### Installing Cockpit
To install **Cockpit**, run the following command:

```bash
dnf install -y cockpit
```

Wait for the installation to complete and then enable the service:

```bash
systemctl enable --now cockpit.socket  
systemctl enable cockpit
```

Now, access the **Cockpit** web interface through the browser:

```
https://<SERVER_IP>:9090
```

From this point, we will use the web interface terminal to continue the installation.

## Installing SQL*Plus

We will use Oracle repositories to install **SQL*Plus** with the following commands:

```bash
sudo dnf install -y oraclelinux-release-el8
sudo dnf config-manager --set-enabled ol8_oracle_instantclient
```

Clear the **dnf** cache and regenerate metadata for enabled repositories:

```bash
dnf clean all
```

Install **SQL*Plus** with the following command:

```bash
dnf install -y oracle-instantclient-sqlplus-21.11.0.0.0-1.el8.x86_64.rpm
```

## Installing the Database

Run the following command to install Oracle Database preinstallation packages:

```bash
sudo dnf install -y oracle-database-preinstall-21c
```

Now, download the installation package from Oracle's official page:

- **Oracle Database 21c Express Edition for Linux x64 (OL8):**  
  [Download here](https://download.oracle.com/otn-pub/otn_software/db-express/oracle-database-xe-21c-1.0-1.ol8.x86_64.rpm)

After downloading, transfer the file to the Oracle machine using **SSH**.

Modify the **SSH** configuration to allow root login:

```bash
vi /etc/ssh/sshd_config
```

Find the line:

```
PermitRootLogin
```

And set it to **YES**. Then restart the SSH service:

```bash
systemctl restart sshd
```

Now transfer the database file:

```bash
scp oracle-database-xe-21c-1.0-1.ol8.x86_64.rpm root@<SERVER_IP>:/tmp
```

Verify that the file has been transferred correctly and proceed with the installation:

```bash
dnf install -y /tmp/oracle-database-xe-21c-1.0-1.ol8.x86_64.rpm
```

Once installed, run the initial configuration:

```bash
/etc/init.d/oracle-xe-21 configure
```

This process will prompt you to enter the necessary database passwords.

## Setting Environment Variables

To avoid connection issues with the database, set environment variables by running the following commands:

```bash
echo "export ORACLE_SID=XE" >> ~/.bashrc
echo "export ORACLE_HOME=/opt/oracle/product/21c/dbhomeXE" >> ~/.bashrc
echo "export PATH=$ORACLE_HOME/bin:$PATH" >> ~/.bashrc
source ~/.bashrc
```

## Verifications

To verify the installation, run **SQL*Plus** and connect to the database:

```bash
sqlplus /nolog
```

Then log in as the administrator:

```sql
CONNECT sys AS sysdba;
```

Enter the password, and if everything is correct, you should now be inside the database.

---

With this, the installation of **Oracle Database 21c XE** is complete 🎉.
