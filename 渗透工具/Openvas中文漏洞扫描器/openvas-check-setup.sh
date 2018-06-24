#!/bin/sh

# OpenVAS
# $Id$
# Description: Script for checking completeness and readiness
# of OpenVAS.
#
# Authors:
# Jan-Oliver Wagner <jan-oliver.wagner@greenbone.net>
# Michael Wiegand <michael.wiegand@greenbone.net>
#
# Copyright:
# Copyright (C) 2011, 2012 Greenbone Networks GmbH
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2,
# or at your option any later version, as published by the
# Free Software Foundation
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.

LOG=/tmp/openvas-check-setup.log
CHECKVERSION=2.1.5

if [ "$1" = "--server" -o "$2" = "--server" ]
then
  MODE="server"
else
  MODE="desktop"
fi

if [ "$1" = "--v5" -o "$2" = "--v5" ]
then
  VER="5"
  SCANNER_MAJOR="3"
  SCANNER_MINOR="3"
  MANAGER_MAJOR="3"
  MANAGER_MINOR="0"
  ADMINISTRATOR_MAJOR="1"
  ADMINISTRATOR_MINOR="2"
  GSA_MAJOR="3"
  GSA_MINOR="0"
  CLI_MAJOR="1"
  CLI_MINOR="1"
  GSD_MAJOR="1"
  GSD_MINOR="2"
else
  VER="4"
  SCANNER_MAJOR="3"
  SCANNER_MINOR="2"
  MANAGER_MAJOR="2"
  MANAGER_MINOR="0"
  ADMINISTRATOR_MAJOR="1"
  ADMINISTRATOR_MINOR="1"
  GSA_MAJOR="2"
  GSA_MINOR="0"
  CLI_MAJOR="1"
  CLI_MINOR="1"
  GSD_MAJOR="1"
  GSD_MINOR="2"
fi

echo "openvas-check-setup $CHECKVERSION"
echo "  Test completeness and readiness of OpenVAS-$VER"
if [ "$VER" = "4" ]
then
  echo "  (add '--v5' if you want to check for OpenVAS-5)"
fi
echo ""
echo "  Please report us any non-detected problems and"
echo "  help us to improve this check routine:"
echo "  http://lists.wald.intevation.org/mailman/listinfo/openvas-discuss"
echo ""
echo "  Send us the log-file ($LOG) to help analyze the problem."
echo ""

if [ "$MODE" = "desktop" ]
then
  echo "  Use the parameter --server to skip checks for client tools"
  echo "  like GSD and OpenVAS-CLI."
  echo ""
fi

log_and_print ()
{
  echo "       " $1
  echo "       " $1 >> $LOG
}

check_failed ()
{
  echo ""
  echo " ERROR: Your OpenVAS-$VER installation is not yet complete!"
  echo ""
  echo "Please follow the instructions marked with FIX above and run this"
  echo "script again."
  echo ""
  echo "If you think this result is wrong, please report your observation"
  echo "and help us to improve this check routine:"
  echo "http://lists.wald.intevation.org/mailman/listinfo/openvas-discuss"
  echo "Please attach the log-file ($LOG) to help us analyze the problem."
  echo ""
  exit 1
}


# LOG start
echo "openvas-check-setup $CHECKVERSION" > $LOG
echo "  Mode:  $MODE" >> $LOG
echo "  Date: " `date -R` >> $LOG
echo "" >> $LOG


echo "Step 1: Checking OpenVAS Scanner ... "

echo "Checking for old OpenVAS Scanner <= 2.0 ..." >> $LOG
openvasd -V >> $LOG 2>&1
if [ $? -eq 0 ]
then
  log_and_print "ERROR: Old version of OpenVAS Scanner detected."
  log_and_print "FIX: Please remove the installation of the old OpenVAS Scanner (openvasd)."
  check_failed
fi
echo "" >> $LOG

echo "Checking presence of OpenVAS Scanner ..." >> $LOG
openvassd --version >> $LOG 2>&1
if [ $? -ne 0 ]
then
  log_and_print "ERROR: No OpenVAS Scanner (openvassd) found."
  log_and_print "FIX: Please install OpenVAS Scanner."
  check_failed
