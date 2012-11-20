#################### null_stringkey_stringvalue ####################

shared_examples_for 'null_stringkey_stringvalue' do
  it "reads from keys that are Strings like a Hash" do
    @store["strkey1"].should == nil
    @store.load("strkey1").should == nil
  end

  it "guarantees that the same String value is returned when setting a String key" do
    value = "strval1"
    (@store["strkey1"] = value).should equal(value)
  end

  it "returns false from key? if a String key is not available" do
    @store.key?("strkey1").should == false
  end

  it "returns nil from delete if an element for a String key does not exist" do
    @store.delete("strkey1").should == nil
  end

  it "removes all String keys from the store with clear" do
    @store["strkey1"] = "strval1"
    @store["strkey2"] = "strval2"
    @store.clear.should equal(@store)
    @store.key?("strkey1").should_not ==  true
    @store.key?("strkey2").should_not == true
  end

  it "fetches a String key with a default value with fetch, if the key is not available" do
    @store.fetch("strkey1", "strval1").should == "strval1"
  end

  it "fetches a String key with a block with fetch, if the key is not available" do
    key = "strkey1"
    value = "strval1"
    @store.fetch(key) do |k|
      k.should equal(key)
      value
    end.should equal(value)
  end

  it 'should accept options' do
    @store.key?("strkey1", :option1 => 1).should == false
    @store.load("strkey1", :option2 => 2).should == nil
    @store.fetch("strkey1", nil, :option3 => 3).should == nil
    @store.delete("strkey1", :option4 => 4).should == nil
    @store.clear(:option5 => 5).should equal(@store)
    @store.store("strkey1", "strval1", :option6 => 6).should == "strval1"
  end
end

#################### store_stringkey_stringvalue ####################

shared_examples_for 'store_stringkey_stringvalue' do
  it "writes String values to keys that are Strings like a Hash" do
    @store["strkey1"] = "strval1"
    @store["strkey1"].should == "strval1"
    @store.load("strkey1").should == "strval1"
  end

  it "returns true from key? if a String key is available" do
    @store["strkey1"] = "strval1"
    @store.key?("strkey1").should == true
  end

  it "stores String values with String keys with #store" do
    value = "strval1"
    @store.store("strkey1", value).should equal(value)
    @store["strkey1"].should == "strval1"
    @store.load("strkey1").should == "strval1"
  end

  it "removes and returns a String element with a String key from the backing store via delete if it exists" do
    @store["strkey1"] = "strval1"
    @store.delete("strkey1").should == "strval1"
    @store.key?("strkey1").should == false
  end

  it "does not run the block if the String key is available" do
    @store["strkey1"] = "strval1"
    unaltered = "unaltered"
    @store.fetch("strkey1") { unaltered = "altered" }
    unaltered.should == "unaltered"
  end

  it "fetches a String key with a default value with fetch, if the key is available" do
    @store["strkey1"] = "strval1"
    @store.fetch("strkey1", "strval2").should == "strval1"
  end
end

#################### returndifferent_stringkey_stringvalue ####################

shared_examples_for 'returndifferent_stringkey_stringvalue' do
  it "guarantees that a different String value is retrieved from the String key" do
    value = "strval1"
    @store["strkey1"] = "strval1"
    @store["strkey1"].should_not be_equal("strval1")
  end
end

#################### expires_stringkey_stringvalue ####################

shared_examples_for 'expires_stringkey_stringvalue' do
  it 'should support expires on store and #[]' do
    @store.store("strkey1", "strval1", :expires => 2)
    @store["strkey1"].should == "strval1"
    sleep 1
    @store["strkey1"].should == "strval1"
    sleep 2
    @store["strkey1"].should == nil
  end

  it 'should support expires on store and load' do
    @store.store("strkey1", "strval1", :expires => 2)
    @store.load("strkey1").should == "strval1"
    sleep 1
    @store.load("strkey1").should == "strval1"
    sleep 2
    @store.load("strkey1").should == nil
  end

  it 'should support expires on store and key?' do
    @store.store("strkey1", "strval1", :expires => 2)
    @store.key?("strkey1").should == true
    sleep 1
    @store.key?("strkey1").should == true
    sleep 2
    @store.key?("strkey1").should == false
  end

  it 'should support updating the expiration time in load' do
    @store.store("strkey2", "strval2", :expires => 2)
    @store["strkey2"].should == "strval2"
    sleep 1
    @store.load("strkey2", :expires => 3).should == "strval2"
    @store["strkey2"].should == "strval2"
    sleep 1
    @store["strkey2"].should == "strval2"
    sleep 3
    @store["strkey2"].should == nil
  end

  it 'should support updating the expiration time in fetch' do
    @store.store("strkey1", "strval1", :expires => 2)
    @store["strkey1"].should == "strval1"
    sleep 1
    @store.fetch("strkey1", nil, :expires => 3).should == "strval1"
    @store["strkey1"].should == "strval1"
    sleep 1
    @store["strkey1"].should == "strval1"
    sleep 3
    @store["strkey1"].should == nil
  end

  it 'should respect expires in delete' do
    @store.store("strkey2", "strval2", :expires => 2)
    @store["strkey2"].should == "strval2"
    sleep 1
    @store["strkey2"].should == "strval2"
    sleep 2
    @store.delete("strkey2").should == nil
  end
end

#################### null_stringkey_objectvalue ####################

shared_examples_for 'null_stringkey_objectvalue' do
  it "reads from keys that are Strings like a Hash" do
    @store["strkey1"].should == nil
    @store.load("strkey1").should == nil
  end

  it "guarantees that the same Object value is returned when setting a String key" do
    value = Value.new(:objval1)
    (@store["strkey1"] = value).should equal(value)
  end

  it "returns false from key? if a String key is not available" do
    @store.key?("strkey1").should == false
  end

  it "returns nil from delete if an element for a String key does not exist" do
    @store.delete("strkey1").should == nil
  end

  it "removes all String keys from the store with clear" do
    @store["strkey1"] = Value.new(:objval1)
    @store["strkey2"] = Value.new(:objval2)
    @store.clear.should equal(@store)
    @store.key?("strkey1").should_not ==  true
    @store.key?("strkey2").should_not == true
  end

  it "fetches a String key with a default value with fetch, if the key is not available" do
    @store.fetch("strkey1", Value.new(:objval1)).should == Value.new(:objval1)
  end

  it "fetches a String key with a block with fetch, if the key is not available" do
    key = "strkey1"
    value = Value.new(:objval1)
    @store.fetch(key) do |k|
      k.should equal(key)
      value
    end.should equal(value)
  end

  it 'should accept options' do
    @store.key?("strkey1", :option1 => 1).should == false
    @store.load("strkey1", :option2 => 2).should == nil
    @store.fetch("strkey1", nil, :option3 => 3).should == nil
    @store.delete("strkey1", :option4 => 4).should == nil
    @store.clear(:option5 => 5).should equal(@store)
    @store.store("strkey1", Value.new(:objval1), :option6 => 6).should == Value.new(:objval1)
  end
end

#################### store_stringkey_objectvalue ####################

shared_examples_for 'store_stringkey_objectvalue' do
  it "writes Object values to keys that are Strings like a Hash" do
    @store["strkey1"] = Value.new(:objval1)
    @store["strkey1"].should == Value.new(:objval1)
    @store.load("strkey1").should == Value.new(:objval1)
  end

  it "returns true from key? if a String key is available" do
    @store["strkey1"] = Value.new(:objval1)
    @store.key?("strkey1").should == true
  end

  it "stores Object values with String keys with #store" do
    value = Value.new(:objval1)
    @store.store("strkey1", value).should equal(value)
    @store["strkey1"].should == Value.new(:objval1)
    @store.load("strkey1").should == Value.new(:objval1)
  end

  it "removes and returns a Object element with a String key from the backing store via delete if it exists" do
    @store["strkey1"] = Value.new(:objval1)
    @store.delete("strkey1").should == Value.new(:objval1)
    @store.key?("strkey1").should == false
  end

  it "does not run the block if the String key is available" do
    @store["strkey1"] = Value.new(:objval1)
    unaltered = "unaltered"
    @store.fetch("strkey1") { unaltered = "altered" }
    unaltered.should == "unaltered"
  end

  it "fetches a String key with a default value with fetch, if the key is available" do
    @store["strkey1"] = Value.new(:objval1)
    @store.fetch("strkey1", Value.new(:objval2)).should == Value.new(:objval1)
  end
