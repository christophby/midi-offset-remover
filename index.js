import { promises as fs, existsSync } from 'fs';
import { parse } from 'csv';
import process from 'process';
import { rm, writeFile } from 'fs/promises';

const delimiter = ',';
const outPathName = 'out';

async function main() {
  // Read csv
  const filePath = process.argv[2];
  const content = await fs.readFile(`${filePath}`);
  // Parse csv
  const records = parse(content, {
    bom: true,
    delimiter,
    relax_column_count: true,
    relax_quotes: true,
    trim: true,
  });

  const recordsAsArray = await records.toArray();

  /*
        Modify rows aka midi
    */
  // let firstCommandRow = null;
  let firstCommandRowTimeOffset = null;

  const recordsWithCleanedOffset = recordsAsArray.map((row) => {
    const newRow = [...row];
    const indexGroup = parseInt(row[0], 10); // 0 is header, 1 is temp, 2 is usually Program_c
    const timeEntry = parseInt(row[1], 10);
    const typeEntry = row[2];

    // Find first entry where time > 0 to store offset
    if (
      firstCommandRowTimeOffset === null &&
      indexGroup === 2 &&
      timeEntry > 100 &&
      typeEntry !== 'End_track'
    ) {
      // firstCommandRow = row;
      firstCommandRowTimeOffset = timeEntry;
    }

    if (firstCommandRowTimeOffset !== null && timeEntry > 0) {
      newRow[1] = timeEntry - firstCommandRowTimeOffset;
    }

    return newRow;
  });
  // console.log(recordsWithCleanedOffset);

  // Convert data to csv-string
  const recordsAsString = recordsWithCleanedOffset.reduce((acc, row) => {
    // eslint-disable-next-line no-param-reassign
    acc += `${row.join(', ')}\n`;
    return acc;
  }, '');

  // Generate new full path name
  let newFileNamePath = filePath.split('/');
  newFileNamePath.splice(newFileNamePath.length - 1, 0, outPathName);

  // Path without filename
  let outPath = [...newFileNamePath];
  outPath.pop();
  outPath = outPath.join('/');

  newFileNamePath = newFileNamePath.join('/'); // .replace('.csv', '_new.csv');

  // console.log('outPath:', outPath, newFileNamePath);

  if (!existsSync(outPath)) {
    await fs.mkdir(outPath);
  }

  // Write new csv
  await writeFile(`${newFileNamePath}`, recordsAsString, 'utf8');
  // console.log('Wrote file:', newFileNamePath);

  // Remove input-csv-file
  await rm(filePath);
  console.log(newFileNamePath);
}

main();
