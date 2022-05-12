class FileContent
    def self.save(content:, filename:)
        begin
            File.open("./app/utils/" + filename, 'w') { |f| f.puts content }
        rescue => exception
            puts 'File does not exist. \n'
        end
    end

    def self.read(filename:)
        begin
            File.read("./app/utils/" + filename).strip
        rescue => exception
            puts 'File does not exist. \n'
        end
    end

end