#!/bin/sh -l

sonar-scanner \
	-Dsonar.host.url=$1 \
	-Dsonar.login=$2 \
  -Dsonar.projectBaseDir=$3 \
	-Dsonar.working.directory=/tmp \
&& chmod -R go+rw $GITHUB_WORKSPACE