fi
echo "" >> $LOG

echo "Checking OpenVAS Scanner version ..." >> $LOG

VERSION=`openvassd --version | head -1 | sed -e "s/OpenVAS Scanner //"`

if [ `echo $VERSION | grep "^$SCANNER_MAJOR\.$SCANNER_MINOR" | wc -l` -ne "1" ]
then
  log_and_print "ERROR: OpenVAS Scanner too old or too new: $VERSION"
  log_and_print "FIX: Please install OpenVAS Scanner $SCANNER_MAJOR.$SCANNER_MINOR."
  check_failed
fi
echo "" >> $LOG

log_and_print "OK: OpenVAS Scanner is present in version $VERSION."

openvassd -s >> $LOG

echo "Checking OpenVAS Scanner CA cert ..." >> $LOG
CAFILE=`openvassd -s | grep ca_file | sed -e "s/^ca_file = //"`
if [ ! -e $CAFILE ]
then
  log_and_print "ERROR: No CA certificate file of OpenVAS Scanner found."
  log_and_print "FIX: Run 'openvas-mkcert'."
  check_failed
fi
echo "" >> $LOG

log_and_print "OK: OpenVAS Scanner CA Certificate is present as $CAFILE."

echo "Checking NVT collection ..." >> $LOG
PLUGINSFOLDER=`openvassd -s | grep plugins_folder | sed -e "s/^plugins_folder = //"`
if [ ! -d $PLUGINSFOLDER ]
then
  log_and_print "ERROR: Directory containing the NVT collection not found."
  log_and_print "FIX: Run a synchronization script like openvas-nvt-sync or greenbone-nvt-sync."
  check_failed
fi
OLDPLUGINSFOLDER=`echo "$PLUGINSFOLDER" | grep -q -v "/var/" 2>&1`
if [ $? -eq 0 ]
then
  CONFFILE=`openvassd -s | grep config_file | sed -e "s/^config_file = //"`
  log_and_print "ERROR: Your OpenVAS Scanner configuration seems to be from a pre-OpenVAS-4 installation and contains non-FHS compliant paths."
  log_and_print "FIX: Delete your OpenVAS Scanner Configuration file ($CONFFILE)."
  check_failed
fi
NVTCOUNT=`find $PLUGINSFOLDER -name "*nasl" | wc -l`
if [ $NVTCOUNT -lt 10 ]
then
  log_and_print "ERROR: The NVT collection is very small."
  log_and_print "FIX: Run a synchronization script like openvas-nvt-sync or greenbone-nvt-sync."
  check_failed
fi
echo "" >> $LOG

log_and_print "OK: NVT collection in $PLUGINSFOLDER contains $NVTCOUNT NVTs."

echo "Checking status of signature checking in OpenVAS Scanner ..." >> $LOG
NOSIGCHECK=`openvassd -s | grep nasl_no_signature_check | sed -e "s/^nasl_no_signature_check = //"`
if [ $NOSIGCHECK != "no" ]
then
  log_and_print "WARNING: Signature checking of NVTs is not enabled in OpenVAS Scanner."
  log_and_print "SUGGEST: Enable signature checking (see http://www.openvas.org/trusted-nvts.html)."
else
  log_and_print "OK: Signature checking of NVTs is enabled in OpenVAS Scanner."
fi
echo "" >> $LOG


echo "Step 2: Checking OpenVAS Manager ... "

echo "Checking presence of OpenVAS Manager ..." >> $LOG
openvasmd --version >> $LOG 2>&1
if [ $? -ne 0 ]
then
  log_and_print "ERROR: No OpenVAS Manager (openvasmd) found."
  log_and_print "FIX: Please install OpenVAS Manager."
  check_failed
fi
echo "" >> $LOG

VERSION=`openvasmd --version | head -1 | sed -e "s/OpenVAS Manager //"`

if [ `echo $VERSION | grep "^$MANAGER_MAJOR\.$MANAGER_MINOR" | wc -l` -ne "1" ]
then
  log_and_print "ERROR: OpenVAS Manager too old or too new: $VERSION"
  log_and_print "FIX: Please install OpenVAS Manager $MANAGER_MAJOR.$MANAGER_MINOR."
  check_failed
