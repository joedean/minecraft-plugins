#!/bin/sh
if [ "$1" != "check_env" ]; then
  echo "Usage: $0 check_env"
  exit 1
fi

SCRIPT='lib/check_environment.rb'
JVM_HEAP_STACK_SETTINGS='-Xmx500m -Xss1024k'
ACCEPTABLE_JAVA_VERSION=6
JAVA_VERSION=`java -version 2>&1 | head -1 | awk -F '"' '{print $2}'`

if [ ${JAVA_VERSION} = "" ]; then
  echo Please install Java or configure PATH correctly
  exit 1
fi
JAVA_MAJOR_VERSION=`echo ${JAVA_VERSION} | cut -d '.' -f 2`

if [ ${JAVA_MAJOR_VERSION} -lt ${ACCEPTABLE_JAVA_VERSION} ]; then
  echo You need to upgrade Java
  exit 1
fi

# check if wget is installed, if not install.
if [ ! -d ~/.coderdojo ]; then
  mkdir ~/.coderdojo
fi
cd ~/.coderdojo
if [ ! -f ~/.coderdojo/jruby-complete.jar ]; then
  wget http://jruby.org.s3.amazonaws.com/downloads/1.7.10/jruby-complete-1.7.10.jar
  mv jruby-complete-1.7.10.jar jruby-complete.jar
fi

java ${JVM_HEAP_STACK_SETTINGS} -jar ~/.coderdojo/jruby-complete.jar ${SCRIPT}
