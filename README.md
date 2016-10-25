#CSV Split

A ruby script that splits a large csv file into smaller files and stores the smaller files into the ```converted-files``` directory.

This script has three parameters:

```
Options:
                          --file-path, -f <s>:   Path to csv file to be split
  --include-headers, --no-include-headers, -i:   Include headers in new files (default: true)
                         --line-count, -l <i>:   Number of lines per file (default: 2500)
                                   --help, -h:   Show this message
```

## Required Gems
- trollop
- csv

## Installation

1. Clone repository
2. Install required gem:
		
	``` 
	gem install trollop 
	
	```


## Running the script

```
ruby csv-split.rb --file-path path/to/csv/file/.csv --line-count 2500 --include-headers

```

