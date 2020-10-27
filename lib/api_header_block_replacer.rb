
class ApiHeaderBlockReplacer
  attr_accessor :block_string

  def initialize(block_string)
    self.block_string = block_string
  end

  def get_markdown()
    json_string = block_string.strip[18..-9]
    h = JSON.parse(json_string)

    "# #{h['title']}"
  end

  def self.scan(body)
    body.gsub /\[block:api-header\](.+?)\[\/block\]/m do |str|
      puts "Found API Header block ..."
      ApiHeaderBlockReplacer.new(str).get_markdown
    end
  end
end

