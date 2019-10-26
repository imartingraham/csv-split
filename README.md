# CSV Split

Developed and tested on Ruby 2.4.0

A ruby script that splits a large csv file into smaller files and stores the smaller files into the ```split-files``` directory.

This script has seven (7) parameters:

```
Options:
	 --file-path  <path/name.cvs>             : Path to csv file to be split
     --new_file_name <path/name.cvs>        : Allow user to change name of processed split files
	 --include-headers, --no-include-headers  : Include headers in new files (default: true)
	 --line-count <number>                    : Number of lines per file (default: 2500)
     --delimiter <delimiter>                : Allows user to change comma delimited to another Character
     --remove_columns                       : After split it performed, loads remove.csv, creates 2nd directory process split files rmoving those columns
     --help, -h                             : Show this message
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
