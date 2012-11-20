# Generated file
require 'helper'

begin

Juno.build do
  use(:Stack) do
    add(Juno.new(:Null))
    add(Juno::Adapters::Null.new)
    add { adapter :File, :dir => File.join(make_tempdir, "stack-file1") }
    add { adapter :Memory }
  end
end.close

  describe "stack_file_memory" do
    before do
      @store = 
Juno.build do
  use(:Stack) do
    add(Juno.new(:Null))
    add(Juno::Adapters::Null.new)
    add { adapter :File, :dir => File.join(make_tempdir, "stack-file1") }
    add { adapter :Memory }
  end
end
      @store.clear
    end

    after do
      @store.close.should == nil if @store
    end

    it_should_behave_like 'null_stringkey_stringvalue'
    it_should_behave_like 'store_stringkey_stringvalue'
    it_should_behave_like 'returndifferent_stringkey_stringvalue'

  end
rescue LoadError => ex
  puts "Test stack_file_memory not executed: #{ex.message}"
rescue Exception => ex
  puts "Test stack_file_memory not executed: #{ex.message}"
  #puts "#{ex.backtrace.join("\n")}"
end