end

#################### returndifferent_stringkey_objectvalue ####################

shared_examples_for 'returndifferent_stringkey_objectvalue' do
  it "guarantees that a different Object value is retrieved from the String key" do
    value = Value.new(:objval1)
    @store["strkey1"] = Value.new(:objval1)
    @store["strkey1"].should_not be_equal(Value.new(:objval1))
  end
end

#################### expires_stringkey_objectvalue ####################

shared_examples_for 'expires_stringkey_objectvalue' do
  it 'should support expires on store and #[]' do
    @store.store("strkey1", Value.new(:objval1), :expires => 2)
    @store["strkey1"].should == Value.new(:objval1)
    sleep 1
    @store["strkey1"].should == Value.new(:objval1)
    sleep 2
    @store["strkey1"].should == nil
  end

  it 'should support expires on store and load' do
    @store.store("strkey1", Value.new(:objval1), :expires => 2)
    @store.load("strkey1").should == Value.new(:objval1)
    sleep 1
    @store.load("strkey1").should == Value.new(:objval1)
    sleep 2
    @store.load("strkey1").should == nil
  end

  it 'should support expires on store and key?' do
    @store.store("strkey1", Value.new(:objval1), :expires => 2)
    @store.key?("strkey1").should == true
    sleep 1
    @store.key?("strkey1").should == true
    sleep 2
    @store.key?("strkey1").should == false
  end

  it 'should support updating the expiration time in load' do
    @store.store("strkey2", Value.new(:objval2), :expires => 2)
    @store["strkey2"].should == Value.new(:objval2)
    sleep 1
    @store.load("strkey2", :expires => 3).should == Value.new(:objval2)
    @store["strkey2"].should == Value.new(:objval2)
    sleep 1
    @store["strkey2"].should == Value.new(:objval2)
    sleep 3
    @store["strkey2"].should == nil
  end

  it 'should support updating the expiration time in fetch' do
    @store.store("strkey1", Value.new(:objval1), :expires => 2)
    @store["strkey1"].should == Value.new(:objval1)
    sleep 1
    @store.fetch("strkey1", nil, :expires => 3).should == Value.new(:objval1)
    @store["strkey1"].should == Value.new(:objval1)
    sleep 1
    @store["strkey1"].should == Value.new(:objval1)
    sleep 3
    @store["strkey1"].should == nil
  end

  it 'should respect expires in delete' do
    @store.store("strkey2", Value.new(:objval2), :expires => 2)
    @store["strkey2"].should == Value.new(:objval2)
    sleep 1
    @store["strkey2"].should == Value.new(:objval2)
    sleep 2
    @store.delete("strkey2").should == nil
  end
end

#################### null_stringkey_hashvalue ####################

shared_examples_for 'null_stringkey_hashvalue' do
  it "reads from keys that are Strings like a Hash" do
    @store["strkey1"].should == nil
    @store.load("strkey1").should == nil
  end

  it "guarantees that the same Hash value is returned when setting a String key" do
    value = {"hashval1"=>"hashval2"}
    (@store["strkey1"] = value).should equal(value)
  end

  it "returns false from key? if a String key is not available" do
    @store.key?("strkey1").should == false
  end

  it "returns nil from delete if an element for a String key does not exist" do
    @store.delete("strkey1").should == nil
  end

  it "removes all String keys from the store with clear" do
    @store["strkey1"] = {"hashval1"=>"hashval2"}
    @store["strkey2"] = {"hashval3"=>"hashval4"}
    @store.clear.should equal(@store)
    @store.key?("strkey1").should_not ==  true
    @store.key?("strkey2").should_not == true
  end

  it "fetches a String key with a default value with fetch, if the key is not available" do
    @store.fetch("strkey1", {"hashval1"=>"hashval2"}).should == {"hashval1"=>"hashval2"}
  end

  it "fetches a String key with a block with fetch, if the key is not available" do
    key = "strkey1"
    value = {"hashval1"=>"hashval2"}
    @store.fetch(key) do |k|
      k.should equal(key)
      value
    end.should equal(value)
  end

  it 'should accept options' do
    @store.key?("strkey1", :option1 => 1).should == false
    @store.load("strkey1", :option2 => 2).should == nil
    @store.fetch("strkey1", nil, :option3 => 3).should == nil
    @store.delete("strkey1", :option4 => 4).should == nil
    @store.clear(:option5 => 5).should equal(@store)
    @store.store("strkey1", {"hashval1"=>"hashval2"}, :option6 => 6).should == {"hashval1"=>"hashval2"}
  end
end

#################### store_stringkey_hashvalue ####################

shared_examples_for 'store_stringkey_hashvalue' do
  it "writes Hash values to keys that are Strings like a Hash" do
    @store["strkey1"] = {"hashval1"=>"hashval2"}
    @store["strkey1"].should == {"hashval1"=>"hashval2"}
    @store.load("strkey1").should == {"hashval1"=>"hashval2"}
  end

  it "returns true from key? if a String key is available" do
    @store["strkey1"] = {"hashval1"=>"hashval2"}
    @store.key?("strkey1").should == true
  end

  it "stores Hash values with String keys with #store" do
    value = {"hashval1"=>"hashval2"}
    @store.store("strkey1", value).should equal(value)
    @store["strkey1"].should == {"hashval1"=>"hashval2"}
    @store.load("strkey1").should == {"hashval1"=>"hashval2"}
  end

  it "removes and returns a Hash element with a String key from the backing store via delete if it exists" do
    @store["strkey1"] = {"hashval1"=>"hashval2"}
    @store.delete("strkey1").should == {"hashval1"=>"hashval2"}
    @store.key?("strkey1").should == false
  end

  it "does not run the block if the String key is available" do
    @store["strkey1"] = {"hashval1"=>"hashval2"}
    unaltered = "unaltered"
    @store.fetch("strkey1") { unaltered = "altered" }
    unaltered.should == "unaltered"
  end

  it "fetches a String key with a default value with fetch, if the key is available" do
    @store["strkey1"] = {"hashval1"=>"hashval2"}
    @store.fetch("strkey1", {"hashval3"=>"hashval4"}).should == {"hashval1"=>"hashval2"}
  end
end

#################### returndifferent_stringkey_hashvalue ####################

shared_examples_for 'returndifferent_stringkey_hashvalue' do
  it "guarantees that a different Hash value is retrieved from the String key" do
    value = {"hashval1"=>"hashval2"}
    @store["strkey1"] = {"hashval1"=>"hashval2"}
    @store["strkey1"].should_not be_equal({"hashval1"=>"hashval2"})
  end
end

#################### expires_stringkey_hashvalue ####################

