require 'rspec'
require 'readme_converter'

describe ReadmeConverter do
  let(:api_key) {'somekey'}
  subject {ReadmeConverter.new(api_key)}

  describe 'internal href' do
    pairs =
      [
        ["This is [some](doc:some-link) link to another [page](doc:page-2)",
         "This is [some](some-link.md) link to another [page](page-2.md)"],
         ["[some](doc:some-link#anchor)",
          "[some](some-link.md#anchor)"],
      ]

    pairs.each_with_index do |pair, i|
      it "works on pair #{i}" do
        expect(InternalHrefReplacer.scan(pair.first)).to eq pair[1]
      end
    end
  end

  describe 'image block' do
    let (:block) {
      <<~STRING
        [block:image]
        { "images": [ {
          "image": [
            "https://files.readme.io/44ac68b-Untitled.png",
            "Untitled.png",
            1092,
            87,
            "#f4f5cb"
          ] } ] }
        [/block]
      STRING
    }

    before do
      allow_any_instance_of(ImageBlockReplacer).to receive(:download_image).and_return '44ac68b-Untitled.png'
    end


    describe '#scan' do
      let (:doc_body) {
        <<~STRING
        String 1
        #{block}
        String 2
        #{block}
        STRING
      }
      let (:expected) {
        <<~STRING
        String 1

        ![](https://cdn.holistics.io/docs/readme/44ac68b-Untitled.png)


        String 2

        ![](https://cdn.holistics.io/docs/readme/44ac68b-Untitled.png)

        STRING
      }

      it 'works' do
        ans = ImageBlockReplacer.scan(doc_body, image_path_prefix: 'https://cdn.holistics.io/docs/readme/')
        expect(ans.strip).to eq expected.strip
      end
    end

    describe '.get_markdown' do
      let(:expected) {
        "\n![](https://cdn.holistics.io/docs/readme/44ac68b-Untitled.png)\n"
      }

      let (:subject) {
        ImageBlockReplacer.new(block, image_path_prefix: 'https://cdn.holistics.io/docs/readme/').get_markdown
      }

      it 'replaces with the correct markdown' do
        expect(subject).to eq expected
      end
    end
  end

  describe 'code block' do
    let (:block) {
      <<~STRING
        [block:code]
        {
          "codes": [
            {
              "code": "SELECT DISTINCT(field_name)\\nFROM dataset.datamodel.table_name\\nWHERE <permission_rules>",
              "language": "sql"
            }
          ]
        }
        [/block]
      STRING
    }

    let(:block_md) {
      <<~STRING
        ```sql
        SELECT DISTINCT(field_name)
        FROM dataset.datamodel.table_name
        WHERE <permission_rules>
        ```
      STRING
    }

    describe '.get_markdown' do

      let (:subject) {
        CodeBlockReplacer.new(block).get_markdown
      }

      it 'replaces with the correct markdown' do
        expect(subject).to eq block_md
      end
    end
  end

  describe 'html block' do
    let (:block) {
      <<~STRING
        [block:html]
        {
          "html": "<p>some html</p>"
        }
        [/block]
      STRING
    }

    let(:block_md) {
      '<p>some html</p>'
    }

    describe '.get_markdown' do

      let (:subject) {
        HtmlBlockReplacer.new(block).get_markdown
      }

      it 'replaces with the correct markdown' do
        expect(subject).to eq block_md
      end
    end
  end

  describe 'parameters block' do
    let (:block) {
      <<~STRING
        [block:parameters]
        {
          "rows": 2,
          "cols": 2,
          "data": {
            "h-0": "Country",
            "h-1": "Views",
            "0-0": "Singapore",
            "0-1": "100",
            "1-0": "Vietnam",
            "1-1": "200"
          }
        }
        [/block]
      STRING
    }

    let(:block_md) {
      <<~HTML
<table>
  <thead>
    <th>Country</th>
<th>Views</th>
  </thead>
  <tbody>
    <tr><td><p>Singapore</p>
</td>
<td><p>100</p>
</td></tr>
<tr><td><p>Vietnam</p>
</td>
<td><p>200</p>
</td></tr>
  </tbody>
</table>
      HTML
    }

    describe '.get_markdown' do

      let (:subject) {
        ParametersBlockReplacer.new(block).get_markdown
      }

      it 'replaces with the correct markdown' do
        expect(subject).to eq block_md
      end
    end
  end

  describe 'embed block' do
    let (:block) {
      <<~STRING
        [block:embed]
        {
          "html": false,
          "url": "https://docs.google.com/spreadsheets/d/1zmKwwVmqrb1_RigXgyxD_R-RrNrsAzzrF934UOZDkTg/gviz/tq?tqx=out:html&tq&gid=0",
          "title": "Sheet1",
          "favicon": "https://docs.google.com/favicon.ico",
          "iframe": true,
          "height": "300"
        }
        [/block]
      STRING
    }

    let(:block_md) {
      <<~HTML
        <iframe src="https://docs.google.com/spreadsheets/d/1zmKwwVmqrb1_RigXgyxD_R-RrNrsAzzrF934UOZDkTg/gviz/tq?tqx=out:html&tq&gid=0"></iframe>
      HTML
    }

    describe '.get_markdown' do

      let (:subject) {
        EmbedBlockReplacer.new(block).get_markdown
      }

      it 'replaces with the correct markdown' do
        expect(subject).to eq block_md
      end
    end
  end

  describe 'callout block' do
    let (:block) {
      <<~STRING
        [block:callout]
        {
          "type": "info",
          "title": "Note",
          "body": "Email Schedule always uses updated data from the user's database (does not fetch data from our cache)."
        }
        [/block]
      STRING
    }

    let(:block_md) {
      <<~STRING
        :::info Note
        Email Schedule always uses updated data from the user's database (does not fetch data from our cache).
        :::
      STRING
    }

    describe '.get_markdown' do

      let (:subject) {
        CalloutBlockReplacer.new(block).get_markdown
      }

      it 'replaces with the correct markdown' do
        expect(subject).to eq block_md
      end
    end
  end

  describe 'api header block' do
    let (:block) {
      <<~STRING
        [block:api-header]
        {
          "title": "Some heading"
        }
        [/block]
      STRING
    }

    let(:block_md) {
      '# Some heading'

    }

    describe '.get_markdown' do

      let (:subject) {
        ApiHeaderBlockReplacer.new(block).get_markdown
      }

      it 'replaces with the correct markdown' do
        expect(subject).to eq block_md
      end
    end
  end

end