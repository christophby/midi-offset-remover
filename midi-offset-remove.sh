#!/bin/bash
#
# Convert one midi file to csv
#

# run
# `sh midi-offset-remove.sh <midi file path.mid>`

# Check for missing parameters
if [ $# -lt 1 ]; then
  echo 1>&2 "$0: Error: input file missing"
  exit 2
fi

script_dir="$(dirname "$0")"
midiFile="${1}"

outfileFileCsvName=${midiFile//.mid/.csv} # replace .mid with .csv
echo "File: ${outfileFileCsvName}"

midicsvpy "${midiFile}" "${outfileFileCsvName}" # conversion to csv

# node script makes midi modification and creates new csv
generatedCsvFilePath=$(node "$script_dir/index.js" "${outfileFileCsvName}")
# node "$script_dir/index.js" "${outfileFileCsvName}"


#
# Convert csv to midi
#
csvFile=$generatedCsvFilePath
outfileFileName=${csvFile//.csv/.mid} # replace .csv with .mid
csvmidipy "${csvFile}" "${outfileFileName}"

echo "Wrote: ${outfileFileName}"
// Remove temp generated csv files
rm "${csvFile}"


