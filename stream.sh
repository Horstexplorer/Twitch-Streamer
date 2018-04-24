echo "Checking existing files..."

if [ -f temp.txt ]
then
  echo "Removing temp.txt"
  rm -R temp.txt
fi
if [ -f playlist.txt ]
then
  echo "Removing playlist.txt"
  rm -R playlist.txt
fi
if [ -f stream.mp4 ]
then
  echo "Removing stream.mp4"
  rm stream.mp4
fi

echo "Generating new playlist..."
find -type f -name *.mp4 >> temp.txt
while read line; do echo "file '${line:2}'" >> playlist.txt ;done < temp.txt
rm -R temp.txt

echo "Concatenating files..."
ffmpeg -f concat -i playlist.txt -c copy stream.mp4

echo "Going online..."
ffmpeg -stream_loop -1 -i stream.mp4 -vcodec libx264 -crf 30 -preset medium -tune film  -tune fastdecode -r 30 -f flv rtmp://live.twitch.tv/app/<<streamkey>>

# Replace <<streamkey>> with your stream key for twitch
