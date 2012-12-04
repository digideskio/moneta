# Generated by generate.rb
require 'helper'

describe_juno "proxy_redis" do
  def new_store
    Juno.build do
      use :Proxy
      use :Proxy
      adapter :Redis
    end
  end

  include_context 'setup_store'
  it_should_behave_like 'null_stringkey_stringvalue'
  it_should_behave_like 'store_stringkey_stringvalue'
  it_should_behave_like 'returndifferent_stringkey_stringvalue'
  it_should_behave_like 'expires_stringkey_stringvalue'
end