fi
echo "" >> $LOG

log_and_print "OK: OpenVAS Manager is present in version $VERSION."

echo "Checking OpenVAS Manager client certificate ..." >> $LOG
CERTDIR=`dirname $CAFILE`
CLIENTCERTFILE="$CERTDIR/clientcert.pem"
if [ ! -e $CLIENTCERTFILE ]
then
  log_and_print "ERROR: No client certificate file of OpenVAS Manager found."
  log_and_print "FIX: Run 'openvas-mkcert-client -n om -i'"
  check_failed
fi
echo "" >> $LOG

log_and_print "OK: OpenVAS Manager client certificate is present as $CLIENTCERTFILE."

echo "Checking OpenVAS Manager database ..." >> $LOG
# Guess openvas state dir from $PLUGINSFOLDER
STATEDIR=`dirname $PLUGINSFOLDER`
TASKSDB="$STATEDIR/mgr/tasks.db"
if [ ! -e $TASKSDB ]
then
  log_and_print "ERROR: No OpenVAS Manager database found. (Tried: $TASKSDB)"
  log_and_print "FIX: Run 'openvasmd --rebuild' while OpenVAS Scanner is running."
  check_failed
fi
echo "" >> $LOG

log_and_print "OK: OpenVAS Manager database found in $TASKSDB."

echo "Checking access rights of OpenVAS Manager database ..." >> $LOG
TASKSDBPERMS=`stat -c "%a" "$TASKSDB"`
if [ "$TASKSDBPERMS" != "600" ]
then
  log_and_print "ERROR: The access rights of the OpenVAS Manager database are incorrect."
  log_and_print "FIX: Run 'chmod 600 $TASKSDB'."
  check_failed
fi
echo "" >> $LOG

log_and_print "OK: Access rights for the OpenVAS Manager database are correct."

echo "Checking sqlite3 presence ..." >> $LOG
SQLITE3=`type sqlite3 2> /dev/null`
if [ $? -ne 0 ]
then
  log_and_print "WARNING: Could not find sqlite3 binary, extended manager checks of the OpenVAS Manager installation are disabled."
  log_and_print "SUGGEST: Install sqlite3."
  HAVE_SQLITE=0
else
  log_and_print "OK: sqlite3 found, extended checks of the OpenVAS Manager installation enabled."
  HAVE_SQLITE=1
fi
echo "" >> $LOG

if [ $HAVE_SQLITE -eq 1 ]
then
  echo "Checking OpenVAS Manager database revision ..." >> $LOG
  TASKSDBREV=`sqlite3 $TASKSDB "select value from meta where name='database_version';"`
  if [ -z $TASKSDBREV ]
  then
    log_and_print "ERROR: Could not determine database revision, database corrupt or in invalid format."
    log_and_print "FIX: Delete database at $TASKSDB and rebuild it."
    check_failed
  else
    log_and_print "OK: OpenVAS Manager database is at revision $TASKSDBREV."
  fi
  echo "Checking database revision expected by OpenVAS Manager ..." >> $LOG
  MANAGERDBREV=`openvasmd --version | grep "Manager DB revision" | sed -e "s/.*\ //"`
  if [ -z $MANAGERDBREV ]
  then
    log_and_print "ERROR: Could not determine database revision expected by OpenVAS Manager."
    log_and_print "FIX: Ensure OpenVAS Manager is installed correctly."
    check_failed
  else
    log_and_print "OK: OpenVAS Manager expects database at revision $MANAGERDBREV."
  fi
  if [ $TASKSDBREV -lt $MANAGERDBREV ]
  then
    log_and_print "ERROR: Database schema is out of date."
    log_and_print "FIX: Run 'openvasmd --migrate'."
    check_failed
  else
    log_and_print "OK: Database schema is up to date."
  fi
  echo "Checking OpenVAS Manager database (NVT data) ..." >> $LOG
  DBNVTCOUNT=`sqlite3 $TASKSDB "select count(*) from nvts;"`
  if [ $DBNVTCOUNT -lt 20000 ]
  then
    log_and_print "ERROR: The number of NVTs in the OpenVAS Manager database is too low."
    log_and_print "FIX: Make sure OpenVAS Scanner is running with an up-to-date NVT collection and run 'openvasmd --rebuild'."
    check_failed
  else
    log_and_print "OK: OpenVAS Manager database contains information about $DBNVTCOUNT NVTs."
  fi
