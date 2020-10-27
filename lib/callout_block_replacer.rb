
class CalloutBlockReplacer
  attr_accessor :block_string

  def initialize(block_string)
    self.block_string = block_string
  end

  def get_markdown()
    json_string = block_string.strip[15..-9]
    h = JSON.parse(json_string)
    type = h['type']
    title = (h['title'] ? " #{h['title']}" : nil)
    body = h['body']

    <<~MARKDOWN
    :::#{type}#{title}
    #{body}
    :::
    MARKDOWN
  end

  def self.scan(body)
    body.gsub /\[block:callout\](.+?)\[\/block\]/m do |str|
      puts "Found Callout block ..."
      CalloutBlockReplacer.new(str).get_markdown
    end
  end
end

