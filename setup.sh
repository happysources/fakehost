#!/bin/bash

GIT_OWNER="https://github.com/happysources"
GIT_REPO="fakehost"

TMP_DIR="/tmp/${GIT_REPO}"
INST_DIR="/usr/bin"

echo "start ... "
echo

# redhat
if [ -f "/etc/redhat-release" ]; then
	DISTNAME="redhat";
	DISTFILE="/etc/redhat-release";

# centos
elif [ -f "/etc/centos-release" ]; then
	DISTNAME="centos";
	DISTFILE="/etc/redhat-release";

# fedora
elif [ -f "/etc/fedora-release" ]; then
	DISTNAME="fedora";
	DISTFILE="/etc/redhat-release";

# debian
elif [ -f "/etc/debian_version" ]; then
	DISTNAME="debian";
	DISTFILE="/etc/debian_version";

# other
elif [ -f "/etc/os-release" ]; then
	DISTNAME=`cat /etc/os-release  | grep -v "_ID=" | grep "ID=" | cut -d"=" -f2`;
	DISTFILE="/etc/os-release";
	
else
	echo "unsupported linux distribution. exit";
	exit;
fi

echo "distribution ... "
echo "* name: $DISTNAME ";
echo -n "* version: "
cat $DISTFILE 

# install apt for rhel os
if [ "$DISTNAME" = "redhat" ] || [ "$DISTNAME" = "centos" ] || [ "$DISTNAME" = "fedora" ]; then
	echo "* $DISTNAME install apt"
	yum install apt;
fi;

# test if sudo install
if [ ! -f "/usr/bin/sudo" ]; then
	echo "* sudo install"
	apt install sudo
fi;

# test if git install
if [ ! -f "/usr/bin/git" ]; then
	echo "* sudo git"
	sudo apt install git
fi;

echo
cd /tmp/

echo "${GIT_REPO} ... "

echo -n "* clean ... "
sudo rm -rf $TMP_DIR
echo "done."

echo -n "* git clone ... "
git clone -q ${GIT_OWNER}/${GIT_REPO}.git
echo "done."

echo -n "* create dir ... "
sudo mkdir -p $INST_DIR
echo "done."

echo -n "* script install ... "
sudo cp -v ${GIT_REPO}/${GIT_REPO}.py $INST_DIR/${GIT_REPO}; 
sudo chmod 755 ${INST_DIR}/${GIT_REPO};
echo "done."

echo -n "* clean ... "
sudo rm -rf $TMP_DIR
echo "done."

echo
echo "end."