fi

echo "Checking xsltproc presence ..." >> $LOG
XSLTPROC=`type xsltproc 2> /dev/null`
if [ $? -ne 0 ]
then
  log_and_print "WARNING: Could not find xsltproc binary, most report formats will not work."
  log_and_print "SUGGEST: Install xsltproc."
else
  log_and_print "OK: xsltproc found."
fi
echo "" >> $LOG


echo "Step 3: Checking OpenVAS Administrator ... "

echo "Checking presence of OpenVAS Administrator ..." >> $LOG
openvasad --version >> $LOG 2>&1
if [ $? -ne 0 ]
then
  log_and_print "ERROR: No OpenVAS Administrator (openvasad) found."
  log_and_print "FIX: Please install OpenVAS Administrator."
  check_failed
fi
echo "" >> $LOG

VERSION=`openvasad --version | head -1 | sed -e "s/OpenVAS Administrator //"`

if [ `echo $VERSION | grep "^$ADMINISTRATOR_MAJOR\.$ADMINISTRATOR_MINOR" | wc -l` -ne "1" ]
then
  log_and_print "ERROR: OpenVAS Administrator too old or too new: $VERSION"
  log_and_print "FIX: Please install OpenVAS Administrator $ADMINISTRATOR_MAJOR.$ADMINISTRATOR_MINOR."
  check_failed
fi
echo "" >> $LOG

log_and_print "OK: OpenVAS Administrator is present in version $VERSION."

echo "Checking if users exist ..." >> $LOG
USERCOUNT=`openvasad -c "list_users" | sed -e "/^$/d" | wc -l`
if [ $USERCOUNT -eq 0 ]
then
  log_and_print "ERROR: No users found. You need to create at least one user to log in."
  log_and_print "       It is recommended to have at least one user with role Admin."
  log_and_print "FIX: Create a user using 'openvasad -c 'add_user' -n <name> --role=Admin'"
  check_failed
else
  log_and_print "OK: At least one user exists."
fi
echo "" >> $LOG

echo "Checking if at least one admin user exists ..." >> $LOG
ADMINEXISTS=`ls $STATEDIR/users/*/isadmin 2> /dev/null`
if [ $? -ne 0 ]
then
  log_and_print "ERROR: No admin user found. You need to create at least one admin user to log in."
  log_and_print "FIX: Create a user using 'openvasad -c 'add_user' -n <name> -r Admin'"
  check_failed
else
  log_and_print "OK: At least one admin user exists."
fi
echo "" >> $LOG


echo "Step 4: Checking Greenbone Security Assistant (GSA) ... "

echo "Checking presence of Greenbone Security Assistant ..." >> $LOG
gsad --version >> $LOG 2>&1
if [ $? -ne 0 ]
then
  log_and_print "ERROR: No Greenbone Security Assistant (gsad) found."
  log_and_print "FIX: Please install Greenbone Security Assistant."
  check_failed
fi
echo "" >> $LOG

VERSION=`gsad --version | head -1 | sed -e "s/Greenbone Security Assistant //"`

if [ `echo $VERSION | grep "^$GSA_MAJOR\.$GSA_MINOR" | wc -l` -ne "1" ]
then
  log_and_print "ERROR: Greenbone Security Assistant too old or too new: $VERSION"
  log_and_print "FIX: Please install Greenbone Security Assistant $GSA_MAJOR.$GSA_MINOR."
  check_failed
fi
echo "" >> $LOG

log_and_print "OK: Greenbone Security Assistant is present in version $VERSION."

echo "Step 5: Checking OpenVAS CLI ... "

