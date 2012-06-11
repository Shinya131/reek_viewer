require 'rake'
require 'reek/rake/task'

src_dir = "/Users/praveeg/projects/reek_viewer/"
Reek::Rake::Task.new do |t|
    t.fail_on_error = false
      t.source_files = "#{src_dir}/*.rb"
        t.reek_opts = '-y'
end
