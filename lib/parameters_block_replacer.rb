require 'kramdown'

class ParametersBlockReplacer
  attr_accessor :block_string

  def initialize(block_string)
    self.block_string = block_string
  end

  def get_markdown()
    json_string = block_string.strip[18..-9]
    h = JSON.parse(json_string)
    cols = h['cols'].to_i
    rows = h['rows'].to_i
    data = h['data']

    headers = (0..cols-1).to_a.map do |i|
      data["h-#{i}"]
    end
    records = (0 .. rows-1).to_a.map do |i|
      (0..cols-1).to_a.map do |j|
        data["#{i}-#{j}"]
      end
    end

    headers_html = headers.map do |item|
      "<th>#{item}</th>"
    end.join("\n")

    records_html = records.map do |row|
      "<tr>" +
        row.map do |cell|
          html = Kramdown::Document.new(cell.to_s).to_html
          "<td>#{html}</td>"
        end.join("\n") +
      "</tr>"
    end.join("\n")

    <<~HTML
      <table>
        <thead>
          #{headers_html}
        </thead>
        <tbody>
          #{records_html}
        </tbody>
      </table>
    HTML
  end

  def self.scan(body)
    body.gsub /\[block:parameters\](.+?)\[\/block\]/m do |str|
      puts "Found parameters block ..."
      ParametersBlockReplacer.new(str).get_markdown
    end
  end
end

