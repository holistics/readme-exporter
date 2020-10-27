require 'faraday'
require 'json'
require 'pry'
require_relative 'image_block_replacer'
require_relative 'code_block_replacer'
require_relative 'api_header_block_replacer'
require_relative 'html_block_replacer'
require_relative 'callout_block_replacer'
require_relative 'embed_block_replacer'
require_relative 'parameters_block_replacer'
require_relative 'internal_href_replacer'

class Doc
  attr_accessor :body, :title, :slug, :excerpt

  def initialize(json)
    self.body = json['body']
    self.title = json['title']
    self.slug = json['slug']
    self.excerpt = json['excerpt']
  end
end

class ReadmeConverter
  attr_accessor :readme_apikey

  def initialize(readme_apikey)
    self.readme_apikey = readme_apikey
  end


  def fetch(slug)
    url = "https://dash.readme.io/api/v1/docs/#{slug}"
    response = Faraday.get(
      url,
      {},
      {Authorization: "Basic #{README_API}"}
    )
  end

  def write_to_markdown_file(doc, filepath)
    string = <<~MD
---
title: "#{doc.title}"
id: #{doc.slug}
---
#{doc.body}
    MD

    File.write(filepath, string)
  end

  def run(slugs)
    slugs.each do |slug|
      puts "Fetching data for slug #{slug}..."
      response = fetch(slug)
      if response.status != 200
        puts "Error: #{response.status} - #{JSON.parse(response.body)['message']}"
        break
      end

      doc = Doc.new(JSON.parse(response.body))

      # write to original file
      filepath = "gen_docs_raw/#{slug}.md"
      puts "Writing raw markdown to file #{filepath}..."
      write_to_markdown_file(doc, filepath)


      doc.body = InternalHrefReplacer.scan(doc.body)
      doc.body = ImageBlockReplacer.scan(doc.body)
      doc.body = CodeBlockReplacer.scan(doc.body)
      doc.body = ApiHeaderBlockReplacer.scan(doc.body)
      doc.body = HtmlBlockReplacer.scan(doc.body)
      doc.body = CalloutBlockReplacer.scan(doc.body)
      doc.body = EmbedBlockReplacer.scan(doc.body)
      doc.body = ParametersBlockReplacer.scan(doc.body)

      filepath = "gen_docs_final/#{slug}.md"
      puts "Writing to parsed file #{filepath}..."
      write_to_markdown_file(doc, filepath)
    end
    puts "Done."
  end

end
