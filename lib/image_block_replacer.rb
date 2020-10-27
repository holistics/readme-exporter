
class ImageBlockReplacer
  attr_accessor :readme_block, :image_path_prefix

  def download_image(url)
    uri = URI.parse(url)
    filename = File.basename(uri.path)

    r = Faraday.get(url)
    if r.status != 200
      puts "Error: #{response.status} - #{JSON.parse(response.body)['message']}"
      return
    end

    dest_filepath = "./gen_images/#{filename}"
    File.open(dest_filepath, 'wb') {|f| f.write(r.body)}
    filename
  end

  def initialize(readme_block, image_path_prefix: nil)
    self.readme_block = readme_block
    self.image_path_prefix = image_path_prefix
  end

  def get_markdown()
    h = JSON.parse(readme_block.strip[13..-9])

    markdowns = h['images'].map do |image|
      url = image['image'].first
      return '' if url.nil?

      puts "Downloading image #{url} ..."
      filename = download_image(url)

      cdn_filepath = "#{self.image_path_prefix}#{filename}"

      "\n![](#{cdn_filepath})\n"
    end
    markdowns.join("\n")
  end

  def self.scan(body, image_path_prefix: '/images/')
    body.gsub /\[block:image\](.+?)\[\/block\]/m do |str|
      puts "Found image block ..."
      ImageBlockReplacer.new(str, image_path_prefix: image_path_prefix).get_markdown
    end
  end
end

