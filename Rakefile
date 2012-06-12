require 'rake'
require 'reek/rake/task'
require_relative 'reek_viewer'

src_dir = "/Users/praveeg/projects/reek_viewer"
Reek::Rake::Task.new do |t|
    t.fail_on_error = false
      t.source_files = "#{src_dir}/*.rb"
        t.reek_opts = '-y'
end

namespace :reek do
  desc "Create test user [username => bluelabel, password => password] for testing"
  task :instrument do
	`rake reek > out.yml`
	ReekViewer.new('out.yml').generate_html
  end
end