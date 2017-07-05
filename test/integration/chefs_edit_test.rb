require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest

  def setup
    @chef = Chef.create!(chefname: "lol", email: "lol@lol.com",
                        password: "password", password_confirmation: "password")
  end

  test "reject invalid edit" do
    sign_in_as(@chef, "password")
		get edit_chef_path(@chef)
		patch chef_path(@chef), params: {chef: {chefname: "", email: "lol@lol.com"}}
    assert_template 'chefs/edit'
		assert_select 'h2.panel-title'
		assert_select 'div.panel-body'
	end

	test "accept valid signup" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
		patch chef_path(@chef), params: {chef: {chefname: "Lol1", email: "lol1@lol.com"}}
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "Lol1", @chef.chefname
    assert_match "lol1@lol.com", @chef.email
	end

end
