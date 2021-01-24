require "convert_json_to_env"
require "thor"

# ref(https://qiita.com/akisame338/items/92379addeb1a17468498
module ConvertJsonToEnv
  class CLI < Thor
    desc "convert {json}", "convert {json} to {CAMEL_CASE_KEY=value}"
    def convert(file)
      buffer = []
      File.open(file) do |f|
        f.each_line do |line|
          line.gsub!(/^.*(?=: \")/) do
            $&.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
              .gsub(/([a-z\d])([A-Z])/, '\1_\2')
              .upcase
          end
          line.gsub!(/\:\s\"/, '=')
          line.gsub!(/\"|,/, '')
          buffer.push(line)
        end
      end

      File.open(file, 'w+') do |f|
        f.write(buffer.join)
      end
    end
  end
end