shared_examples_for 'expires_stringkey_hashvalue' do
  it 'should support expires on store and #[]' do
    @store.store("strkey1", {"hashval1"=>"hashval2"}, :expires => 2)
    @store["strkey1"].should == {"hashval1"=>"hashval2"}
    sleep 1
    @store["strkey1"].should == {"hashval1"=>"hashval2"}
    sleep 2
    @store["strkey1"].should == nil
  end

  it 'should support expires on store and load' do
    @store.store("strkey1", {"hashval1"=>"hashval2"}, :expires => 2)
    @store.load("strkey1").should == {"hashval1"=>"hashval2"}
    sleep 1
    @store.load("strkey1").should == {"hashval1"=>"hashval2"}
    sleep 2
    @store.load("strkey1").should == nil
  end

  it 'should support expires on store and key?' do
    @store.store("strkey1", {"hashval1"=>"hashval2"}, :expires => 2)
    @store.key?("strkey1").should == true
    sleep 1
    @store.key?("strkey1").should == true
    sleep 2
    @store.key?("strkey1").should == false
  end

  it 'should support updating the expiration time in load' do
    @store.store("strkey2", {"hashval3"=>"hashval4"}, :expires => 2)
    @store["strkey2"].should == {"hashval3"=>"hashval4"}
    sleep 1
    @store.load("strkey2", :expires => 3).should == {"hashval3"=>"hashval4"}
    @store["strkey2"].should == {"hashval3"=>"hashval4"}
    sleep 1
    @store["strkey2"].should == {"hashval3"=>"hashval4"}
    sleep 3
    @store["strkey2"].should == nil
  end

  it 'should support updating the expiration time in fetch' do
    @store.store("strkey1", {"hashval1"=>"hashval2"}, :expires => 2)
    @store["strkey1"].should == {"hashval1"=>"hashval2"}
    sleep 1
    @store.fetch("strkey1", nil, :expires => 3).should == {"hashval1"=>"hashval2"}
    @store["strkey1"].should == {"hashval1"=>"hashval2"}
    sleep 1
    @store["strkey1"].should == {"hashval1"=>"hashval2"}
    sleep 3
    @store["strkey1"].should == nil
  end

  it 'should respect expires in delete' do
    @store.store("strkey2", {"hashval3"=>"hashval4"}, :expires => 2)
    @store["strkey2"].should == {"hashval3"=>"hashval4"}
    sleep 1
    @store["strkey2"].should == {"hashval3"=>"hashval4"}
    sleep 2
    @store.delete("strkey2").should == nil
  end
end

#################### null_objectkey_stringvalue ####################

shared_examples_for 'null_objectkey_stringvalue' do
  it "reads from keys that are Objects like a Hash" do
    @store[Value.new(:objkey1)].should == nil
    @store.load(Value.new(:objkey1)).should == nil
  end

  it "guarantees that the same String value is returned when setting a Object key" do
    value = "strval1"
    (@store[Value.new(:objkey1)] = value).should equal(value)
  end

  it "returns false from key? if a Object key is not available" do
    @store.key?(Value.new(:objkey1)).should == false
  end

  it "returns nil from delete if an element for a Object key does not exist" do
    @store.delete(Value.new(:objkey1)).should == nil
  end

  it "removes all Object keys from the store with clear" do
    @store[Value.new(:objkey1)] = "strval1"
    @store[Value.new(:objkey2)] = "strval2"
    @store.clear.should equal(@store)
    @store.key?(Value.new(:objkey1)).should_not ==  true
    @store.key?(Value.new(:objkey2)).should_not == true
  end

  it "fetches a Object key with a default value with fetch, if the key is not available" do
    @store.fetch(Value.new(:objkey1), "strval1").should == "strval1"
  end

  it "fetches a Object key with a block with fetch, if the key is not available" do
    key = Value.new(:objkey1)
    value = "strval1"
    @store.fetch(key) do |k|
      k.should equal(key)
      value
    end.should equal(value)
  end

  it 'should accept options' do
    @store.key?(Value.new(:objkey1), :option1 => 1).should == false
    @store.load(Value.new(:objkey1), :option2 => 2).should == nil
    @store.fetch(Value.new(:objkey1), nil, :option3 => 3).should == nil
    @store.delete(Value.new(:objkey1), :option4 => 4).should == nil
    @store.clear(:option5 => 5).should equal(@store)
    @store.store(Value.new(:objkey1), "strval1", :option6 => 6).should == "strval1"
  end
end

#################### store_objectkey_stringvalue ####################

shared_examples_for 'store_objectkey_stringvalue' do
  it "writes String values to keys that are Objects like a Hash" do
    @store[Value.new(:objkey1)] = "strval1"
    @store[Value.new(:objkey1)].should == "strval1"
    @store.load(Value.new(:objkey1)).should == "strval1"
  end

  it "returns true from key? if a Object key is available" do
    @store[Value.new(:objkey1)] = "strval1"
    @store.key?(Value.new(:objkey1)).should == true
  end

  it "stores String values with Object keys with #store" do
    value = "strval1"
    @store.store(Value.new(:objkey1), value).should equal(value)
    @store[Value.new(:objkey1)].should == "strval1"
    @store.load(Value.new(:objkey1)).should == "strval1"
  end

  it "removes and returns a String element with a Object key from the backing store via delete if it exists" do
    @store[Value.new(:objkey1)] = "strval1"
    @store.delete(Value.new(:objkey1)).should == "strval1"
    @store.key?(Value.new(:objkey1)).should == false
  end

  it "does not run the block if the Object key is available" do
    @store[Value.new(:objkey1)] = "strval1"
    unaltered = "unaltered"
    @store.fetch(Value.new(:objkey1)) { unaltered = "altered" }
    unaltered.should == "unaltered"
  end

  it "fetches a Object key with a default value with fetch, if the key is available" do
    @store[Value.new(:objkey1)] = "strval1"
    @store.fetch(Value.new(:objkey1), "strval2").should == "strval1"
  end
end

#################### returndifferent_objectkey_stringvalue ####################

shared_examples_for 'returndifferent_objectkey_stringvalue' do
  it "guarantees that a different String value is retrieved from the Object key" do
    value = "strval1"
    @store[Value.new(:objkey1)] = "strval1"
    @store[Value.new(:objkey1)].should_not be_equal("strval1")
  end
end

#################### expires_objectkey_stringvalue ####################

shared_examples_for 'expires_objectkey_stringvalue' do
  it 'should support expires on store and #[]' do
    @store.store(Value.new(:objkey1), "strval1", :expires => 2)
    @store[Value.new(:objkey1)].should == "strval1"
    sleep 1
    @store[Value.new(:objkey1)].should == "strval1"
    sleep 2
    @store[Value.new(:objkey1)].should == nil
  end

  it 'should support expires on store and load' do
    @store.store(Value.new(:objkey1), "strval1", :expires => 2)
    @store.load(Value.new(:objkey1)).should == "strval1"
    sleep 1
    @store.load(Value.new(:objkey1)).should == "strval1"
    sleep 2
    @store.load(Value.new(:objkey1)).should == nil
  end

  it 'should support expires on store and key?' do
    @store.store(Value.new(:objkey1), "strval1", :expires => 2)
    @store.key?(Value.new(:objkey1)).should == true
    sleep 1
    @store.key?(Value.new(:objkey1)).should == true
    sleep 2
    @store.key?(Value.new(:objkey1)).should == false
  end

  it 'should support updating the expiration time in load' do
    @store.store(Value.new(:objkey2), "strval2", :expires => 2)
    @store[Value.new(:objkey2)].should == "strval2"
    sleep 1
    @store.load(Value.new(:objkey2), :expires => 3).should == "strval2"
    @store[Value.new(:objkey2)].should == "strval2"
    sleep 1
    @store[Value.new(:objkey2)].should == "strval2"
    sleep 3
    @store[Value.new(:objkey2)].should == nil
  end

  it 'should support updating the expiration time in fetch' do
    @store.store(Value.new(:objkey1), "strval1", :expires => 2)
    @store[Value.new(:objkey1)].should == "strval1"
    sleep 1
    @store.fetch(Value.new(:objkey1), nil, :expires => 3).should == "strval1"
    @store[Value.new(:objkey1)].should == "strval1"
    sleep 1
    @store[Value.new(:objkey1)].should == "strval1"
    sleep 3
    @store[Value.new(:objkey1)].should == nil
  end

  it 'should respect expires in delete' do
    @store.store(Value.new(:objkey2), "strval2", :expires => 2)
    @store[Value.new(:objkey2)].should == "strval2"
    sleep 1
    @store[Value.new(:objkey2)].should == "strval2"
    sleep 2
    @store.delete(Value.new(:objkey2)).should == nil
  end