if [ "$MODE" != "server" ]
then
  echo "Checking presence of OpenVAS CLI ..." >> $LOG
  omp --version >> $LOG 2>&1
  if [ $? -ne 0 ]
  then
    log_and_print "ERROR: No OpenVAS CLI (omp) found."
    log_and_print "FIX: Please install OpenVAS CLI."
    check_failed
  fi
  echo "" >> $LOG

  VERSION=`omp --version | head -1 | sed -e "s/OMP Command Line Interface //"`

  if [ `echo $VERSION | grep "^$CLI_MAJOR\.$CLI_MINOR" | wc -l` -ne "1" ]
  then
    log_and_print "ERROR: OpenVAS CLI too old or too new: $VERSION"
    log_and_print "FIX: Please install OpenVAS CLI $CLI_MAJOR.$CLI_MINOR."
    check_failed
  fi
  echo "" >> $LOG

  log_and_print "OK: OpenVAS CLI version $VERSION."
else
  log_and_print "SKIP: Skipping check for OpenVAS CLI."
fi


echo "Step 6: Checking Greenbone Security Desktop (GSD) ... "

if [ "$MODE" != "server" ]
then
  echo "Checking presence of Greenbone Security Desktop ..." >> $LOG
  DISPLAY=fake gsd --version >> $LOG 2>&1
  if [ $? -ne 0 ]
  then
    log_and_print "ERROR: No Greenbone Security Desktop (gsd) found or too old."
    log_and_print "FIX: Please install Greenbone Security Desktop 1.1.0."
    check_failed
  fi
  echo "" >> $LOG

  VERSION=`gsd --version | head -1 | sed -e "s/Greenbone Security Desktop //"`

  if [ `echo $VERSION | grep "^$GSD_MAJOR\.$GSD_MINOR" | wc -l` -ne "1" ]
  then
    # a special exception rule for v4 where also another release is OK
    if [ $VER -eq "4" -a `echo $VERSION | grep "^1\.1" | wc -l` -ne "1" ]
    then
      log_and_print "ERROR: Greenbone Security Desktop too old or too new: $VERSION"
      log_and_print "FIX: Please install Greenbone Security Desktop $GSD_MAJOR.$GSD_MINOR."
      check_failed
    fi
  fi
  echo "" >> $LOG

  log_and_print "OK: Greenbone Security Desktop is present in Version $VERSION."
else
  log_and_print "SKIP: Skipping check for Greenbone Security Assistant."
fi


echo "Step 7: Checking if OpenVAS services are up and running ... "

echo "Checking netstat presence ..." >> $LOG
NETSTAT=`type netstat 2> /dev/null`
if [ $? -ne 0 ]
then
  log_and_print "WARNING: Could not find netstat binary, checks of the OpenVAS services are disabled."
  log_and_print "SUGGEST: Install netstat."
  HAVE_NETSTAT=0
else
  log_and_print "OK: netstat found, extended checks of the OpenVAS services enabled."
  HAVE_NETSTAT=1
fi
echo "" >> $LOG

