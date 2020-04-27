# frozen_string_literal: true

Before do
  FileUtils.rm_rf(Paths.test_dir) if Paths.test_dir.exist?
  FileUtils.mkdir_p(Paths.test_dir) unless Paths.test_dir.directory?
  Dir.chdir(Paths.test_dir)
end

#

After do
  Dir.chdir(Paths.test_dir.parent)
end

#

Given("I have a {string} page that contains {string}") do |file, text|
  make_page(file, text)
end

Given("I have a {string} page with content:") do |file, text|
  make_page(file, text)
end

Given("I have an include {string} with content:") do |file, text|
  make_directory "_includes"
  File.write("_includes/#{file}", text)
end

Given(%r!^I have an? "(.*)" directory!) do |dir|
  FileUtils.mkdir_p(dir) unless File.directory?(dir)
end

Given(%r!I have the following (posts|documents):!) do |type, table|
  table.hashes.each do |input_hash|
    basename = +""
    if type == "posts"
      parsed_date = Time.xmlschema(input_hash["date"]) rescue Time.parse(input_hash["date"])
      input_hash["date"] = parsed_date
      basename << "#{parsed_date.strftime("%Y-%m-%d")}-"
      input_hash["collection"] = "posts"
    end
    title = slug(input_hash["title"])
    basename << "#{title}.md"
    dir = "_#{input_hash["collection"]}"
    make_directory dir
    File.write("#{dir}/#{basename}", file_content_from_hash(input_hash))
  end
end

Given("I have a configuration file") do
  File.write("_config.yml", YAML.dump("plugins" => %w(jekyll-tagories)))
end

Given("I have a configuration file with:") do |table|
  config = Hash[table.transpose.hashes[0].map { |k, v| [k, YAML.load(v)] }]
  config["plugins"] = (config["plugins"] || []).push("jekyll-tagories")
  File.write("_config.yml", YAML.dump(config))
end

#

When(%r!^I run jekyll (.*)!) do |args|
  run_jekyll_with args
end

#

Then("I should get a {string} directory") do |dir|
  expect(Pathname.new(dir)).to exist
end

Then("I should get {string} in the generated {string}") do |text, file|
  expect(File.read("_site/#{file}")).to match(text)
end

Then("I should not get {string} in the generated {string}") do |text, file|
  expect(File.read("_site/#{file}")).not_to match(text)
end

Then("I should get the expected contents in the generated {string}:") do |file, table|
  text = File.read("_site/#{file}")
  data = table.columns.map { |column| column.map(&:value) }
  data = data.each_with_object({}) do |item, hsh|
    hsh[item.shift] = item.reject { |i| i.nil? || i == "" }
  end
  data["should contain"].each { |i| expect(text).to include(i) }
  data["should not contain"].each { |i| expect(text).not_to include(i) }
end
