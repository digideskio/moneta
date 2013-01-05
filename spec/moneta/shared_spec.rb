# Generated by generate-specs
require 'helper'

describe_moneta "shared" do
  def new_store
    Moneta.build do
      use(:Shared, :port => 9001) do
        adapter :PStore, :file => File.join(make_tempdir, 'shared')
      end
    end
  end

  def load_value(value)
    Marshal.load(value)
  end

  include_context 'setup_store'
  it_should_behave_like 'increment'
  it_should_behave_like 'not_persist'
  it_should_behave_like 'null_stringkey_stringvalue'
  it_should_behave_like 'returndifferent_stringkey_stringvalue'
  it_should_behave_like 'store_stringkey_stringvalue'
  it 'shares values' do
    store['shared_key'] = 'shared_value'
    second = new_store
    second.key?('shared_key').should be_true
    second['shared_key'].should == 'shared_value'
    second.close
  end

end