end

#################### null_objectkey_objectvalue ####################

shared_examples_for 'null_objectkey_objectvalue' do
  it "reads from keys that are Objects like a Hash" do
    @store[Value.new(:objkey1)].should == nil
    @store.load(Value.new(:objkey1)).should == nil
  end

  it "guarantees that the same Object value is returned when setting a Object key" do
    value = Value.new(:objval1)
    (@store[Value.new(:objkey1)] = value).should equal(value)
  end

  it "returns false from key? if a Object key is not available" do
    @store.key?(Value.new(:objkey1)).should == false
  end

  it "returns nil from delete if an element for a Object key does not exist" do
    @store.delete(Value.new(:objkey1)).should == nil
  end

  it "removes all Object keys from the store with clear" do
    @store[Value.new(:objkey1)] = Value.new(:objval1)
    @store[Value.new(:objkey2)] = Value.new(:objval2)
    @store.clear.should equal(@store)
    @store.key?(Value.new(:objkey1)).should_not ==  true
    @store.key?(Value.new(:objkey2)).should_not == true
  end

  it "fetches a Object key with a default value with fetch, if the key is not available" do
    @store.fetch(Value.new(:objkey1), Value.new(:objval1)).should == Value.new(:objval1)
  end

  it "fetches a Object key with a block with fetch, if the key is not available" do
    key = Value.new(:objkey1)
    value = Value.new(:objval1)
    @store.fetch(key) do |k|
      k.should equal(key)
      value
    end.should equal(value)
  end

  it 'should accept options' do
    @store.key?(Value.new(:objkey1), :option1 => 1).should == false
    @store.load(Value.new(:objkey1), :option2 => 2).should == nil
    @store.fetch(Value.new(:objkey1), nil, :option3 => 3).should == nil
    @store.delete(Value.new(:objkey1), :option4 => 4).should == nil
    @store.clear(:option5 => 5).should equal(@store)
    @store.store(Value.new(:objkey1), Value.new(:objval1), :option6 => 6).should == Value.new(:objval1)
  end
end

#################### store_objectkey_objectvalue ####################

shared_examples_for 'store_objectkey_objectvalue' do
  it "writes Object values to keys that are Objects like a Hash" do
    @store[Value.new(:objkey1)] = Value.new(:objval1)
    @store[Value.new(:objkey1)].should == Value.new(:objval1)
    @store.load(Value.new(:objkey1)).should == Value.new(:objval1)
  end

  it "returns true from key? if a Object key is available" do
    @store[Value.new(:objkey1)] = Value.new(:objval1)
    @store.key?(Value.new(:objkey1)).should == true
  end

  it "stores Object values with Object keys with #store" do
    value = Value.new(:objval1)
    @store.store(Value.new(:objkey1), value).should equal(value)
    @store[Value.new(:objkey1)].should == Value.new(:objval1)
    @store.load(Value.new(:objkey1)).should == Value.new(:objval1)
  end

  it "removes and returns a Object element with a Object key from the backing store via delete if it exists" do
    @store[Value.new(:objkey1)] = Value.new(:objval1)
    @store.delete(Value.new(:objkey1)).should == Value.new(:objval1)
    @store.key?(Value.new(:objkey1)).should == false
  end

  it "does not run the block if the Object key is available" do
    @store[Value.new(:objkey1)] = Value.new(:objval1)
    unaltered = "unaltered"
    @store.fetch(Value.new(:objkey1)) { unaltered = "altered" }
    unaltered.should == "unaltered"
  end

  it "fetches a Object key with a default value with fetch, if the key is available" do
    @store[Value.new(:objkey1)] = Value.new(:objval1)
    @store.fetch(Value.new(:objkey1), Value.new(:objval2)).should == Value.new(:objval1)
  end
end

#################### returndifferent_objectkey_objectvalue ####################

shared_examples_for 'returndifferent_objectkey_objectvalue' do
  it "guarantees that a different Object value is retrieved from the Object key" do
    value = Value.new(:objval1)
    @store[Value.new(:objkey1)] = Value.new(:objval1)
    @store[Value.new(:objkey1)].should_not be_equal(Value.new(:objval1))
  end
end

#################### expires_objectkey_objectvalue ####################

shared_examples_for 'expires_objectkey_objectvalue' do
  it 'should support expires on store and #[]' do
    @store.store(Value.new(:objkey1), Value.new(:objval1), :expires => 2)
    @store[Value.new(:objkey1)].should == Value.new(:objval1)
    sleep 1
    @store[Value.new(:objkey1)].should == Value.new(:objval1)
    sleep 2
    @store[Value.new(:objkey1)].should == nil
  end

  it 'should support expires on store and load' do
    @store.store(Value.new(:objkey1), Value.new(:objval1), :expires => 2)
    @store.load(Value.new(:objkey1)).should == Value.new(:objval1)
    sleep 1
    @store.load(Value.new(:objkey1)).should == Value.new(:objval1)
    sleep 2
    @store.load(Value.new(:objkey1)).should == nil
  end

  it 'should support expires on store and key?' do
    @store.store(Value.new(:objkey1), Value.new(:objval1), :expires => 2)
    @store.key?(Value.new(:objkey1)).should == true
    sleep 1
    @store.key?(Value.new(:objkey1)).should == true
    sleep 2
    @store.key?(Value.new(:objkey1)).should == false
  end

  it 'should support updating the expiration time in load' do
    @store.store(Value.new(:objkey2), Value.new(:objval2), :expires => 2)
    @store[Value.new(:objkey2)].should == Value.new(:objval2)
    sleep 1
    @store.load(Value.new(:objkey2), :expires => 3).should == Value.new(:objval2)
    @store[Value.new(:objkey2)].should == Value.new(:objval2)
    sleep 1
    @store[Value.new(:objkey2)].should == Value.new(:objval2)
    sleep 3
    @store[Value.new(:objkey2)].should == nil
  end

  it 'should support updating the expiration time in fetch' do
    @store.store(Value.new(:objkey1), Value.new(:objval1), :expires => 2)
    @store[Value.new(:objkey1)].should == Value.new(:objval1)
    sleep 1
    @store.fetch(Value.new(:objkey1), nil, :expires => 3).should == Value.new(:objval1)
    @store[Value.new(:objkey1)].should == Value.new(:objval1)
    sleep 1
    @store[Value.new(:objkey1)].should == Value.new(:objval1)
    sleep 3
    @store[Value.new(:objkey1)].should == nil
  end

  it 'should respect expires in delete' do
    @store.store(Value.new(:objkey2), Value.new(:objval2), :expires => 2)
    @store[Value.new(:objkey2)].should == Value.new(:objval2)
    sleep 1
    @store[Value.new(:objkey2)].should == Value.new(:objval2)
    sleep 2
    @store.delete(Value.new(:objkey2)).should == nil
  end
end

#################### null_objectkey_hashvalue ####################

