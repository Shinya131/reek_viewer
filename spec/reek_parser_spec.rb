require '/Users/praveeg/projects/reek_viewer/reek_parser'
require 'yaml'

describe 'Parser' do
  NOT_YAML_FILE_PATH = "sample_data/not_yaml_file.text"
  NOT_REEK_YAML_FILE_PATH = "sample_data/not_reek_yaml_file.yaml"
  REEK_FILE_PATH = "sample_data/reek_file.yaml"

  describe "ReekYamlFile" do
    describe "newした時" do
      it "reekが出力したファイルのパスがYAMLで渡された場合、インスタンスを返却する" do
        @reek_yaml_file =  ReekYamlFile.new(REEK_FILE_PATH)
        @reek_yaml_file.class.should == ReekYamlFile
      end

      it "引数がnilなら、例外発生" do

      end

      it "引数の文字列がファイルパスとして無効な場合、例外発生" do
        proc {
          @reek_yaml_file =  ReekYamlFile.new("not_file_path_str")
        }.should raise_error(RuntimeError, "no such file or directory")
      end

      it "引数のファイルパスがYAML形で無い場合、例外発生" do
        proc {
          @reek_yaml_file =  ReekYamlFile.new(NOT_YAML_FILE_PATH)
        }.should raise_error(RuntimeError, "input file is not YAML format")
      end

      it "引数のファイルパスがYAML形式だが、reekが出力したファイルで無い場合、例外発生" do
        proc {
          @reek_yaml_file =  ReekYamlFile.new(NOT_REEK_YAML_FILE_PATH)
        }.should raise_error(RuntimeError, "input file is not reek output")
      end

    end
  end

  describe "ReeksList" do
    before do
      @reeks_list = ReeksList.new(REEK_FILE_PATH)
    end

    describe "newした時" do
      it "ReekList型のインスタンスが得られる" do
        @reeks_list.class.should == ReeksList
      end
    end

    describe "eachした時" do
      it "ブロックが実行される" do
        run = false
        @reeks_list.each {|reeks| run = true }
        run.should be_true
      end

      it "Reek::SmellWarningの配列がブロックに渡される" do
        @reeks_list.each do |reeks|
          reeks.class.should == Array
          reeks.first.class.should == Reek::SmellWarning
        end
      end

      it "同じcontext_classのSmellWarningは同じ配列に入っている" do
        @reeks_list.each do |reeks|
          reeks.each{|reek| reek.context_class.should == reeks.first.context_class }
        end
      end

      it "SmellWarningの配列は、Warning数が大きい物からブロックに渡される" do
        @reeks_list.each_with_index do |reeks, i|
          if @reeks_list.divide_reeks.size == i+1 : break end
          now_reeks_size = reeks.size.should
          next_reeks_size = @reeks_list.divide_reeks[i+1].size
          now_reeks_size.should >= next_reeks_size
        end
      end
    end
  end
end