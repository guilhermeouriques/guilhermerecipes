require 'test_helper'

class ChefTest < ActiveSupport::TestCase

  def setup
    @chef = Chef.new(chefname: "Guilherme", email: "gui@gui.com",
                    password: "password", password_confirmation: "password")
  end

  test "should be valid" do
    assert @chef.valid?
  end

  test "name should be present" do
    @chef.chefname = " "
    assert_not @chef.valid?
  end

  test "name should be less than 30 characters" do
    @chef.chefname = "a" * 31
    assert_not @chef.valid?
  end

  test "email should be present" do
    @chef.email = " "
    assert_not @chef.valid?
  end

  test "email should not be too long" do
    @chef.email = "a" * 250 + "@gui.com"
    assert_not @chef.valid?
  end

  test "email should accept correct format" do
    valid_emails = %w[user@example.com GUIVA@gmail.com M.first@yahoo.ca
                      john+smith@co.uk.org srl_gui@msn.com]
    valid_emails.each do |valids|
      @chef.email = valids
      assert @chef.valid?, "#{valids.inspect} shoud be valid"
    end
  end

  test "should reject invalid email addresses" do
    invalid_emails = %w[gui@example gui@example,com gui@gmail. joe@bar+foo.com]
    invalid_emails.each do |invalids|
      @chef.email = invalids
      assert_not @chef.valid?, "#{invalids.inspect} should be invalid"
    end
  end

  test "email should be unique and case insensitive" do
    duplicate_chef = @chef.dup
    duplicate_chef.email = @chef.email.upcase
    @chef.save
    assert_not duplicate_chef.valid?
  end

  test "email shoud be case lower case before hitting db" do
    mixed_email = "JohN@ExampLe.com"
    @chef.email = mixed_email
    @chef.save
    assert_equal mixed_email.downcase, @chef.reload.email
  end

  test "password should be present" do
    @chef.password = @chef.password_confirmation = " "
    assert_not @chef.valid?
  end

  test "password should be atleast 5 characters" do
    @chef.password = @chef.password_confirmation = "x" * 4
    assert_not @chef.valid?
  end

end
