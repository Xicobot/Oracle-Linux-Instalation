#!/bin/bash

# Variables
ORACLE_VERSION="21c"
ORACLE_RPM="oracle-database-xe-21c-1.0-1.ol8.x86_64.rpm"
COCKPIT_PORT=9090

# Update and install required packages
echo "Updating system and installing required packages..."
dnf update -y
dnf install -y cockpit wget openssh-server

# Enable Cockpit
echo "Enabling Cockpit service..."
systemctl enable --now cockpit.socket
systemctl enable cockpit

echo "Cockpit is available at: https://$(hostname -I | awk '{print $1}'):$COCKPIT_PORT"

# Install Oracle repository and configure
sudo dnf install -y oraclelinux-release-el8
sudo dnf config-manager --set-enabled ol8_oracle_instantclient

dnf clean all

echo "Installing SQL*Plus..."
dnf install -y oracle-instantclient-sqlplus-21.11.0.0.0-1.el8.x86_64.rpm

# Install Oracle Database Preinstall Package
echo "Installing Oracle Database Preinstall package..."
sudo dnf install -y oracle-database-preinstall-$ORACLE_VERSION

# Download Oracle Database XE
echo "Downloading Oracle Database XE..."
wget -O /tmp/$ORACLE_RPM "https://download.oracle.com/otn-pub/otn_software/db-express/$ORACLE_RPM"

# Install Oracle Database
echo "Installing Oracle Database..."
dnf install -y /tmp/$ORACLE_RPM

# Configure Oracle Database
echo "Configuring Oracle Database..."
/etc/init.d/oracle-xe-21 configure

# Set environment variables
echo "Setting up environment variables..."
echo "export ORACLE_SID=XE" >> ~/.bashrc
echo "export ORACLE_HOME=/opt/oracle/product/$ORACLE_VERSION/dbhomeXE" >> ~/.bashrc
echo "export PATH=$ORACLE_HOME/bin:$PATH" >> ~/.bashrc
source ~/.bashrc

# Restart SSH service
echo "Enabling root SSH access..."
sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
systemctl restart sshd

# Verify installation
echo "Verifying Oracle installation..."
sqlplus /nolog <<EOF
CONNECT sys AS sysdba;
EXIT;
EOF

echo "Oracle Database $ORACLE_VERSION XE installation completed successfully!"