if [ $HAVE_NETSTAT -eq 1 ]
then
  netstat -A inet -ntlp 2> /dev/null >> $LOG
  OPENVASSD_HOST=`netstat -A inet -ntlp 2> /dev/null | grep openvassd | awk -F\  '{print $4}' | awk -F: '{print $1}'`
  OPENVASSD_PORT=`netstat -A inet -ntlp 2> /dev/null | grep openvassd | awk -F\  '{print $4}' | awk -F: '{print $2}'`
  OPENVASMD_HOST=`netstat -A inet -ntlp 2> /dev/null | grep openvasmd | awk -F\  '{print $4}' | awk -F: '{print $1}'`
  OPENVASMD_PORT=`netstat -A inet -ntlp 2> /dev/null | grep openvasmd | awk -F\  '{print $4}' | awk -F: '{print $2}'`
  OPENVASAD_HOST=`netstat -A inet -ntlp 2> /dev/null | grep openvasad | awk -F\  '{print $4}' | awk -F: '{print $1}'`
  OPENVASAD_PORT=`netstat -A inet -ntlp 2> /dev/null | grep openvasad | awk -F\  '{print $4}' | awk -F: '{print $2}'`
  GSAD_HOST=`netstat -A inet -ntlp 2> /dev/null | grep gsad | awk -F\  '{print $4}' | awk -F: '{print $1}'`
  GSAD_PORT=`netstat -A inet -ntlp 2> /dev/null | grep gsad | awk -F\  '{print $4}' | awk -F: '{print $2}'`

  case "$OPENVASSD_HOST" in
    "0.0.0.0") log_and_print "OK: OpenVAS Scanner is running and listening on all interfaces." ;;
    "127.0.0.1") log_and_print "OK: OpenVAS Scanner is running and listening only on the local interface." ;;
    "") OPENVASSD_PROC=`ps -Af | grep "openvassd: waiting for incoming connections" | grep -v grep | wc -l`
        if [ $OPENVASSD_PROC -eq 0 ]
        then
          log_and_print "ERROR: OpenVAS Scanner is NOT running!" ;
          log_and_print "FIX: Start OpenVAS Scanner (openvassd)." ;
        else
          log_and_print "WARNING: OpenVAS Scanner seems to be run by another user!" ;
          log_and_print "FIX: If intended this is OK (e.g. as root). But we can not determine the port." ;
          log_and_print "FIX: You might face subsequent problems if not intended." ;
        fi
        OPENVASSD_PORT=-1 ;;
  esac
  case $OPENVASSD_PORT in
    -1) ;;
    9391) log_and_print "OK: OpenVAS Scanner is listening on port 9391, which is the default port." ;;
    *) log_and_print "WARNING: OpenVAS Scanner is listening on port $OPENVASSD_PORT, which is NOT the default port!"
       log_and_print "SUGGEST: Ensure OpenVAS Scanner is listening on port 9391." ;;
  esac

  case "$OPENVASMD_HOST" in
    "0.0.0.0") log_and_print "OK: OpenVAS Manager is running and listening on all interfaces." ;;
    "127.0.0.1") log_and_print "WARNING: OpenVAS Manager is running and listening only on the local interface. This means that you will not be able to access the OpenVAS Manager from the outside using GSD or OpenVAS CLI."
                 log_and_print "SUGGEST: Ensure that OpenVAS Manager listens on all interfaces." ;;
    "") log_and_print "ERROR: OpenVAS Manager is NOT running!" ; log_and_print "FIX: Start OpenVAS Manager (openvasmd)." ; OPENVASMD_PORT=-1 ;;
  esac
  case $OPENVASMD_PORT in
    -1) ;;
    9390) log_and_print "OK: OpenVAS Manager is listening on port 9390, which is the default port." ;;
    *) log_and_print "WARNING: OpenVAS Manager is listening on port $OPENVASMD_PORT, which is NOT the default port!"
       log_and_print "SUGGEST: Ensure OpenVAS Manager is listening on port 9390." ;;
  esac

  case "$OPENVASAD_HOST" in
    "0.0.0.0") log_and_print "OK: OpenVAS Administrator is running and listening on all interfaces." ;;
    "127.0.0.1") log_and_print "OK: OpenVAS Administrator is running and listening only on the local interface." ;;
    "") log_and_print "ERROR: OpenVAS Administrator is NOT running!" ; log_and_print "FIX: Start OpenVAS Administrator (openvasad)." ; OPENVASAD_PORT=-1 ;;
  esac
  case $OPENVASAD_PORT in
    -1) ;;
    9393) log_and_print "OK: OpenVAS Administrator is listening on port 9393, which is the default port." ;;
    *) log_and_print "WARNING: OpenVAS Administrator is listening on port $OPENVASAD_PORT, which is NOT the default port!"
       log_and_print "SUGGEST: Ensure OpenVAS Administrator is listening on port 9393." ;;
  esac

  case "$GSAD_HOST" in
    "0.0.0.0") log_and_print "OK: Greenbone Security Assistant is running and listening on all interfaces." ;;
    "127.0.0.1") log_and_print "WARNING: Greenbone Security Assistant is running and listening only on the local interface. This means that you will not be able to access the Greenbone Security Assistant from the outside using a web browser."
                 log_and_print "SUGGEST: Ensure that Greenbone Security Assistant listens on all interfaces." ;;
    "") log_and_print "ERROR: Greenbone Security Assistant is NOT running!" ; log_and_print "FIX: Start Greenbone Security Assistant (gsad)." ; GSAD_PORT=-1 ;;
  esac
  case $GSAD_PORT in
    -1) ;;
    80|443|9392) log_and_print "OK: Greenbone Security Assistant is listening on port $GSAD_PORT, which is the default port." ;;
    *) log_and_print "WARNING: Greenbone Security Assistant is listening on port $GSAD_PORT, which is NOT the default port!"
       log_and_print "SUGGEST: Ensure Greenbone Security Assistant is listening on one of the following ports: 80, 443, 9392." ;;
  esac

  if [ $OPENVASSD_PORT -eq -1 ] || [ $OPENVASMD_PORT -eq -1 ] || [ $OPENVASAD_PORT -eq -1 ] || [ $GSAD_PORT -eq -1 ]
  then
    check_failed
  fi