shared_examples_for 'null_objectkey_hashvalue' do
  it "reads from keys that are Objects like a Hash" do
    @store[Value.new(:objkey1)].should == nil
    @store.load(Value.new(:objkey1)).should == nil
  end

  it "guarantees that the same Hash value is returned when setting a Object key" do
    value = {"hashval1"=>"hashval2"}
    (@store[Value.new(:objkey1)] = value).should equal(value)
  end

  it "returns false from key? if a Object key is not available" do
    @store.key?(Value.new(:objkey1)).should == false
  end

  it "returns nil from delete if an element for a Object key does not exist" do
    @store.delete(Value.new(:objkey1)).should == nil
  end

  it "removes all Object keys from the store with clear" do
    @store[Value.new(:objkey1)] = {"hashval1"=>"hashval2"}
    @store[Value.new(:objkey2)] = {"hashval3"=>"hashval4"}
    @store.clear.should equal(@store)
    @store.key?(Value.new(:objkey1)).should_not ==  true
    @store.key?(Value.new(:objkey2)).should_not == true
  end

  it "fetches a Object key with a default value with fetch, if the key is not available" do
    @store.fetch(Value.new(:objkey1), {"hashval1"=>"hashval2"}).should == {"hashval1"=>"hashval2"}
  end

  it "fetches a Object key with a block with fetch, if the key is not available" do
    key = Value.new(:objkey1)
    value = {"hashval1"=>"hashval2"}
    @store.fetch(key) do |k|
      k.should equal(key)
      value
    end.should equal(value)
  end

  it 'should accept options' do
    @store.key?(Value.new(:objkey1), :option1 => 1).should == false
    @store.load(Value.new(:objkey1), :option2 => 2).should == nil
    @store.fetch(Value.new(:objkey1), nil, :option3 => 3).should == nil
    @store.delete(Value.new(:objkey1), :option4 => 4).should == nil
    @store.clear(:option5 => 5).should equal(@store)
    @store.store(Value.new(:objkey1), {"hashval1"=>"hashval2"}, :option6 => 6).should == {"hashval1"=>"hashval2"}
  end
end

#################### store_objectkey_hashvalue ####################

shared_examples_for 'store_objectkey_hashvalue' do
  it "writes Hash values to keys that are Objects like a Hash" do
    @store[Value.new(:objkey1)] = {"hashval1"=>"hashval2"}
    @store[Value.new(:objkey1)].should == {"hashval1"=>"hashval2"}
    @store.load(Value.new(:objkey1)).should == {"hashval1"=>"hashval2"}
  end

  it "returns true from key? if a Object key is available" do
    @store[Value.new(:objkey1)] = {"hashval1"=>"hashval2"}
    @store.key?(Value.new(:objkey1)).should == true
  end

  it "stores Hash values with Object keys with #store" do
    value = {"hashval1"=>"hashval2"}
    @store.store(Value.new(:objkey1), value).should equal(value)
    @store[Value.new(:objkey1)].should == {"hashval1"=>"hashval2"}
    @store.load(Value.new(:objkey1)).should == {"hashval1"=>"hashval2"}
  end

  it "removes and returns a Hash element with a Object key from the backing store via delete if it exists" do
    @store[Value.new(:objkey1)] = {"hashval1"=>"hashval2"}
    @store.delete(Value.new(:objkey1)).should == {"hashval1"=>"hashval2"}
    @store.key?(Value.new(:objkey1)).should == false
  end

  it "does not run the block if the Object key is available" do
    @store[Value.new(:objkey1)] = {"hashval1"=>"hashval2"}
    unaltered = "unaltered"
    @store.fetch(Value.new(:objkey1)) { unaltered = "altered" }
    unaltered.should == "unaltered"
  end

  it "fetches a Object key with a default value with fetch, if the key is available" do
    @store[Value.new(:objkey1)] = {"hashval1"=>"hashval2"}
    @store.fetch(Value.new(:objkey1), {"hashval3"=>"hashval4"}).should == {"hashval1"=>"hashval2"}
  end
end

#################### returndifferent_objectkey_hashvalue ####################

shared_examples_for 'returndifferent_objectkey_hashvalue' do
  it "guarantees that a different Hash value is retrieved from the Object key" do
    value = {"hashval1"=>"hashval2"}
    @store[Value.new(:objkey1)] = {"hashval1"=>"hashval2"}
    @store[Value.new(:objkey1)].should_not be_equal({"hashval1"=>"hashval2"})
  end
end

#################### expires_objectkey_hashvalue ####################

shared_examples_for 'expires_objectkey_hashvalue' do
  it 'should support expires on store and #[]' do
    @store.store(Value.new(:objkey1), {"hashval1"=>"hashval2"}, :expires => 2)
    @store[Value.new(:objkey1)].should == {"hashval1"=>"hashval2"}
    sleep 1
    @store[Value.new(:objkey1)].should == {"hashval1"=>"hashval2"}
    sleep 2
    @store[Value.new(:objkey1)].should == nil
  end

  it 'should support expires on store and load' do
    @store.store(Value.new(:objkey1), {"hashval1"=>"hashval2"}, :expires => 2)
    @store.load(Value.new(:objkey1)).should == {"hashval1"=>"hashval2"}
    sleep 1
    @store.load(Value.new(:objkey1)).should == {"hashval1"=>"hashval2"}
    sleep 2
    @store.load(Value.new(:objkey1)).should == nil
  end

  it 'should support expires on store and key?' do
    @store.store(Value.new(:objkey1), {"hashval1"=>"hashval2"}, :expires => 2)
    @store.key?(Value.new(:objkey1)).should == true
    sleep 1
    @store.key?(Value.new(:objkey1)).should == true
    sleep 2
    @store.key?(Value.new(:objkey1)).should == false
  end

  it 'should support updating the expiration time in load' do
    @store.store(Value.new(:objkey2), {"hashval3"=>"hashval4"}, :expires => 2)
    @store[Value.new(:objkey2)].should == {"hashval3"=>"hashval4"}
    sleep 1
    @store.load(Value.new(:objkey2), :expires => 3).should == {"hashval3"=>"hashval4"}
    @store[Value.new(:objkey2)].should == {"hashval3"=>"hashval4"}
    sleep 1
    @store[Value.new(:objkey2)].should == {"hashval3"=>"hashval4"}
    sleep 3
    @store[Value.new(:objkey2)].should == nil
  end

  it 'should support updating the expiration time in fetch' do
    @store.store(Value.new(:objkey1), {"hashval1"=>"hashval2"}, :expires => 2)
    @store[Value.new(:objkey1)].should == {"hashval1"=>"hashval2"}
    sleep 1
    @store.fetch(Value.new(:objkey1), nil, :expires => 3).should == {"hashval1"=>"hashval2"}
    @store[Value.new(:objkey1)].should == {"hashval1"=>"hashval2"}
    sleep 1
    @store[Value.new(:objkey1)].should == {"hashval1"=>"hashval2"}
    sleep 3
    @store[Value.new(:objkey1)].should == nil
  end

  it 'should respect expires in delete' do
    @store.store(Value.new(:objkey2), {"hashval3"=>"hashval4"}, :expires => 2)
    @store[Value.new(:objkey2)].should == {"hashval3"=>"hashval4"}
    sleep 1
    @store[Value.new(:objkey2)].should == {"hashval3"=>"hashval4"}
    sleep 2
    @store.delete(Value.new(:objkey2)).should == nil
  end
end

#################### null_hashkey_stringvalue ####################

shared_examples_for 'null_hashkey_stringvalue' do
  it "reads from keys that are Hashs like a Hash" do
    @store[{"hashkey1"=>"hashkey2"}].should == nil
    @store.load({"hashkey1"=>"hashkey2"}).should == nil
  end

  it "guarantees that the same String value is returned when setting a Hash key" do
    value = "strval1"
    (@store[{"hashkey1"=>"hashkey2"}] = value).should equal(value)
  end

  it "returns false from key? if a Hash key is not available" do
    @store.key?({"hashkey1"=>"hashkey2"}).should == false
  end

  it "returns nil from delete if an element for a Hash key does not exist" do
    @store.delete({"hashkey1"=>"hashkey2"}).should == nil
  end

  it "removes all Hash keys from the store with clear" do
    @store[{"hashkey1"=>"hashkey2"}] = "strval1"
    @store[{"hashkey3"=>"hashkey4"}] = "strval2"
    @store.clear.should equal(@store)
    @store.key?({"hashkey1"=>"hashkey2"}).should_not ==  true
    @store.key?({"hashkey3"=>"hashkey4"}).should_not == true
  end

  it "fetches a Hash key with a default value with fetch, if the key is not available" do
    @store.fetch({"hashkey1"=>"hashkey2"}, "strval1").should == "strval1"
  end

  it "fetches a Hash key with a block with fetch, if the key is not available" do
    key = {"hashkey1"=>"hashkey2"}
    value = "strval1"
    @store.fetch(key) do |k|
      k.should equal(key)
      value
    end.should equal(value)
  end

  it 'should accept options' do
    @store.key?({"hashkey1"=>"hashkey2"}, :option1 => 1).should == false
    @store.load({"hashkey1"=>"hashkey2"}, :option2 => 2).should == nil
    @store.fetch({"hashkey1"=>"hashkey2"}, nil, :option3 => 3).should == nil
    @store.delete({"hashkey1"=>"hashkey2"}, :option4 => 4).should == nil
    @store.clear(:option5 => 5).should equal(@store)
    @store.store({"hashkey1"=>"hashkey2"}, "strval1", :option6 => 6).should == "strval1"
  end
