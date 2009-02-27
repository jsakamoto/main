require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'

describe "ThreadGroup#list" do
  it "returns the list of threads in the group" do
    chan = Channel.new
    th1 = Thread.new { chan << :go; sleep }
    chan.receive.should == :go
    tg = ThreadGroup.new
    tg.add(th1)
    tg.list.should include(th1)
    
    th2 = Thread.new { chan << :go; sleep }
    chan.receive.should == :go
    
    tg.add(th2)    
    (tg.list & [th1, th2]).should include(th1, th2)

    Thread.pass until th1.status == 'sleep' || !th1.alive?
    Thread.pass until th2.status == 'sleep' || !th2.alive?
    th1.run; th1.join
    th2.run; th2.join
  end
end