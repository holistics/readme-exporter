
class CodeBlockReplacer
  attr_accessor :block_string

  def initialize(block_string)
    self.block_string = block_string
  end

  def get_markdown()
    json_string = block_string.strip[12..-9]
    h = JSON.parse(json_string)

    markdowns = h['codes'].map do |item|
      code = item['code']
      language = item['language']
      puts "  Language: #{language}"

      <<-MARKDOWN
```#{language}
#{code}
```
      MARKDOWN
    end
    markdowns.join("\n")
  end

  def self.scan(body)
    body.gsub /\[block:code\](.+?)\[\/block\]/m do |str|
      puts "Found code block ..."
      CodeBlockReplacer.new(str).get_markdown
    end
  end
end

