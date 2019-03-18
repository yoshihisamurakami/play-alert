require 'test_helper'

class KeepaliveJobTest < ActiveJob::TestCase

  include KeepaliveHelper

  test "need_keepalive?" do
    assert_not need_keepalive?(0, 0)
    assert_not need_keepalive?(0, 30)

    assert_not need_keepalive?(7, 0)
    assert_not need_keepalive?(7, 30)
    
    assert need_keepalive?(13, 0)
    assert need_keepalive?(13, 30)
    assert_not need_keepalive?(13, 40)
    
    assert need_keepalive?(21, 0)
    assert need_keepalive?(21, 35)
    assert_not need_keepalive?(21, 40)
    
    assert_not need_keepalive?(22, 0)
    assert_not need_keepalive?(22, 30)
  end
  
end
