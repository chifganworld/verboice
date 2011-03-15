require 'test_helper'

class CallbackCommandTest < ActiveSupport::TestCase

  test "run with url" do
    url = 'http://www.example.com'

    session = Session.new
    session[:last_capture] = '123'
    session.expects(:push_commands).with([:hangup])

    expect_em_http :post, url, :with => {:body => "CallSid=#{session.id}&Digits=123"}, :returns => '<Response><Hangup/></Response>'

    CallbackCommand.new(url).run session
  end

  test "run without url" do
    url = 'http://www.example.com'

    session = Session.new :application => mock('application')
    session.application.expects(:callback_url).returns(url)
    session[:last_capture] = '123'
    session.expects(:push_commands).with([:hangup])

    expect_em_http :post, url, :with => {:body => "CallSid=#{session.id}&Digits=123"}, :returns => '<Response><Hangup/></Response>'

    CallbackCommand.new.run session
  end

end
