require 'test_helper'

class FlatTest < ActiveSupport::TestCase
  test "flat can have all possible flags" do
    flat = Flat.create(name: "Nathan's flat")

    flat.update!(flags: { sangoku: true, vegeta: false })

    assert_equal 2, flat.flags.count
    assert_instance_of ActiveFlags::Flag, flat.flags_as_collection.first
  end

  test 'flags can be queried as scope' do
    flat = Flat.create(name: "Nathan's flat", flags: { sangoku: true })
    other_flat = Flat.create(name: "Nathan's other flat", flags: { sangoku: false })

    assert_includes Flat.flagged_as_sangoku, flat
    assert_includes Flat.not_flagged_as_sangoku, other_flat
    assert_includes Flat.flagged_as_sangoku(false), other_flat

    assert_not_includes Flat.not_flagged_as_sangoku(false), other_flat
    assert_not_includes Flat.flagged_as_sangoku(false), flat
    assert_not_includes Flat.flagged_as_sangoku, other_flat
  end

  test 'flags as scope takes optional value' do
    flat = Flat.create(name: "Nathan's flat", flags: { sangoku: 'nice' })
    other_flat = Flat.create(name: "Nathan's other flat", flags: { sangoku: 'mean' })

    assert_includes Flat.flagged_as_sangoku('nice'), flat
    assert_not_includes Flat.flagged_as_sangoku('nice'), other_flat
  end

  test 'flags as scope does not break method missing' do
    assert_raises(NoMethodError) { Flat.hello_lol }
  end

  test 'flags as scope with inexistant scope fails nicely' do
    assert_empty Flat.flagged_as_caca
  end

  test 'flags as scope does not break other method_missing' do
    Flat.create!(name: 'Nathan')
    Flat.create!(name: 'Michael')

    assert_equal Flat.find_by_name('Michael'), Flat.find_by(name: 'Michael')
  end

  test 'Flat responds_to flagged_as_* and not_flagged_as_* methods' do
    assert Flat.respond_to?('flagged_as_coucou'), 'Method should exist'
    assert Flat.respond_to?('not_flagged_as_coucou'), 'Method should exist'
  end
end
