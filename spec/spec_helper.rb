require "rubygems"

require "jekyll"
require "liquid"

include Jekyll

require File.expand_path("lib/jekyll-time-to-read.rb")

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:all) do
    Jekyll.logger.log_level = Jekyll::Stevenson::ERROR

    original_stderr = $stderr
    original_stdout = $stdout

    @fixtures_path = Pathname.new(__FILE__).parent.join("fixtures")
    @dest = @fixtures_path.join("_site")
    @posts_src = File.join(@fixtures_path, "_posts")
    @layouts_src = File.join(@fixtures_path, "_layouts")
    @plugins_src = File.join(@fixtures_path, "_plugins")

    # $stderr = File.new(File.join(File.dirname(__FILE__), 'dev', 'null.txt'), 'w')
    # $stdout = File.new(File.join(File.dirname(__FILE__), 'dev', 'null.txt'), 'w')

    @site = Jekyll::Site.new(Jekyll.configuration({
      "source"      => @fixtures_path.to_s,
      "destination" => @dest.to_s,
      "plugins"     => @plugins_src
    }))

    @dest.rmtree if @dest.exist?
    @site.process
  end

  config.after(:all) do
    @dest.rmtree if @dest.exist?
  end

  def post_path(file)
    File.join(@posts_src, file)
  end

  def setup_post(file)
    Post.new(@site, @fixtures_path, '', file)
  end

  def do_render(post, layout)
    layouts = { layout.sub(/\.html/, '') => Layout.new(@site, @layouts_src, layout)}
    post.render(layouts, {"site" => {"posts" => []}})
  end
end
