
class EmbedBlockReplacer
  attr_accessor :block_string

  def initialize(block_string)
    self.block_string = block_string
  end

  def get_markdown()
    json_string = block_string.strip[13..-9]
    h = JSON.parse(json_string)

    <<~HTML
      <iframe src="#{h['url']}"></iframe>
    HTML
  end

  def self.scan(body)
    body.gsub /\[block:embed\](.+?)\[\/block\]/m do |str|
      puts "Found embed block ..."
      EmbedBlockReplacer.new(str).get_markdown
    end
  end
end

