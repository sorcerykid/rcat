#!/bin/tcsh

# Usage Example:
#  ~/rcat/restore.csh remote:weeklies/pub_worlds_jt2.tar
#  ~/rcat/restore.csh remote:dailies/minetest/worlds/jt2/auth.txt.tar

set CACHE_PATH = "/home/share"
set CLOUD_PATH = $1:h
set CHUNK_NAME = $1:t:r

echo "Starting multipart restore for $CHUNK_NAME.tar"

echo "1" > $CACHE_PATH/rclone.seq

$0:h/transfer.csh download $CACHE_PATH $CHUNK_NAME $CLOUD_PATH

/bin/tar -F "$0:h/transfer.csh download $CACHE_PATH $CHUNK_NAME $CLOUD_PATH" -xvf $CACHE_PATH/rclone.tar

rm $CACHE_PATH/rclone.seq
rm $CACHE_PATH/rclone.tar

echo "Finished."
