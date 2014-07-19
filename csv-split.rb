require 'trollop'
require 'csv'

opts = Trollop::options do
  opt :file_path, "Path to csv file to be split", type: :string
  opt :include_headers, "Include headers in new files", default: true, type: :boolean
  opt :line_count, "Number of lines per file", default: 2500, type: :integer
end


file = File.expand_path(opts[:file_path])
col_data = []
index = 1
file_int = 0
new_file = "converted-files/split_file_#{file_int}.csv"
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
    new_file = "converted-files/split_file_#{file_int}.csv"
    col_data = []

  end
  index = index + 1
end