end

#################### store_hashkey_stringvalue ####################

shared_examples_for 'store_hashkey_stringvalue' do
  it "writes String values to keys that are Hashs like a Hash" do
    @store[{"hashkey1"=>"hashkey2"}] = "strval1"
    @store[{"hashkey1"=>"hashkey2"}].should == "strval1"
    @store.load({"hashkey1"=>"hashkey2"}).should == "strval1"
  end

  it "returns true from key? if a Hash key is available" do
    @store[{"hashkey1"=>"hashkey2"}] = "strval1"
    @store.key?({"hashkey1"=>"hashkey2"}).should == true
  end

  it "stores String values with Hash keys with #store" do
    value = "strval1"
    @store.store({"hashkey1"=>"hashkey2"}, value).should equal(value)
    @store[{"hashkey1"=>"hashkey2"}].should == "strval1"
    @store.load({"hashkey1"=>"hashkey2"}).should == "strval1"
  end

  it "removes and returns a String element with a Hash key from the backing store via delete if it exists" do
    @store[{"hashkey1"=>"hashkey2"}] = "strval1"
    @store.delete({"hashkey1"=>"hashkey2"}).should == "strval1"
    @store.key?({"hashkey1"=>"hashkey2"}).should == false
  end

  it "does not run the block if the Hash key is available" do
    @store[{"hashkey1"=>"hashkey2"}] = "strval1"
    unaltered = "unaltered"
    @store.fetch({"hashkey1"=>"hashkey2"}) { unaltered = "altered" }
    unaltered.should == "unaltered"
  end

  it "fetches a Hash key with a default value with fetch, if the key is available" do
    @store[{"hashkey1"=>"hashkey2"}] = "strval1"
    @store.fetch({"hashkey1"=>"hashkey2"}, "strval2").should == "strval1"
  end
end

#################### returndifferent_hashkey_stringvalue ####################

shared_examples_for 'returndifferent_hashkey_stringvalue' do
  it "guarantees that a different String value is retrieved from the Hash key" do
    value = "strval1"
    @store[{"hashkey1"=>"hashkey2"}] = "strval1"
    @store[{"hashkey1"=>"hashkey2"}].should_not be_equal("strval1")
  end
end

#################### expires_hashkey_stringvalue ####################

shared_examples_for 'expires_hashkey_stringvalue' do
  it 'should support expires on store and #[]' do
    @store.store({"hashkey1"=>"hashkey2"}, "strval1", :expires => 2)
    @store[{"hashkey1"=>"hashkey2"}].should == "strval1"
    sleep 1
    @store[{"hashkey1"=>"hashkey2"}].should == "strval1"
    sleep 2
    @store[{"hashkey1"=>"hashkey2"}].should == nil
  end

  it 'should support expires on store and load' do
    @store.store({"hashkey1"=>"hashkey2"}, "strval1", :expires => 2)
    @store.load({"hashkey1"=>"hashkey2"}).should == "strval1"
    sleep 1
    @store.load({"hashkey1"=>"hashkey2"}).should == "strval1"
    sleep 2
    @store.load({"hashkey1"=>"hashkey2"}).should == nil
  end

  it 'should support expires on store and key?' do
    @store.store({"hashkey1"=>"hashkey2"}, "strval1", :expires => 2)
    @store.key?({"hashkey1"=>"hashkey2"}).should == true
    sleep 1
    @store.key?({"hashkey1"=>"hashkey2"}).should == true
    sleep 2
    @store.key?({"hashkey1"=>"hashkey2"}).should == false
  end

  it 'should support updating the expiration time in load' do
    @store.store({"hashkey3"=>"hashkey4"}, "strval2", :expires => 2)
    @store[{"hashkey3"=>"hashkey4"}].should == "strval2"
    sleep 1
    @store.load({"hashkey3"=>"hashkey4"}, :expires => 3).should == "strval2"
    @store[{"hashkey3"=>"hashkey4"}].should == "strval2"
    sleep 1
    @store[{"hashkey3"=>"hashkey4"}].should == "strval2"
    sleep 3
    @store[{"hashkey3"=>"hashkey4"}].should == nil
  end

  it 'should support updating the expiration time in fetch' do
    @store.store({"hashkey1"=>"hashkey2"}, "strval1", :expires => 2)
    @store[{"hashkey1"=>"hashkey2"}].should == "strval1"
    sleep 1
    @store.fetch({"hashkey1"=>"hashkey2"}, nil, :expires => 3).should == "strval1"
    @store[{"hashkey1"=>"hashkey2"}].should == "strval1"
    sleep 1
    @store[{"hashkey1"=>"hashkey2"}].should == "strval1"
    sleep 3
    @store[{"hashkey1"=>"hashkey2"}].should == nil
  end

  it 'should respect expires in delete' do
    @store.store({"hashkey3"=>"hashkey4"}, "strval2", :expires => 2)
    @store[{"hashkey3"=>"hashkey4"}].should == "strval2"
    sleep 1
    @store[{"hashkey3"=>"hashkey4"}].should == "strval2"
    sleep 2
    @store.delete({"hashkey3"=>"hashkey4"}).should == nil
  end
end

#################### null_hashkey_objectvalue ####################

shared_examples_for 'null_hashkey_objectvalue' do
  it "reads from keys that are Hashs like a Hash" do
    @store[{"hashkey1"=>"hashkey2"}].should == nil
    @store.load({"hashkey1"=>"hashkey2"}).should == nil
  end

  it "guarantees that the same Object value is returned when setting a Hash key" do
    value = Value.new(:objval1)
    (@store[{"hashkey1"=>"hashkey2"}] = value).should equal(value)
  end

  it "returns false from key? if a Hash key is not available" do
    @store.key?({"hashkey1"=>"hashkey2"}).should == false
  end

  it "returns nil from delete if an element for a Hash key does not exist" do
    @store.delete({"hashkey1"=>"hashkey2"}).should == nil
  end

  it "removes all Hash keys from the store with clear" do
    @store[{"hashkey1"=>"hashkey2"}] = Value.new(:objval1)
    @store[{"hashkey3"=>"hashkey4"}] = Value.new(:objval2)
    @store.clear.should equal(@store)
    @store.key?({"hashkey1"=>"hashkey2"}).should_not ==  true
    @store.key?({"hashkey3"=>"hashkey4"}).should_not == true
  end

  it "fetches a Hash key with a default value with fetch, if the key is not available" do
    @store.fetch({"hashkey1"=>"hashkey2"}, Value.new(:objval1)).should == Value.new(:objval1)
  end

  it "fetches a Hash key with a block with fetch, if the key is not available" do
    key = {"hashkey1"=>"hashkey2"}
    value = Value.new(:objval1)
    @store.fetch(key) do |k|
      k.should equal(key)
      value
    end.should equal(value)
  end

  it 'should accept options' do
    @store.key?({"hashkey1"=>"hashkey2"}, :option1 => 1).should == false
    @store.load({"hashkey1"=>"hashkey2"}, :option2 => 2).should == nil
    @store.fetch({"hashkey1"=>"hashkey2"}, nil, :option3 => 3).should == nil
    @store.delete({"hashkey1"=>"hashkey2"}, :option4 => 4).should == nil
    @store.clear(:option5 => 5).should equal(@store)
    @store.store({"hashkey1"=>"hashkey2"}, Value.new(:objval1), :option6 => 6).should == Value.new(:objval1)
  end
