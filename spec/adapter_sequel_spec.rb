# Generated by generate.rb
require 'helper'

describe_juno "adapter_sequel" do
  def new_store
    Juno::Adapters::Sequel.new(:db => (defined?(JRUBY_VERSION) ? "jdbc:sqlite:" : "sqlite:") + File.join(make_tempdir, "adapter_sequel"))
  end

  include_context 'setup_store'
  it_should_behave_like 'null_stringkey_stringvalue'
  it_should_behave_like 'store_stringkey_stringvalue'
  it_should_behave_like 'returndifferent_stringkey_stringvalue'
end
