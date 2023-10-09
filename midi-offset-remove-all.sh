#!/bin/bash
#
# Converts all midi files in given folder to csv and back to midi
# It removes the empty spacing in front of the position parameter of all midi files
# The first cue will start at time "0"

# run
# `sh midi-t-csv.sh <input file path>`

# Check for missing parameters
if [ $# -lt 1 ]; then
  echo 1>&2 "$0: Error: Input path missing.\n Use like this.:\n 'sh midi-offset-remove-all.sh <input file path>'"
  exit 2
fi

script_dir="$(dirname "$0")"
input_file_path="${1}"

for midiFile in ${input_file_path}/*.mid ;
do
    sh midi-offset-remove.sh "${midiFile}"
done
