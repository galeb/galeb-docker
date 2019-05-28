#!/bin/bash

SERVICE=router
VERSION=$1

# RPM

yum install -y /mnt/jdk/*.rpm

# START

getent group galeb > /dev/null 2>&1 || groupadd -r galeb
if getent group galeb > /dev/null 2>&1; then id galeb > /dev/null 2>&1 || useradd -M -r -g galeb -d /opt/galeb galeb;fi

PID_FILE="/run/galeb.pid"
JAVA_VMS="-Xms1024m"
JAVA_VMX="-Xmx1024m"
su -l -s /bin/bash galeb <<EOF
/usr/bin/java \
  -server \
  -XX:+UseParallelGC \
  -XX:+PerfDisableSharedMem \
  -Djavax.net.ssl.keyStore=/etc/pki/java/cacerts \
  -Djavax.net.ssl.trustStore=/etc/pki/java/cacerts \
  -Dcom.sun.management.jmxremote.port=9999 \
  -Dcom.sun.management.jmxremote.authenticate=false \
  -Dcom.sun.management.jmxremote.ssl=false \
  -Dcom.sun.management.jmxremote=true \
  -Dlogging.config=/mnt/log4j2.xml \
  -DLog4jContextSelector=org.apache.logging.log4j.core.async.AsyncLoggerContextSelector \
  ${JAVA_VMS} \
  ${JAVA_VMX} \
  -jar /mnt/target/galeb-${SERVICO}-${VERSION}-SNAPSHOT.jar
EOF

#EOF
