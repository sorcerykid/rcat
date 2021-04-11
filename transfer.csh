#!/bin/tcsh
# This script is to be invoked by backup.csh or restore.csh

set MODE = $1
set CACHE_PATH = $2
set CHUNK_NAME = $3
set CLOUD_PATH = $4
set SEQ = `cat $CACHE_PATH/rclone.seq`

switch ( $MODE )
	case "upload":
		echo "Uploading chunk #$SEQ to $CLOUD_PATH/$CHUNK_NAME.part$SEQ.tar"
		rclone -P copyto $CACHE_PATH/rclone.tar $CLOUD_PATH/$CHUNK_NAME.part$SEQ.tar
		breaksw
	case "download":
		echo "Downloading chunk #$SEQ from $CLOUD_PATH/$CHUNK_NAME.part$SEQ.tar"
		rclone -P copyto $CLOUD_PATH/$CHUNK_NAME.part$SEQ.tar $CACHE_PATH/rclone.tar
		breaksw
endsw

@ SEQ ++

echo $SEQ > $CACHE_PATH/rclone.seq
