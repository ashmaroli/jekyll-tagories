# frozen_string_literal: true

require "jekyll"

class Paths
  def self.test_dir
    Pathname.new(File.expand_path("../..", __dir__)).join("tmp", "jekyll")
  end
end

def make_directory(path)
  FileUtils.mkdir_p(path) unless File.directory?(path)
end

def make_page(path, content)
  File.write(path, <<~TEXT)
    ---
    ---

    #{content}
  TEXT
end

def run_jekyll_with(args)
  Jekyll::Utils::Exec.run("jekyll", *args, "trace")
end

#

def slug(title = nil)
  return Jekyll::Utils.slugify(title) if title

  Time.now.strftime("%s%9N") # nanoseconds since the Epoch
end

#

def file_content_from_hash(input_hash)
  matter_hash = input_hash.reject { |k, v| k == "content" || v.nil? || v == "" }
  matter = YAML.dump(matter_hash).chomp
  content = if input_hash["input"] && input_hash["filter"]
              "{{ #{input_hash["input"]} | #{input_hash["filter"]} }}"
            else
              input_hash["content"]
            end

  <<~EOF
    #{matter}
    ---

    #{content}
  EOF
end
