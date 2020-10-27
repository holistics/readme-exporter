# Export Readme.com to Markdown

This little script exports data from a readme.com (readme.io) documentation site into markdown files. It also downloads images
from Readme.com into your computer.

![](readme-exporter-f15.gif)


## Why this script

* We were using readme.com (previously readme.io) as a documentation site for a while, but outgrew it so we needed to migrate it to another tool.
* We needed a way to quickly export data from Readme.com. Readme.com exposes an API for us to extract the data. However their exported
Markdown has a lot of custom blocks (e.g `[block:image]`). This script reads the API and convert readme.com custom blocks into
native markdown tags, and download the images along the way.       


## Setting up

The script is written using Ruby. Make sure you have Ruby and bundler set up first. Then run bundle to install the gems:

```bash
bundle
```

Make a copy of `config.json` from `config.json.sample`

```bash
cp config.json.sample config.json
```

Edit config.json to include your readme.com API KEY and the images prefix.

## Run the export

First you need to extract list of slugs from the readme.com, and put them into runner.rb 

```ruby
SLUGS = %w(
  faqs
  amazon-rds-setup
  cohort-retention
  amazon-aws-athena-setup
  tunnel-setup
  friendly-loading-messages
  geo-heatmap
  pie-chart-donut-chart
  bubble-chart
  connect-database
  query-syntax
  visualizations
  introduction
  embedded-analytics
)
```

Then simply run:

```bash
./runner.rb
```

The files will be generated:
* `gen_docs_raw`: Raw readme.com markdown files 
* `gen_docs_final`: Parsed markdown files 
* `gen_images`: Images downloaded from readme.com 


## FAQs

### Does this work for any markdown-based documentations?

We wrote this to work with [Docusaurus](https://v2.docusaurus.io/). But it should work with any markdown-based sites you
choose (Jekyll, Middleman, etc) since it's just markdown.

### How do I get a list of slugs?

You have to collect it manually for now. A future work 


### What is the image_path_prefix for?

What is the image prefix for? It's used to replace this block of code into this:

It's used to replace this markdown block of readme.com

```
[block:image]
{
  "images": [
    {
      "image": [
        "https://files.readme.io/ea963a2-add_user.png",
        "add_user.png",
        1465,
        620,
        "#fbfbfc"
      ]
    }
  ]
}
[/block]
```

to

```
![](https://mycdn.com/images/ea963a2-add_user.png)
```

Here, `https://mycdn.com/images/` is the prefix.

## TODO

- [x] Export pages into markdown
- [x] Download images from readme.com
- [ ] Command to automatically get list of pages + navigation structure