fi


echo "Step 8: Checking nmap installation ..."

echo "Checking presence of nmap ..." >> $LOG
VERSION=`nmap --version | awk '/Nmap version/ { print $3 }'`

if [ $? -ne 0 ]
then
  log_and_print "WARNING: No nmap installation found."
  log_and_print "SUGGEST: You should install nmap for comprehensive network scanning (see http://nmap.org)"
else
  if [ `echo $VERSION | grep "5\.51" | wc -l` -ne "1" ]
  then
    log_and_print "WARNING: Your version of nmap is not fully supported: $VERSION"
    log_and_print "SUGGEST: You should install nmap 5.51."
  else
    log_and_print "OK: nmap is present in version $VERSION."
  fi
fi
echo "" >> $LOG


echo "Step 9: Checking presence of optional tools ..."

echo "Checking presence of pdflatex ..." >> $LOG
PDFLATEX=`type pdflatex 2> /dev/null`
if [ $? -ne 0 ]
then
  log_and_print "WARNING: Could not find pdflatex binary, the PDF report format will not work."
  log_and_print "SUGGEST: Install pdflatex."
  HAVE_PDFLATEX=0
else
  log_and_print "OK: pdflatex found."
  HAVE_PDFLATEX=1
fi
echo "" >> $LOG

if [ $HAVE_PDFLATEX -eq 1 ]
then
  echo "Checking presence of LaTeX packages required for PDF report generation ..." >> $LOG
  PDFTMPDIR=`mktemp -d -t openvas-check-setup-tmp.XXXXXXXXXX`
  TEXFILE="$PDFTMPDIR/test.tex"
  cat <<EOT > $TEXFILE
\documentclass{article}
\pagestyle{empty}

%\usepackage{color}
\usepackage{tabularx}
\usepackage{geometry}
\usepackage{comment}
\usepackage{longtable}
\usepackage{titlesec}
\usepackage{chngpage}
\usepackage{calc}
\usepackage{url}
\usepackage[utf8x]{inputenc}

\DeclareUnicodeCharacter {135}{{\textascii ?}}
\DeclareUnicodeCharacter {129}{{\textascii ?}}
\DeclareUnicodeCharacter {128}{{\textascii ?}}

\usepackage{colortbl}

% must come last
\usepackage{hyperref}
\definecolor{linkblue}{rgb}{0.11,0.56,1}
\definecolor{inactive}{rgb}{0.56,0.56,0.56}
\definecolor{openvas_debug}{rgb}{0.78,0.78,0.78}
\definecolor{openvas_false_positive}{rgb}{0.2275,0.2275,0.2275}
\definecolor{openvas_log}{rgb}{0.2275,0.2275,0.2275}
\definecolor{openvas_hole}{rgb}{0.7960,0.1137,0.0902}
\definecolor{openvas_note}{rgb}{0.3255,0.6157,0.7961}
\definecolor{openvas_report}{rgb}{0.68,0.74,0.88}
\definecolor{openvas_user_note}{rgb}{1.0,1.0,0.5625}
\definecolor{openvas_user_override}{rgb}{1.0,1.0,0.5625}
\definecolor{openvas_warning}{rgb}{0.9764,0.6235,0.1922}
\hypersetup{colorlinks=true,linkcolor=linkblue,urlcolor=blue,bookmarks=true,bookmarksopen=true}
\usepackage[all]{hypcap}

