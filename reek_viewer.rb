require 'test/unit'
require 'yaml'

require 'rubygems'
require 'sinatra'

get '/' do
  reeks = Parser.new(params[:file_path])
  @input_file_path = params[:file_path]
  @reeks = reeks.get_reeks
  @keys = reeks.get_keys
  @sum_of_waning_num = reeks.get_sum_of_waning_num
  
  Util.out_put_to_file(reeks, params[:file_path])
  
  erb :index
end

class Util
  def self.out_put_to_file(reeks, input_file_path)
    @input_file_path = input_file_path
    @reeks = reeks.get_reeks
    @keys = reeks.get_keys
    @sum_of_waning_num = reeks.get_sum_of_waning_num    
    
    erb = open("./views/index.erb")
    erb_str = erb.read
    
    erb = ERB.new(erb_str)
    html = erb.result(binding)
    
    open("./" + @input_file_path.split(".").first + ".html", "w"){|f| f.write html }
  end
end

class Parser
  attr_accessor :input_file_path, :reeks
  def initialize(input_file_path)
    check_file_path(input_file_path)
    @input_file_path = input_file_path
    reek_obj_arry = file_to_reek_obj
    @reeks = reek_add_header(reek_obj_arry)
  end
  
  def get_reeks; @reeks; end
  
  def get_keys
     keys = sort_keys_by_waning_num(@reeks.keys)
  end
  
  def sort_keys_by_waning_num(keys)
    keys.sort!
    keys = keys.map{|key| [@reeks[key].size, key] }
    keys = keys.sort{|a, b| b.first <=> a.first}
    keys = keys.map{|keys| keys[1] }
  end
  
  def get_sum_of_waning_num
    sum = 0
    @reeks.keys.each { | key | sum += @reeks[key].size }
    sum
  end
  
  def reek_add_header(reek_obj_arry)
    reeks = {}
    reek_obj_arry.each do |reek|
      if reeks.key?(reek.context_class)
        reeks[reek.context_class] << reek
      else
        reeks[reek.context_class] = [reek]
      end
    end
    reeks
  end
  
  def file_to_reek_obj
    File::open(@input_file_path) {|f| return YAML.load(f) }
  end
  
  def check_file_path(input_file_path)
    unless File.exist?(input_file_path)
      raise "no such file or directory "+ '"' + input_file_path + '"'
    end
  end
end

module Reek
  class SmellWarning
    attr_accessor :smell, :location
    def context_class; location["context"].split("#").first; end
  end
end