#!/bin/bash
# Websploit Framework Installation Script
# Created By Fardin Allahverdinazhand
# Report Bug : 0x0ptim0us@gmail.com
if [[ $EUID -ne 0 ]]; then
   echo "You must be root to run this script. Aborting...";
   exit 1;
fi
echo "Welcome To Websploit Framework Easy Install Script"
echo "Installing , Please Wait ..."
sleep 3
cp websploit-2.0.3.tar.gz /opt
cd /opt
tar -xf websploit-2.0.3.tar.gz
chmod 755 /opt/websploit/*
chmod 755 /opt/websploit/modules*
chmod 755 /opt/websploit/modules/fakeupdate/*
chmod 755 /opt/websploit/modules/fakeap/*
chmod 755 /opt/websploit/core/*
ln -s /opt/websploit/websploit /usr/bin/websploit
rm -rf /opt/websploit-2.0.3.tar.gz
echo "Installed Directory : /opt/websploit"
echo "Run From Terminal : sudo websploit"
echo "Installation Complete."