end

#################### store_hashkey_objectvalue ####################

shared_examples_for 'store_hashkey_objectvalue' do
  it "writes Object values to keys that are Hashs like a Hash" do
    @store[{"hashkey1"=>"hashkey2"}] = Value.new(:objval1)
    @store[{"hashkey1"=>"hashkey2"}].should == Value.new(:objval1)
    @store.load({"hashkey1"=>"hashkey2"}).should == Value.new(:objval1)
  end

  it "returns true from key? if a Hash key is available" do
    @store[{"hashkey1"=>"hashkey2"}] = Value.new(:objval1)
    @store.key?({"hashkey1"=>"hashkey2"}).should == true
  end

  it "stores Object values with Hash keys with #store" do
    value = Value.new(:objval1)
    @store.store({"hashkey1"=>"hashkey2"}, value).should equal(value)
    @store[{"hashkey1"=>"hashkey2"}].should == Value.new(:objval1)
    @store.load({"hashkey1"=>"hashkey2"}).should == Value.new(:objval1)
  end

  it "removes and returns a Object element with a Hash key from the backing store via delete if it exists" do
    @store[{"hashkey1"=>"hashkey2"}] = Value.new(:objval1)
    @store.delete({"hashkey1"=>"hashkey2"}).should == Value.new(:objval1)
    @store.key?({"hashkey1"=>"hashkey2"}).should == false
  end

  it "does not run the block if the Hash key is available" do
    @store[{"hashkey1"=>"hashkey2"}] = Value.new(:objval1)
    unaltered = "unaltered"
    @store.fetch({"hashkey1"=>"hashkey2"}) { unaltered = "altered" }
    unaltered.should == "unaltered"
  end

  it "fetches a Hash key with a default value with fetch, if the key is available" do
    @store[{"hashkey1"=>"hashkey2"}] = Value.new(:objval1)
    @store.fetch({"hashkey1"=>"hashkey2"}, Value.new(:objval2)).should == Value.new(:objval1)
  end
end

#################### returndifferent_hashkey_objectvalue ####################

shared_examples_for 'returndifferent_hashkey_objectvalue' do
  it "guarantees that a different Object value is retrieved from the Hash key" do
    value = Value.new(:objval1)
    @store[{"hashkey1"=>"hashkey2"}] = Value.new(:objval1)
    @store[{"hashkey1"=>"hashkey2"}].should_not be_equal(Value.new(:objval1))
  end
end

#################### expires_hashkey_objectvalue ####################

shared_examples_for 'expires_hashkey_objectvalue' do
  it 'should support expires on store and #[]' do
    @store.store({"hashkey1"=>"hashkey2"}, Value.new(:objval1), :expires => 2)
    @store[{"hashkey1"=>"hashkey2"}].should == Value.new(:objval1)
    sleep 1
    @store[{"hashkey1"=>"hashkey2"}].should == Value.new(:objval1)
    sleep 2
    @store[{"hashkey1"=>"hashkey2"}].should == nil
  end

  it 'should support expires on store and load' do
    @store.store({"hashkey1"=>"hashkey2"}, Value.new(:objval1), :expires => 2)
    @store.load({"hashkey1"=>"hashkey2"}).should == Value.new(:objval1)
    sleep 1
    @store.load({"hashkey1"=>"hashkey2"}).should == Value.new(:objval1)
    sleep 2
    @store.load({"hashkey1"=>"hashkey2"}).should == nil
  end

  it 'should support expires on store and key?' do
    @store.store({"hashkey1"=>"hashkey2"}, Value.new(:objval1), :expires => 2)
    @store.key?({"hashkey1"=>"hashkey2"}).should == true
    sleep 1
    @store.key?({"hashkey1"=>"hashkey2"}).should == true
    sleep 2
    @store.key?({"hashkey1"=>"hashkey2"}).should == false
  end

  it 'should support updating the expiration time in load' do
    @store.store({"hashkey3"=>"hashkey4"}, Value.new(:objval2), :expires => 2)
    @store[{"hashkey3"=>"hashkey4"}].should == Value.new(:objval2)
    sleep 1
    @store.load({"hashkey3"=>"hashkey4"}, :expires => 3).should == Value.new(:objval2)
    @store[{"hashkey3"=>"hashkey4"}].should == Value.new(:objval2)
    sleep 1
    @store[{"hashkey3"=>"hashkey4"}].should == Value.new(:objval2)
    sleep 3
    @store[{"hashkey3"=>"hashkey4"}].should == nil
  end

  it 'should support updating the expiration time in fetch' do
    @store.store({"hashkey1"=>"hashkey2"}, Value.new(:objval1), :expires => 2)
    @store[{"hashkey1"=>"hashkey2"}].should == Value.new(:objval1)
    sleep 1
    @store.fetch({"hashkey1"=>"hashkey2"}, nil, :expires => 3).should == Value.new(:objval1)
    @store[{"hashkey1"=>"hashkey2"}].should == Value.new(:objval1)
    sleep 1
    @store[{"hashkey1"=>"hashkey2"}].should == Value.new(:objval1)
    sleep 3
    @store[{"hashkey1"=>"hashkey2"}].should == nil
  end

  it 'should respect expires in delete' do
    @store.store({"hashkey3"=>"hashkey4"}, Value.new(:objval2), :expires => 2)
    @store[{"hashkey3"=>"hashkey4"}].should == Value.new(:objval2)
    sleep 1
    @store[{"hashkey3"=>"hashkey4"}].should == Value.new(:objval2)
    sleep 2
    @store.delete({"hashkey3"=>"hashkey4"}).should == nil
  end
end

#################### null_hashkey_hashvalue ####################

shared_examples_for 'null_hashkey_hashvalue' do
  it "reads from keys that are Hashs like a Hash" do
    @store[{"hashkey1"=>"hashkey2"}].should == nil
    @store.load({"hashkey1"=>"hashkey2"}).should == nil
  end

  it "guarantees that the same Hash value is returned when setting a Hash key" do
    value = {"hashval1"=>"hashval2"}
    (@store[{"hashkey1"=>"hashkey2"}] = value).should equal(value)
  end

  it "returns false from key? if a Hash key is not available" do
    @store.key?({"hashkey1"=>"hashkey2"}).should == false
  end

  it "returns nil from delete if an element for a Hash key does not exist" do
    @store.delete({"hashkey1"=>"hashkey2"}).should == nil
  end

  it "removes all Hash keys from the store with clear" do
    @store[{"hashkey1"=>"hashkey2"}] = {"hashval1"=>"hashval2"}
    @store[{"hashkey3"=>"hashkey4"}] = {"hashval3"=>"hashval4"}
    @store.clear.should equal(@store)
    @store.key?({"hashkey1"=>"hashkey2"}).should_not ==  true
    @store.key?({"hashkey3"=>"hashkey4"}).should_not == true
  end

  it "fetches a Hash key with a default value with fetch, if the key is not available" do
    @store.fetch({"hashkey1"=>"hashkey2"}, {"hashval1"=>"hashval2"}).should == {"hashval1"=>"hashval2"}
  end

  it "fetches a Hash key with a block with fetch, if the key is not available" do
    key = {"hashkey1"=>"hashkey2"}
    value = {"hashval1"=>"hashval2"}
    @store.fetch(key) do |k|
      k.should equal(key)
      value
    end.should equal(value)
  end

  it 'should accept options' do
    @store.key?({"hashkey1"=>"hashkey2"}, :option1 => 1).should == false
    @store.load({"hashkey1"=>"hashkey2"}, :option2 => 2).should == nil
    @store.fetch({"hashkey1"=>"hashkey2"}, nil, :option3 => 3).should == nil
    @store.delete({"hashkey1"=>"hashkey2"}, :option4 => 4).should == nil
    @store.clear(:option5 => 5).should equal(@store)
    @store.store({"hashkey1"=>"hashkey2"}, {"hashval1"=>"hashval2"}, :option6 => 6).should == {"hashval1"=>"hashval2"}
  end
