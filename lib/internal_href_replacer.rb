
class InternalHrefReplacer

  def self.scan(body)
    body.gsub /\(doc:([^)]+)\)/ do
      v = Regexp.last_match[1]
      parts = v.split('#')
      anchor = (parts[1].nil? ? '' : "##{parts[1]}")
      "(" + parts[0] + ".md" + anchor + ")"
    end
  end
end

