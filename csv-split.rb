require 'trollop'
require 'csv'

opts = Trollop::options do
  opt :file_path, "Path to csv file to be split", type: :string
  opt :new_file_name, "Name of the new files. This will be appended with an incremented number", type: :string, default: 'split_file'
  opt :include_headers, "Include headers in new files", default: true, type: :boolean
  opt :line_count, "Number of lines per file", default: 2500, type: :integer
end


file = File.expand_path(opts[:file_path])
col_data = []
index = 1
file_int = 0
new_file_tmp = "converted-files/#{opts[:new_file_name]}_%d.csv"
new_file = sprintf new_file_tmp, file_int
headers = [];
CSV.foreach(file, {headers: true, encoding: "windows-1251:utf-8", quote_char: '"', col_sep: "," }) do |row|

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
