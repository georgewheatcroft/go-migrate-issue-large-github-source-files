#!/usr/bin/env bash

err_msg_exit(){
    echo $1
    exit 1
}

for dependency in  "docker" "psql" "migrate" ; do 
    which $dependency > /dev/null || err_msg_exit "need to install $dependency to run this test" 
done

#this should fail specifying encoding issue - which really appears to be an error coming from the github client's
#attempts to pull the large insert file (7k lines, over 1MB in size) from github
migrate -verbose -database 'postgres://example:password123@localhost:5432/exampledb?sslmode=disable' -source "github://georgewheatcroft/go-migrate-issue-large-github-source-files/migrations"  up

