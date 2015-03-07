# Script for importing from Blogger
# 	ruby -rubygems -- bxm-dev-import.rb
require "jekyll-import";
JekyllImport::Importers::Blogger.run({
	"source"                => "bxm-dev-export-03-07-2015.xml",
	"no-blogger-info"       => false, # not to leave blogger-URL info (id and old URL) in the front matter
	"replace-internal-link" => true, # replace internal links using the post_url liquid tag.
})
