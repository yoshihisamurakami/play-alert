require 'test_helper'

class KeepaliveJobTest < ActiveJob::TestCase

  include KeepaliveHelper

  test "need_keepalive?" do
    assert_not need_keepalive?(0, 0)
    assert_not need_keepalive?(0, 30)

    assert_not need_keepalive?(7, 0)
    assert_not need_keepalive?(7, 30)
    
    assert need_keepalive?(8, 0)
    assert need_keepalive?(8, 30)
    assert_not need_keepalive?(8, 40)
    
    assert need_keepalive?(23, 0)
    assert need_keepalive?(23, 35)
    assert_not need_keepalive?(23, 40)
  end
  
end
