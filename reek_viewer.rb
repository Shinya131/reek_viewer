require 'rubygems'
require 'erb'
require_relative 'reek_parser'

class ReekViewer
  def initialize(yaml_file)
	@yaml_file = yaml_file

  end

  def generate_html
	reeks = ReeksList.new(@yaml_file)
	@reeks_list = reeks.divide_reeks
	@keys = reeks.context_class_list
	@sum_of_waning_num = reeks.total_warning_num

	erb_str = open(Dir::pwd + "/view_template.erb").read
	html = ERB.new(erb_str).result(binding)

	open("./" + @yaml_file + ".html", "w"){|f| f.write html }
  end
end