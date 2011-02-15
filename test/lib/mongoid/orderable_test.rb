require 'test_helper'

class MockModel
  include Mongoid::Document
  include Mongoid::Orderable
  
  field :title
end

class OrderableTest < Test::Unit::TestCase

  def teardown
    MockModel.destroy_all
    Mongoid.database.collection("mock_models").drop
  end
  
  def test_create_first_model
    mm = MockModel.create(:title => "first one")
    assert_equal mm.position, 0
  end
  
  def test_create_two_models_and_move
    mm = MockModel.create(:title => "first one")
    assert_equal mm.position, 0
    mm2 = MockModel.create(:title => "second one")
    assert_equal mm2.position, 1
    mm2.move_up
    assert_equal mm2.position, 0
    mm2.move_down
    assert_equal mm2.position, 1
    mm3 = MockModel.create(:title => "third one")
    mm3.move_above(mm2)
    assert_equal mm3.position, 1
    mm3.move_below(mm2)
    assert_equal mm3.position, 2
    mm3.move_to_top
    assert_equal mm3.position, 0
    mm3.move_to_bottom
    assert_equal mm3.position, 2
  end
  
  def test_destroy_one
    mm = MockModel.create(:title => "first one")
    assert_equal mm.position, 0
    mm2 = MockModel.create(:title => "second one")
    assert_equal mm2.position, 1
    mm.destroy
    mm2.reload
    assert_equal mm2.position, 0
  end
end # AssignTest