%\geometry{verbose,a4paper,tmargin=24mm,bottom=24mm}
\geometry{verbose,a4paper}
\setlength{\parskip}{\smallskipamount}
\setlength{\parindent}{0pt}

\title{PDF Report Test}
\pagestyle{headings}
\pagenumbering{arabic}
\begin{document}
This is a test of the PDF generation capabilities of your OpenVAS installation. Please ignore.
\end{document}
EOT
  pdflatex -interaction batchmode -output-directory $PDFTMPDIR $TEXFILE > /dev/null 2>&1
  if [ ! -f "$PDFTMPDIR/test.pdf" ]
  then
    log_and_print "WARNING: PDF generation failed, most likely due to missing LaTeX packages. The PDF report format will not work."
    log_and_print "SUGGEST: Install required LaTeX packages."
  else
    log_and_print "OK: PDF generation successful. The PDF report format is likely to work."
  fi
  if [ -f "$PDFTMPDIR/test.log" ]
  then
    cat $PDFTMPDIR/test.log >> $LOG
  fi
  rm -rf $PDFTMPDIR
fi

echo "Checking presence of ssh-keygen ..." >> $LOG
SSHKEYGEN=`type ssh-keygen 2> /dev/null`
if [ $? -ne 0 ]
then
  log_and_print "WARNING: Could not find ssh-keygen binary, LSC credential generation for GNU/Linux targets will not work."
  log_and_print "SUGGEST: Install ssh-keygen."
  HAVE_SSHKEYGEN=0
else
  log_and_print "OK: ssh-keygen found, LSC credential generation for GNU/Linux targets is likely to work."
  HAVE_SSHKEYGEN=1
fi
echo "" >> $LOG

if [ $HAVE_SSHKEYGEN -eq 1 ]
then
  echo "Checking presence of rpm ..." >> $LOG
  RPM=`type rpm 2> /dev/null`
  if [ $? -ne 0 ]
  then
    log_and_print "WARNING: Could not find rpm binary, LSC credential package generation for RPM and DEB based targets will not work."
    log_and_print "SUGGEST: Install rpm."
    HAVE_RPM=0
  else
    log_and_print "OK: rpm found, LSC credential package generation for RPM based targets is likely to work."
    HAVE_RPM=1
  fi
  echo "" >> $LOG

  if [ $HAVE_RPM -eq 1 ]
  then
    echo "Checking presence of alien ..." >> $LOG
    ALIEN=`type alien 2> /dev/null`
    if [ $? -ne 0 ]
    then
      log_and_print "WARNING: Could not find alien binary, LSC credential package generation for DEB based targets will not work."
      log_and_print "SUGGEST: Install alien."
      HAVE_ALIEN=0
    else
      log_and_print "OK: alien found, LSC credential package generation for DEB based targets is likely to work."
      HAVE_ALIEN=1
    fi
    echo "" >> $LOG
  fi
fi

echo "Checking presence of nsis ..." >> $LOG
NSIS=`type makensis 2> /dev/null`
if [ $? -ne 0 ]
then
  log_and_print "WARNING: Could not find makensis binary, LSC credential package generation for Microsoft Windows targets will not work."
  log_and_print "SUGGEST: Install nsis."
  HAVE_NSIS=0
else
  log_and_print "OK: nsis found, LSC credential package generation for Microsoft Windows targets is likely to work."
  HAVE_NSIS=1
fi
echo "" >> $LOG

echo ""
echo "It seems like your OpenVAS-$VER installation is OK."
echo ""
echo "If you think it is not OK, please report your observation"
echo "and help us to improve this check routine:"
echo "http://lists.wald.intevation.org/mailman/listinfo/openvas-discuss"
echo "Please attach the log-file ($LOG) to help us analyze the problem."
echo ""