end

#################### store_hashkey_hashvalue ####################

shared_examples_for 'store_hashkey_hashvalue' do
  it "writes Hash values to keys that are Hashs like a Hash" do
    @store[{"hashkey1"=>"hashkey2"}] = {"hashval1"=>"hashval2"}
    @store[{"hashkey1"=>"hashkey2"}].should == {"hashval1"=>"hashval2"}
    @store.load({"hashkey1"=>"hashkey2"}).should == {"hashval1"=>"hashval2"}
  end

  it "returns true from key? if a Hash key is available" do
    @store[{"hashkey1"=>"hashkey2"}] = {"hashval1"=>"hashval2"}
    @store.key?({"hashkey1"=>"hashkey2"}).should == true
  end

  it "stores Hash values with Hash keys with #store" do
    value = {"hashval1"=>"hashval2"}
    @store.store({"hashkey1"=>"hashkey2"}, value).should equal(value)
    @store[{"hashkey1"=>"hashkey2"}].should == {"hashval1"=>"hashval2"}
    @store.load({"hashkey1"=>"hashkey2"}).should == {"hashval1"=>"hashval2"}
  end

  it "removes and returns a Hash element with a Hash key from the backing store via delete if it exists" do
    @store[{"hashkey1"=>"hashkey2"}] = {"hashval1"=>"hashval2"}
    @store.delete({"hashkey1"=>"hashkey2"}).should == {"hashval1"=>"hashval2"}
    @store.key?({"hashkey1"=>"hashkey2"}).should == false
  end

  it "does not run the block if the Hash key is available" do
    @store[{"hashkey1"=>"hashkey2"}] = {"hashval1"=>"hashval2"}
    unaltered = "unaltered"
    @store.fetch({"hashkey1"=>"hashkey2"}) { unaltered = "altered" }
    unaltered.should == "unaltered"
  end

  it "fetches a Hash key with a default value with fetch, if the key is available" do
    @store[{"hashkey1"=>"hashkey2"}] = {"hashval1"=>"hashval2"}
    @store.fetch({"hashkey1"=>"hashkey2"}, {"hashval3"=>"hashval4"}).should == {"hashval1"=>"hashval2"}
  end
end

#################### returndifferent_hashkey_hashvalue ####################

shared_examples_for 'returndifferent_hashkey_hashvalue' do
  it "guarantees that a different Hash value is retrieved from the Hash key" do
    value = {"hashval1"=>"hashval2"}
    @store[{"hashkey1"=>"hashkey2"}] = {"hashval1"=>"hashval2"}
    @store[{"hashkey1"=>"hashkey2"}].should_not be_equal({"hashval1"=>"hashval2"})
  end
end

#################### expires_hashkey_hashvalue ####################

shared_examples_for 'expires_hashkey_hashvalue' do
  it 'should support expires on store and #[]' do
    @store.store({"hashkey1"=>"hashkey2"}, {"hashval1"=>"hashval2"}, :expires => 2)
    @store[{"hashkey1"=>"hashkey2"}].should == {"hashval1"=>"hashval2"}
    sleep 1
    @store[{"hashkey1"=>"hashkey2"}].should == {"hashval1"=>"hashval2"}
    sleep 2
    @store[{"hashkey1"=>"hashkey2"}].should == nil
  end

  it 'should support expires on store and load' do
    @store.store({"hashkey1"=>"hashkey2"}, {"hashval1"=>"hashval2"}, :expires => 2)
    @store.load({"hashkey1"=>"hashkey2"}).should == {"hashval1"=>"hashval2"}
    sleep 1
    @store.load({"hashkey1"=>"hashkey2"}).should == {"hashval1"=>"hashval2"}
    sleep 2
    @store.load({"hashkey1"=>"hashkey2"}).should == nil
  end

  it 'should support expires on store and key?' do
    @store.store({"hashkey1"=>"hashkey2"}, {"hashval1"=>"hashval2"}, :expires => 2)
    @store.key?({"hashkey1"=>"hashkey2"}).should == true
    sleep 1
    @store.key?({"hashkey1"=>"hashkey2"}).should == true
    sleep 2
    @store.key?({"hashkey1"=>"hashkey2"}).should == false
  end

  it 'should support updating the expiration time in load' do
    @store.store({"hashkey3"=>"hashkey4"}, {"hashval3"=>"hashval4"}, :expires => 2)
    @store[{"hashkey3"=>"hashkey4"}].should == {"hashval3"=>"hashval4"}
    sleep 1
    @store.load({"hashkey3"=>"hashkey4"}, :expires => 3).should == {"hashval3"=>"hashval4"}
    @store[{"hashkey3"=>"hashkey4"}].should == {"hashval3"=>"hashval4"}
    sleep 1
    @store[{"hashkey3"=>"hashkey4"}].should == {"hashval3"=>"hashval4"}
    sleep 3
    @store[{"hashkey3"=>"hashkey4"}].should == nil
  end

  it 'should support updating the expiration time in fetch' do
    @store.store({"hashkey1"=>"hashkey2"}, {"hashval1"=>"hashval2"}, :expires => 2)
    @store[{"hashkey1"=>"hashkey2"}].should == {"hashval1"=>"hashval2"}
    sleep 1
    @store.fetch({"hashkey1"=>"hashkey2"}, nil, :expires => 3).should == {"hashval1"=>"hashval2"}
    @store[{"hashkey1"=>"hashkey2"}].should == {"hashval1"=>"hashval2"}
    sleep 1
    @store[{"hashkey1"=>"hashkey2"}].should == {"hashval1"=>"hashval2"}
    sleep 3
    @store[{"hashkey1"=>"hashkey2"}].should == nil
  end

  it 'should respect expires in delete' do
    @store.store({"hashkey3"=>"hashkey4"}, {"hashval3"=>"hashval4"}, :expires => 2)
    @store[{"hashkey3"=>"hashkey4"}].should == {"hashval3"=>"hashval4"}
    sleep 1
    @store[{"hashkey3"=>"hashkey4"}].should == {"hashval3"=>"hashval4"}
    sleep 2
    @store.delete({"hashkey3"=>"hashkey4"}).should == nil
  end
end

#################### marshallable_key ####################

shared_examples_for 'marshallable_key' do
  it "refuses to #[] from keys that cannot be marshalled" do
    expect do
      @store[Struct.new(:foo).new(:bar)]
    end.to raise_error(marshal_error)
  end

  it "refuses to load from keys that cannot be marshalled" do
    expect do
      @store.load(Struct.new(:foo).new(:bar))
    end.to raise_error(marshal_error)
  end

  it "refuses to fetch from keys that cannot be marshalled" do
    expect do
      @store.fetch(Struct.new(:foo).new(:bar), true)
    end.to raise_error(marshal_error)
  end

  it "refuses to #[]= to keys that cannot be marshalled" do
    expect do
      @store[Struct.new(:foo).new(:bar)] = 'value'
    end.to raise_error(marshal_error)
  end

  it "refuses to store to keys that cannot be marshalled" do
    expect do
      @store.store Struct.new(:foo).new(:bar), 'value'
    end.to raise_error(marshal_error)
  end

  it "refuses to check for key? if the key cannot be marshalled" do
    expect do
      @store.key? Struct.new(:foo).new(:bar)
    end.to raise_error(marshal_error)
  end

  it "refuses to delete a key if the key cannot be marshalled" do
    expect do
      @store.delete Struct.new(:foo).new(:bar)
    end.to raise_error(marshal_error)
  end
end

