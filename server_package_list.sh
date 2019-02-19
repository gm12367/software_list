#!/bin/bash
HOST=<host IP>
USER=<your username>
PASS=<your password>
filename=`hostname`_package_list

yum list installed > package_list.txt
sed -i '1,/Installed Packages/d' package_list.txt
for i in "$(< package_list.txt)"
do
        echo -e $i > test.txt
done
cat test.txt|awk '{for(i=1;i<=NF;i++){print $i;}}'|awk NR%3==1 > array1.txt
cat test.txt|awk '{for(i=1;i<=NF;i++){print $i;}}'|awk NR%3==2 > array2.txt
cat test.txt|awk '{for(i=1;i<=NF;i++){print $i;}}'|awk NR%3==0 > array3.txt
#paste -d "\t" array1.txt array2.txt array3.txt | column -t > final.csv


function get_list()
{
        echo "<br/><font color=red>$filename</font>" > $filename.html
        echo "<br/><table border=1>" >> $filename.html
        echo "<tr><th>Package name</th><th>Package version</th><th>Package status</th></tr>" >> $filename.html

        mapfile -t serverArray1 < array1.txt
        mapfile -t serverArray2 < array2.txt
        mapfile -t serverArray3 < array3.txt
	
        for (( x = 0 ; x < ${#serverArray1[@]} ; x++))
        do
		
                        echo "<tr>" >> $filename.html
                        echo "<td>`echo "${serverArray1[x]}"`</td>" >> $filename.html
                        echo "<td>`echo "${serverArray2[x]}"`</td>" >> $filename.html
                        echo "<td>`echo "${serverArray3[x]}"`</td>" >> $filename.html
                        echo "</tr>" >> $filename.html
        done
        echo "</table>" >> $filename.html
}

get_list

echo "Starting to transfer..."
lftp -u ${USER},${PASS} sftp://${HOST} <<EOF
cd /tmp/lnx_server_package_list
put $filename.html
EOF
rm -f array*.txt
rm -f test.txt

