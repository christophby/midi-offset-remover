#
# Convert all midi files in folder to csv
#

# Check for missing parameters
if [ $# -lt 1 ]; then
  echo 1>&2 "$0: Error: input path missing"
  exit 2
fi

input_file_path="${1}"
for midiFile in ${input_file_path}/*.mid ;
do
    outfileFileName=${midiFile//.mid/.csv} # replace .mid with .csv
    echo "File: ${outfileFileName}"
    midicsvpy "${midiFile}" "${outfileFileName}"

    node index.js "${outfileFileName}"
done

#
# Convert csv to midi
#
for csvFile in ${input_file_path}/out/*.csv ;
do
    outfileFileName=${csvFile//.csv/.mid} # replace .csv with .mid
    csvmidipy "${csvFile}" "${outfileFileName}"

    echo "Wrote: ${outfileFileName}"
    // Remove temp generated csv files
    rm "${csvFile}"
done

