require "minitest/autorun"
require "redis"
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require "tempest/session"

describe Tempest::Session do
  let(:redis) { Redis.new }
  let(:session) { Tempest::Session.new redis, 42 }

  it "should handle session in the rack way" do
    session.clear
    session['name'] = 'Bob'
    session['name'].should eq 'Bob'
    session['toto'].should be_nil
    session.delete 'name'
    session.fetch('name').should be_nil
    session.fetch('name', 42).should eq(42)
  end

end
