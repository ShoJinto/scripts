#!/bin/bash
#
# this script can convert one type file to a nather type file
# you mast spect file path.
#


file_path=trunk


# while version
#find $file_path -name *.cs >> filename
#while read LINE
#do
#	echo -e "\n\n=======`dirname $LINE`/`basename $LINE`=======\n" >> code.txt
#	cat `dirname $LINE`/`basename $LINE` >> code.txt
#	#echo $LINE
#done < filename
#rm -rf filename 

# for version
for i in `find $file_path -name *.cs`
do
	echo -e "\n\n=======`dirname $i`/`basename $i`=======\n" >> code.txt
	cat `dirname $i`/`basename $i` >> code.txt
	#echo $i
done
