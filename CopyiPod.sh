#!/bin/bash
mkdir -p $HOME/Desktop/music_from_ipod/

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     dirs=(/media/*);;
    Darwin*)    dirs=(/Volumes/*);;
esac

read -p "$(
        f=0
        for dirname in "${dirs[@]}" ; do
                echo "$((++f)): $dirname"
        done

        echo -ne 'Please select ipod > '
)" selection

selected_dir="${dirs[$((selection-1))]}/"

echo "Finding Files in '$selected_dir'"
echo "This may take a while......"
rm -rf $HOME/Desktop/music_from_ipod/found_music_files.txt
find $selected_dir 2>/dev/null | grep -i -e M4A$ -e M4B$ -e M4P$ -e MP3$ -e WAV$ -e AA4$ -e AIFF$ >> $HOME/Desktop/music_from_ipod/found_music_files.txt

n_items=$(cat $HOME/Desktop/music_from_ipod/found_music_files.txt | wc -l)
echo "Found " $n_items " on ipod"
echo "Begining Processing..."
sleep 3
i=0
while read file;
do
  cp "$file" $HOME/Desktop/music_from_ipod/
  i=$((i+1))
  echo $((100 * i / n_items)) | dialog --stdout --gauge "Processing $n_item songs..." 10 70 0
done < $HOME/Desktop/music_from_ipod/found_music_files.txt;
