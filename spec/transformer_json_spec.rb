# Generated by generate.rb
require 'helper'

describe_juno "transformer_json" do
  def new_store
    Juno.build do
      use :Transformer, :key => :json, :value => :json
      adapter :Memory
    end
  end

  include_context 'setup_store'
  it_should_behave_like 'null_hashkey_hashvalue'
  it_should_behave_like 'null_hashkey_stringvalue'
  it_should_behave_like 'null_stringkey_hashvalue'
  it_should_behave_like 'null_stringkey_stringvalue'
  it_should_behave_like 'store_hashkey_hashvalue'
  it_should_behave_like 'store_hashkey_stringvalue'
  it_should_behave_like 'store_stringkey_hashvalue'
  it_should_behave_like 'store_stringkey_stringvalue'
  it_should_behave_like 'returndifferent_hashkey_hashvalue'
  it_should_behave_like 'returndifferent_hashkey_stringvalue'
  it_should_behave_like 'returndifferent_stringkey_hashvalue'
  it_should_behave_like 'returndifferent_stringkey_stringvalue'
end
