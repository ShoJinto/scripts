#!/bin/bash
#
# this script can convert one type file to a nather type file
# you mast spect file path.
#


file_path=$1
suffix=$2
target_name=$3

usage()
{
	echo -e "Usage: $0 <file_path> <suffix> <target_name>	to convert files. \n
For example: $0 /path/to/path py code.txt				
"
}

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
convert()
{
	for i in `find $file_path -name "*.$suffix"`
	do
		echo -e "\n\n=======`dirname $i`/`basename $i`=======\n" >> $target_name
		cat `dirname $i`/`basename $i` >> $target_name
		#echo $i
	done
}

main()
{
	if [ $# -ne 2 ]; then
		usage
	else
		convert
	fi
}

main $file_path $suffix $target_name
