$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
name = "hypertextmarkdown"
require "#{name}/version"

Gem::Specification.new name, HyperTextMarkDown::VERSION do |s|
  s.summary = "HTML to markdown converter"
  s.authors = ["Jonathan Cheatham"]
  s.email = "coaxis@gmail.com"
  s.homepage = "http://github.com/jcheatham/#{name}"
  s.files = `git ls-files`.split("\n")
  s.license = "MIT"
end
