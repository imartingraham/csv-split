require 'trollop'
require 'fileutils'  #Added for file management
require 'csv'	     

# I want to deeply thank https://github.com/imartingraham for providing this original work
#
# I had to do a legal production and used the base project and add features as needed.
#
# Key features are custom delimiter, spliting the files then removing columns that were needed. {in my case for redaction}
#
# I appologize for some of the slope structure but it should be straight forward and a good learning experience.
#
# Regards wb 0727/2017
#

opts = Trollop::options do
  opt :file_path, "Path to csv file to be split", type: :string, default: nil
  opt :new_file_name, "Name of the new files. This will be appended with an incremented number", type: :string, default: 'split' #Please note later i change the default name to {original_filename}-{inc#}.csv
  opt :include_headers, "Include headers in new files", default: true, type: :boolean
  opt :line_count, "Number of lines per file", default: 1, type: :integer #change default to 1
  opt :delimiter, "Charcter used for Col. Sep.", default: ',', type: :string #Add custom delimiter
  opt :remove_columns, "Specify column names to be removed during processing in remove_coluns.txt", default: false, type: :boolean #Add Remove Column processing with remove.csv
end

#Remind users to provide ARGVs at command-line
if opts[:file_path].nil?
	print "Must provide Path & Filename for processing  {add} --{file-path path/to/csv/file}/{filename}.csv"
	exit
end

#Get path for processing
path_name = File.dirname(opts[:file_path])

#Stop if remove_columns is enbabled but remove.csv is missing and/or broken
if opts[:remove_columns] == true
	#Stop if remove.csv missing or broken
	unless File.exists?("#{path_name}/remove.csv")
		puts "remove.csv is missing or mis-formatted. Please check remove-sample.csv for format"
		exit
	end
end

#Disliked Converted file as directory name so changed defual to split-files
split_path_name = "split-files"

#Clean-up previous processing of file by deleting previously processes split-file directory
if File.exists?(split_path_name)
	FileUtils.rm_r "#{path_name}/#{split_path_name}"
	FileUtils::mkdir_p "#{path_name}/#{split_path_name}"
else
	FileUtils::mkdir_p "#{path_name}/#{split_path_name}"
end


######
#
# Note the following changes the default filename. This seemed more logical to me.
#
######

#Change default of split files to the original file name unless recieves input
if opts[:new_file_name] == "split"
	s = opts[:file_path]
	s_name = s.split('/')[-1] #Get name of original CSV without path
	split_name = s_name.split('.')[0]
else
	s = opts[:new_file_name]
	s_name = s.split('/')[-1] #Sanitizing incase user adds a path but overkill
	split_name = s_name.split('.')[0]
end 



file = File.expand_path(opts[:file_path])
col_data = []
index = 1
file_int = 0
new_file_tmp = "#{split_path_name}/#{split_name}-%d.csv"
new_file = sprintf new_file_tmp, file_int
headers = [];

CSV.foreach(file, {headers: true, encoding: "UTF-8", quote_char: '"', col_sep: opts[:delimiter]}) do |row|

  if opts[:include_headers] && headers.empty?
    headers = row.to_hash.keys
  end
  col_data << row
  if index % opts[:line_count] == 0
    CSV.open(new_file, "wb", force_quotes: true) do |csv|
      
      if opts[:include_headers]
        csv << headers
      end

      col_data.each do |d|
        csv << d
      end


    end
    file_int = file_int + 1
    new_file = sprintf new_file_tmp, file_int
    col_data = []

  end
  index = index + 1
end

#Added se the ability to process the split files (leaving original split files) and removing columns

if opts[:remove_columns] == true
	
	#Clean-up previous processing and create new directory fo rthe split files with columns removed
	split_path_name_rmv_cols = "split-files-rmv-cols"
	if File.exists?(split_path_name_rmv_cols)
		FileUtils.rm_r "#{path_name}/#{split_path_name_rmv_cols}"
		FileUtils.mkdir_p "#{path_name}/#{split_path_name_rmv_cols}"
	else
		FileUtils.mkdir_p "#{path_name}/#{split_path_name_rmv_cols}"
	end
	
	Dir.glob("#{path_name}/#{split_path_name}/*.csv") do |csv_name|
		
		original = CSV.read(csv_name, { headers: true, return_headers: true, encoding: "UTF-8", quote_char: '"', col_sep: opts[:delimiter] })

		rmv_col_names =[]
		rmvr = 0
		
		list = CSV.foreach('remove.csv', {headers: true, encoding: "UTF-8", quote_char: '"', col_sep:","}) do |row|	
			rmv_col_names << row[0] 
		end
		
		rmv_col_count = rmv_col_names.count
		
		while rmvr < (rmv_col_count-1)	      
			original.delete("#{rmv_col_names[rmvr]}")
			rmvr +=1
		end
								
		csv_rmv_name = csv_name.split('/')[-1]	
			
		CSV.open("#{path_name}/#{split_path_name_rmv_cols}/#{csv_rmv_name}", 'w') do |csv|
		  original.each do |row|
		    csv << row
		  end
		end
	end
end	
