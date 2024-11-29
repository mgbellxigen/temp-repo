#!/bin/bash
# ------------------------ ADD ANY EXCLUDES TO THIS ARRAY ------------------------ #
# Syntax should be as follows: ("item1" "item2" "item3")
excludes=("Semrush" "SemrushBot" "AhrefsBot" "Screaming" "oBot")

#Fetch list of bad User-Agent strings
userAgents=$(curl -s https://raw.githubusercontent.com/mitchellkrogza/nginx-ultimate-bad-bot-blocker/refs/heads/master/_generator_lists/bad-user-agents.list)

#Check to see if our fetch worked, die if not
if [ ${#userAgents} = 0 ]; then
  echo 'Failed to fetch User-Agent list, exiting...'
  exit 1
fi

userAgents=$(echo "$userAgents" | grep -v '\\' | grep -v '\/')

if [ ${#excludes} != 0 ]; then
  for i in "${excludes[@]}"
do
  :
 userAgents=$(echo "$userAgents" | grep -vw $i)
done  
fi

userAgents=($userAgents)

for i in "${userAgents[@]}"
do
  :
  echo "if (\$http_user_agent ~ ('$i')) {
       return 403;
}"

done  > bad-bots-tmp.conf

sed "s/'//g" bad-bots-tmp.conf > bad-bots.conf

rm bad-bots-tmp.conf

cat bad-bots.conf
