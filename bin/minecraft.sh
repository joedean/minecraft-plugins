#!/bin/sh
if [ "$1" != "check_env" ]; then
  echo "Usage: $0 check_env"
  exit 1
fi
ACCEPTABLE_JAVA_VERSION=6
JAVA_VERSION=`java -version 2>&1 | head -1 | awk -F '"' '{print $2}'`

if [ ${JAVA_VERSION} = "" ]; then
  echo Please install Java
else
  JAVA_MAJOR_VERSION=`echo ${JAVA_VERSION} | cut -d '.' -f 2`
fi

if [ ${JAVA_MAJOR_VERSION} -lt ${ACCEPTABLE_JAVA_VERSION} ]; then
  echo You need to upgrade Java
else
  # check if wget is installed, if not install.
  if [ -d ~/.coderdojo ]; then
    cd ~/.coderdojo
  else
    cd ~ && mkdir .coderdojo && cd .coderdojo
  fi

  if [ -f ~/.coderdojo/jruby-complete.jar ]; then
    echo good job you have jruby!
  else
    wget http://jruby.org.s3.amazonaws.com/downloads/1.7.10/jruby-complete-1.7.10.jar
    mv jruby-complete-1.7.10.jar jruby-complete.jar
  fi
fi
