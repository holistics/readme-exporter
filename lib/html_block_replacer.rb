
class HtmlBlockReplacer
  attr_accessor :block_string

  def initialize(block_string)
    self.block_string = block_string
  end

  def get_markdown()
    json_string = block_string.strip[12..-9]
    h = JSON.parse(json_string)
    h['html']
  end

  def self.scan(body)
    body.gsub /\[block:html\](.+?)\[\/block\]/m do |str|
      puts "Found HTML block ..."
      HtmlBlockReplacer.new(str).get_markdown
    end
  end
end

