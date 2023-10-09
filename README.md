# Midi Offset Remover

**This tool removes empty spacing before the first midi event.**

## Problem

If you export a Midi region as a Midi file in *Logic Pro*, the position of all Midi events in the Midi file are absolute and not relative.

*What does that mean?*
If you have a Midi note or Midi command in a Logic Pro project at minute 02:00:00 and you make a Midi export, starting at that note, the resulted Midi file will include a Midi Note at minute 02:00:00. What we want is a Midi note at 00:00:00. This tool transforms the Midi notes/cc/program changes according to that.

**Midi file before:**

*Example data*

| Midi Channel | Midi CC | Time  | *Time diff to note before* |
| :----------- | ------- | ----- | -------------------------- |
| 2            | 1       | 02:30 | -                          |
| 2            | 2       | 02:40 | *00:10*                    |
| 3            | 3       | 03:00 | 00:20                      |

**Midi file after:**

*Example data*

| Midi Channel | Midi CC | Time  | *Time diff to note before* |
| :----------- | ------- | ----- | -------------------------- |
| 2            | 1       | 00:00 | -                          |
| 2            | 2       | 00:10 | *00:10*                    |
| 3            | 3       | 00:30 | 00:20                      |

## How to use

### Setup

1. Clone repo
2. Run `yarn` to install packages
3. Install [py-midicsv](https://pypi.org/project/py-midicsv/)
   `pip install py_midicsv`. This project uses its command line tool

### Run

1. Create an empty folder and put your Midi files in there which you want to be transformed, e.g. `/Downloads/TRANSFORM_MIDI`
2. Run `yarn start <your_directory>` or `sh midi-offset-remove-all.sh <your_directory>`.
   Following the example, it would be  `yarn start /Downloads/TRANSFORM_MIDI`
3. All files will be transformed. The new files will be places in the `out` directory inside the same folder.



### Hint

* Keep in mind that the first event in the source Midi file will always be at time 00:00:00 in the new file.
* You can also setup Automator (Mac) to auto-transform files as soon as you put them inside the folder.
