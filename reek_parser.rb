require 'yaml'
  
class ReekYamlFile
  def initialize(path)
    @path = path
    unless File.exist?(@path) : raise "no such file or directory" end
    file_load
    unless file_yaml? : raise "input file is not YAML format" end
    unless file_reek_output? : raise "input file is not reek output" end
  end

  def to_reeks; @content; end
  
private
  def file_load; File::open(@path) {|f| @content = YAML.load(f) }; end

  def file_yaml?; @content != false; end
  
  def file_reek_output?; @content.first.class == Reek::SmellWarning; end
end

class ReeksList
  attr_reader :divide_reeks
  def initialize(input_file_path)
    @raw_reeks = ReekYamlFile.new(input_file_path).to_reeks
    @divide_reeks = []
    divide_by_context_class
    sort_by_warning_num
  end
  def each
    @divide_reeks.each {| reeks | yield(reeks)}
  end
  def each_with_index
    @divide_reeks.each_with_index {| reeks, i | yield(reeks, i)}
  end
private
  def divide_by_context_class
    context_class_list = @raw_reeks.map{|reek| reek.context_class }.uniq
    context_class_list.each do |context_class|
      @divide_reeks << @raw_reeks.select{|reek| reek.context_class == context_class }
    end
  end
  def sort_by_warning_num
    @divide_reeks.sort!{|a, b| b.size <=> a.size}
  end
end

module Reek
  class SmellWarning
    attr_accessor :smell, :location
    def context_class; location["context"].split("#").first; end
  end
end