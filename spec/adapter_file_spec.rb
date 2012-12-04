# Generated by generate.rb
require 'helper'

describe_juno "adapter_file" do
  def new_store
    Juno::Adapters::File.new(:dir => File.join(make_tempdir, "adapter_file"))
  end

  include_context 'setup_store'
  it_should_behave_like 'null_stringkey_stringvalue'
  it_should_behave_like 'store_stringkey_stringvalue'
  it_should_behave_like 'returndifferent_stringkey_stringvalue'
end
