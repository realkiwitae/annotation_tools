#!/bin/bash

# Replace with the path to your video file
input_file=$1
crop_settings=$2

# Set the number of frames to extract
N=$3

echo "------------- CROP IMAGE"
echo ffmpeg -i $input_file -filter:v "$crop_settings" -y cropped.mp4
ffmpeg -i $input_file -filter:v "$crop_settings"  -y cropped.mp4
echo "------------- CROP IMAGE OK"
echo "------------- GET RANDOM IMAGES"
duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "./cropped.mp4")

# Use the 'shuf' command to randomly select N timestamps from the video
timestamps=$(seq 0 0.1 $duration | shuf -n $N | sort -n)

# Extract the frames at the selected timestamps
for timestamp in $timestamps
do
  # Construct the output file name based on the timestamp

  timestamp=$(echo $timestamp | sed 's/,/./g')
  mkdir "./images"
  output_file="./images/$(basename "$input_file" .mp4)_${timestamp}s.png"
echo $output_file
  # Use FFmpeg to extract the frame at the current timestamp
  ffmpeg -ss $timestamp -i "./cropped.mp4" -frames:v 1 -vf scale="iw:ih/sar" -y "$output_file"
done
