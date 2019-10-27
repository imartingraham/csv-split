# CSV Split

Developed and tested on Ruby 2.4.0

A ruby script that splits a large csv file into smaller files and stores the smaller files into the ```split-files``` directory.

This script has eight parameters:

```
Options:
  -f, --file-path=<s>                         Path to csv file to be split
  -n, --new-file-name=<s>                     Name of the new files. This will be appended with an incremented number (default: split)
  -i, --include-headers, --no-include-headers Include headers in new files (default: true)
  -l, --line-count=<i>                        Number of lines per file (default: 1)
  -d, --delimiter=<s>                         Charcter used for Col. Sep. (Default: ,)
  -r, --remove-columns                        Specify column names to be removed during processing in remove_coluns.txt
  -c, --include-remainders                    Include remainder rows in the split files (default: false). Example: if there are 1030 rows in a csv file and will be split in 100 rows, the remaining 30 rows will be stored in a new file
  -h, --help                                  Show this message
```

## Required Gems

- [optimist](https://github.com/ManageIQ/optimist)

## Installation

1. Clone repository
2. Install the required gem:
	```
	gem install optimist
	```

## Running the script

```
ruby csv-split.rb --file-path path/to/csv/file/.csv --line-count 2500 --include-headers
```
