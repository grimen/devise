# encoding: utf-8
require 'test/test_helper'

class LinkHelpersTest < ActionController::IntegrationTest

  [:user, :admin].each do |scope|
    test "auto-detection link: render :sign_in action link for scope #{scope} if signed out - using defaults" do
      visit 'home/index'
      assert_contain("Sign in")
      scope_sign_in_path = send(:"new_#{scope}_session_path")
      assert_have_selector %Q{a.devise.sign_in_link.#{scope}[@href="#{scope_sign_in_path}"]}
    end

    test "auto-detection link: render :sign_in action link for scope #{scope} if signed out - using I18n" do
      store_link_helper_translations do
        visit 'home/index'
        assert_contain("Login")
      end
    end

    test "auto-detection link: render :sign_in action link for scope #{scope} if signed out - using scoped I18n" do
      store_link_helper_translations(:scope => scope.to_sym) do
        visit 'home/index'
        assert_contain("Login #{scope}")
      end
    end

    # ===

    test "auto-detection link: render :sign_out action link for scope #{scope} if signed in - using defaults" do
      send :"sign_in_as_#{scope}"
      visit 'home/index'
      assert_contain("Sign out")
      scope_sign_out_path = send(:"destroy_#{scope}_session_path")
      assert_have_selector %Q{a.devise.sign_out_link.#{scope}[@href="#{scope_sign_out_path}"]}
    end

    test "auto-detection link: render :sign_out action link for scope #{scope} if signed in - using I18n" do
      send :"sign_in_as_#{scope}"
      store_link_helper_translations do
        visit 'home/index'
        assert_contain("Logout")
      end
    end

    test "auto-detection link: render :sign_out action link for #{scope} if signed in - using scoped I18n" do
      send :"sign_in_as_#{scope}"
      store_link_helper_translations(:scope => scope.to_sym) do
        visit 'home/index'
        assert_contain("Logout #{scope}")
      end
    end
  end

  private

    def store_link_helper_translations(*args, &block)
      options = args.extract_options!
      options[:scope] = [*options[:scope]]

      user_link_translations = {
          :sign_in => 'Login user',
          :sign_out => 'Logout user',
          :sign_up => 'Create user account'
        } if options[:scope].include?(:user)

      admin_link_translations = {
          :sign_in => 'Login administrator',
          :sign_out => 'Logout administrator',
          :sign_up => 'Create administrator account'
        } if options[:scope].include?(:admin)

      link_translations = {
          :sign_in => 'Login',
          :sign_out => 'Logout',
          :sign_up => 'Create account',
          :user => user_link_translations,
          :admin => admin_link_translations
        }

      store_translations :en, :devise => {
          :actions => link_translations
        }, &block
    end

end