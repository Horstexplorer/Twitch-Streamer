echo -e "[\033[1;32mInfo\033[0m] Checking existing files..."

if [ -f temp.txt ]
then
  echo -e "[\033[1;33mDEL\033[0m] Removing temp.txt"
  rm -R temp.txt
fi
if [ -f playlist.txt ]
then
  echo -e "[\033[1;33mDEL\033[0m] Removing playlist.txt"
  rm -R playlist.txt
fi
if [ -f stream.mp4 ]
then
  echo -e "[\033[1;33mDEL\033[0m] Removing stream.mp4"
  rm stream.mp4
fi

echo -e "[\033[1;32mInfo\033[0m] Generating new playlist..."
find -type f -name '*.mp4' >> temp.txt
while read line; do echo "file '${line:2}'" >> playlist.txt ;done < temp.txt
rm -R temp.txt

echo -e "[\033[1;32mInfo\033[0m] Concatenating files..."
ffmpeg -err_detect ignore_err -loglevel panic -f concat -i playlist.txt -c copy stream.mp4

echo -e "[\033[1;32mInfo\033[0m] Going online..."
sleep 5
ffmpeg -err_detect ignore_err -stream_loop -1 -re -i stream.mp4 -vcodec libx264 -crf 30 -preset medium -tune film  -tune fastdecode -b:v 3M -maxrate 8M -minrate 2M -bufsize 2M -ar 44100 -f flv rtmp://live.twitch.tv/app/<<streamkey>>
#Things like "Non-monotonous DTS in output stream" or "Past duration x.xxxxxx too large" occure sometimes. Not sure why but I try to fix it soon.

# Replace <<streamkey>> with your stream key for twitch
