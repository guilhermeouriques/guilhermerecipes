require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest

  def setup
    @chef = Chef.create!(chefname: "lol", email: "lol@lol.com",
                        password: "password", password_confirmation: "password")
    @chef2 = Chef.create!(chefname: "bobo", email: "bobo@example.com",
                        password: "password", password_confirmation: "password")
    @admin_user = Chef.create!(chefname: "admin", email: "admin@example.com",
                        password: "password", password_confirmation: "password", admin: true)
  end

  test "reject invalid edit" do
    sign_in_as(@chef, "password")
		get edit_chef_path(@chef)
		patch chef_path(@chef), params: { chef: { chefname: "", email: "lol@lol.com" } }
    assert_template 'chefs/edit'
		assert_select 'h2.panel-title'
		assert_select 'div.panel-body'
	end

	test "accept valid edit" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
		patch chef_path(@chef), params: { chef: { chefname: "Lol1", email: "lol1@lol.com" } }
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "Lol1", @chef.chefname
    assert_match "lol1@lol.com", @chef.email
	end

  test "accept edit attempt by admin" do
    sign_in_as(@admin_user, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: "Lol2", email: "lol2@lol.com" } }
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "Lol2", @chef.chefname
    assert_match "lol2@lol.com", @chef.email
  end

  test "redirect edit attempt by another non-admin user" do
    sign_in_as(@chef2, "password")
    updated_name = "joe"
    updated_email = "joe@joe.com"
    patch chef_path(@chef), params: { chef: { chefname: updated_name, email: updated_email } }
    assert_redirected_to chefs_path
    assert_not flash.empty?
    @chef.reload
    assert_match "lol", @chef.chefname
    assert_match "lol@lol.com", @chef.email
  end
end
