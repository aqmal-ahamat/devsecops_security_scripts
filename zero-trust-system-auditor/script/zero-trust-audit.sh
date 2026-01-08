#!/bin/bash

#SECURITY AUDIT 01  -- CHECK FOR USERS WITH NO PASSWORDS FOR LOGING IN.
USERS_WITH_NO_PASSWORDS=()
mapfile -t USERS < <(sudo cat /etc/shadow)
for user in ${USERS[@]}; do
	password=$(echo $user | awk -F: '{print $2}')
	if [ -z $password ]; then
		USERS_WITH_NO_PASSWORDS+=($(echo $user | awk -F: '{print $1}'))
	fi
done


#SECURITY AUDIT 02 -- CHECK IF SENSITIVE FILES ARE WORLD-WRITABLE

FILES_READ_ONLY=(/etc/passwd)
FILES_NO_PERMISSION=(/etc/shadow)
RISKY_FILES=()

for file in ${FILES_NO_PERMISSION[@]}; do
	permissions=$(stat -c "%a" $file)
	upermissions=$(stat -c "%a" $file | awk -v i="${#permissions}" '{print substr($0,i,1)}')

	if [ $upermissions -ne 0 ]; then
		RISKY_FILES+=($file)
	fi
done

for file in ${FILES_READ_ONLY[@]}; do
        permissions=$(stat -c "%a" $file)
        upermissions=$(stat -c "%a" $file | awk -v i="${#permissions}" '{print substr($0,i,1)}')

        if [ $upermissions -ne 4 ]; then
                RISKY_FILES+=($file)
        fi
done

#SECURITY AUDIT 03 -- CHECK FOR FILES WITH SUID SET.
mapfile -t SUID_FILES < <(sudo find / -perm /4000 -perm /002 2>/dev/null)


#FINAL AUDIT RESUTL OUTPUT

echo "--------------------------------------------------------------------"
echo " "

if [ ${#USERS_WITH_NO_PASSWORDS[@]} -eq 0 ]; then
	echo "All users are SECURED with a password. ✅"
else
	echo "Here are the users with no passwords ❌: ${USERS_WITH_NO_PASSWORDS[@]}"
fi



echo " "
echo "--------------------------------------------------------------------"
echo " "

if [ ${#RISKY_FILES[@]} -eq 0 ]; then
        echo "No files / directories have unwanted user permissions ✅"
else
        echo "Here are Files with unwanted user permissions ❌: ${RISKY_FILES[@]}"
fi



echo " "
echo "--------------------------------------------------------------------"
echo " "

if [ ${#SUID_FILES[@]} -eq 0 ]; then
        echo "No SUID files with write permission set. ✅"
else
        echo "Here are the SUID Files with write permission Enabled ❌: "
	for item in  ${SUID_FILES[@]}; do
                echo "		${item}"
        done
fi



echo " "
echo "--------------------------------------------------------------------"
