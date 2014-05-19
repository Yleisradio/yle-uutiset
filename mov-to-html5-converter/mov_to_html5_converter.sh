#!/bin/bash
# Script for converting files to html5 formats.
name=`basename ${1} .mov`
avconv -i ${name}.mov -vcodec libx264 -b:v 900k -maxrate 900k -bufsize 1000k -deinterlace -threads 0 -acodec libvo_aacenc -b:a 96k -aspect 16:9 ${name}.mp4
avconv -i ${name}.mov -s 4cif -ab 96k -vb 900k -deinterlace -threads 0 -aspect 16:9 ${name}.webm
avconv -i ${name}.mov -vcodec libtheora -acodec libvorbis -b:v 900k -threads 0 -aspect 16:9 ${name}.ogv