#!/usr/bin/env bash

cd "$TRAVIS_BUILD_DIR" || exit 1

echo "==== DECLARE PLUGIN VERSION ===="
export PLUGIN_VERSION

if [ -n "$TRAVIS_TAG" ]; then
  echo "tag set -> set version to tag version"
  PLUGIN_VERSION=$(echo "$TRAVIS_TAG" | cut -d "v" -f 2)
else
  PLUGIN_VERSION=99.99.99
fi

echo "PLUGIN_VERSION is $PLUGIN_VERSION"

echo "==== INSTALL DEPENDENCIES ===="

echo -n "Downloading Java 13 ..."
wget -q https://cdn.azul.com/zulu/bin/zulu13.29.9-ca-jdk13.0.2-linux_x64.tar.gz
echo " done"
echo -n "Extracting Java 13 ..."
tar zxvf zulu13.29.9-ca-jdk13.0.2-linux_x64.tar.gz >/dev/null 2>&1
echo " done"
export JAVA_HOME=$TRAVIS_BUILD_DIR/zulu13.29.9-ca-jdk13.0.2-linux_x64
export PATH=$JAVA_HOME/bin:$PATH
echo -n "Downloading Java 14 ..."
wget -q https://download.java.net/java/GA/jdk14/076bab302c7b4508975440c56f6cc26a/36/GPL/openjdk-14_linux-x64_bin.tar.gz
echo " done"
echo -n "Extracting Java 14 ..."
tar zxvf openjdk-14_linux-x64_bin.tar.gz >/dev/null 2>&1
echo " done"

echo "JAVA_HOME=$JAVA_HOME"
echo "PATH=$PATH"
echo "JAVA_VERSION"
java -version
echo "MVN_VERSION"
mvn -version

echo "==== SET PLUGIN VERSION ===="
mvn versions:set -DnewVersion="$PLUGIN_VERSION"

echo "==== BUILD PLUGIN ===="
mvn versions:use-dep-version -DdepVersion="$PLUGIN_VERSION" -Dincludes=com.exxeta:correomqtt
mvn clean install

cd "$TRAVIS_BUILD_DIR" || exit 1