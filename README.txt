Rcat v1.0
By By Leslie E. Krause

The rcat utility generates a multi-volume tar archive and uploads each volume to cloud 
storage via rclone. The entire process is automated, and therefore is perfectly suitable 
for a cronjob or as part of any scheduled backup routine.

Since each volume is only retained for the duration of the file transfer, it greatly
streamlines the process of backing up and restoring large amounts of data (like an entire
filesystem) when free hard drive space would otherwise be insufficient.

While there are a couple third-party tools with functionality similar to rcat, they are 
coded in Python and are much more sophisticated by comparison:

   https://github.com/eborisch/rpipe
   https://github.com/lbakyl/rClone_chunking

I prefer the simplest possible implementation when it comes to backing up important data,
particularly sincee customization might be necessary. Hence, I decided a shell script in 
combination with the multi-volume feature of tar was best suited for this purpose.

The command syntax for a backup operation is as follows:

   ~/rcat/backup.csh CHUNK_SIZE LOCAL_PATH CLOUD_PATH/CHUNK_NAME.tar

The required script parameters are

 * CHUNK_SIZE - the maximum file size for each volume of the tar archive, specified as a 
   whole number in kilobytes, or optionally in megabytes or gigabytes by suffixing "M" or 
   "G" respectively; sizes are base-2, thus 1M = 1024 kilobytes and 1G = 1024 megabytes
 * LOCAL_PATH - the directory or file to backup; absolute paths will be stripped of the 
   leading slash as is the default behavior of tar
 * CLOUD_PATH - the location where rclone will store the tar archive, typically to the
   cloud or a remote filesystem mounted with FUSE (the latter is less reliable)
 * CHUNK_NAME - the base filename for each volume of the tar archive, appended with the 
   ".tar" extension; the resulting files will be named as "CHUNK_NAME.partX.tar", where 
   "X" is the respective volume number.

Note: Be sure to edit the CACHE_PATH in "backup.csh" to point to a temporary directory 
with sufficient disk space for each volume (including adequate permissions). Once the
backup operation completes, the temporary files will be removed automatically.

Here are some example command invocations for backing up a directory and a file:

  ~/rcat/backup.csh 1G /tmp/worlds/jt2 remote:weeklies/tmp_worlds_jt2.tar
  ~/rcat/backup.csh 100M auth.txt remote:dailies/minetest/worlds/jt2/auth.txt.tar

The command syntax for a restore operation is as follows:

   ~/rcat/restore.csh CLOUD_PATH/CHUNK_NAME.tar

The required script parameters are

 * CLOUD_PATH - the location where rclone will retrieve the tar archive, typically from
   the cloud or a remote filesystem mounted with FUSE (the latter is less reliable)
 * CHUNK_NAME - the base filename for each volume of the tar archive, appended with the 
   ".tar" extension. The files must be named as "CHUNK_NAME.partX.tar," where "X" is the 
   respective volume number.

Note: Be sure to edit the CACHE_PATH in "restore.csh" to point to a temporary directory 
with sufficient disk space for each volume (including adequate permissions). Once the
restore operation completes, the temporary files will be removed automatically.

Here are the corresponding command invocations for restoring a directory and a file:

   ~/rcat/restore.csh remote:weeklies/pub_worlds_jt2.tar
   ~/rcat/restore.csh remote:dailies/minetest/worlds/jt2/auth.txt.tar

Keep in mind that directories and files will always be restored relative to the current 
working directory as illustrated below:

 * Backup: /tmp/worlds/jt2 -> Restore: ./tmp/worlds/jt2
 * Backup: ./auth.txt -> Restore: ./auth.txt

Note: You can adapt rcat for use with rsync or any other file-transfer utility by simply
editing "transfer.csh" accordingly.


Repository
----------------------

Browse source code...
  https://bitbucket.org/sorcerykid/rcat

Download archive...
  https://bitbucket.org/sorcerykid/rcat/get/master.zip
  https://bitbucket.org/sorcerykid/rcat/get/master.tar.gz

Dependencies
----------------------

Rclone can be downloaded from https://rclone.org/downloads/

Installation
----------------------

  1) Unzip the archive into your home directory.
  2) Rename the rcat-master directory to "rcat".
  3) Edit the CACHE_PATH setting in "backup.csh" accordingly.
  4) Edit the CACHE_PATH setting in "restore.csh" accordingly.

Source Code License
----------------------

MIT License

Copyright (c) 2021, Leslie E. Krause.

Permission is hereby granted, free of charge, to any person obtaining a copy of this
software and associated documentation files (the "Software"), to deal in the Software
without restriction, including without limitation the rights to use, copy, modify, merge,
publish, distribute, sublicense, and/or sell copies of the Software, and to permit
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.

For more details:
https://opensource.org/licenses/MIT

