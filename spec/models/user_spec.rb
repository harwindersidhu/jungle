require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Validations" do
    before(:each) do
      @user = User.new do |u|
        u.first_name = "test"
        u.last_name = "test"
        u.email = "test@gmail.com"
        u.password = "test1234"
        u.password_confirmation = "test1234"
      end
    end

    it "valid when there are all required validated fields" do
      expect(@user).to be_valid
    end

    it "error if password is nil" do
      @user.password = nil
      @user.save
      expect(@user.errors.full_messages).to include("Password can't be blank")
    end

    it "error if password_confirmation is nil" do
      @user.password_confirmation = nil
      @user.save
      expect(@user.errors.full_messages).to include("Password confirmation can't be blank")
    end

    it "error if password and password_confirmation does not match" do
      @user.password = "test123456"
      @user.password_confirmation = "test1234"
      @user.save
      expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
    end

    it "error if email is nil" do 
      @user.email = nil
      @user.save
      expect(@user.errors.full_messages).to include("Email can't be blank")
    end

    it "error if email is not unique" do
      @user.save

      @user_two = User.new(first_name: "user", last_name:"two", email: "TEST@GMAIL.COM", password: "12345678", password_confirmation: "12345678")
      @user_two.save

      expect(@user_two.errors.full_messages).to include("Email has already been taken")
    end

    it "error if first_name is nil" do
      @user.first_name = nil
      @user.save
      expect(@user.errors.full_messages).to include("First name can't be blank")
    end

    it "error if last_name is nil" do
      @user.last_name = nil
      @user.save
      expect(@user.errors.full_messages).to include("Last name can't be blank")
    end

    it "error if password is less than minimum length" do
      @user.password = "1234"
      @user.password_confirmation = "1234"
      @user.save
      expect(@user.errors.full_messages).to include("Password is too short (minimum is 8 characters)")
    end
  end

  describe '.authenticate_with_credentials' do
    before(:each) do 
      @user = User.new(first_name: "test", last_name: "test", email: "test@gmail.com", password: "test1234", password_confirmation: "test1234")
    end

    it "return user if email and password are correct" do
      @user.save
      login_user = User.authenticate_with_credentials("test@gmail.com", "test1234")
      expect(login_user).not_to be(nil)
    end

    it "return nil if email is incorrect" do
      @user.save
      login_user = User.authenticate_with_credentials("testfail@gmail.com", "test1234")
      expect(login_user).to be(nil)
    end

    it "return nil if password is incorrect" do
      @user.save
      login_user = User.authenticate_with_credentials("test@gmail.com", "testtest1234")
      expect(login_user).to be(nil)
    end

    it "return user if email is typed with spaces before and/or after" do
      @user.save
      login_user = User.authenticate_with_credentials("  test@gmail.com  ", "test1234")
      expect(login_user).not_to be(nil)
    end

    it "return user if email is typed with wrong case" do
      @user.save
      login_user = User.authenticate_with_credentials("tEsT@GmAiL.cOm", "test1234")
      expect(login_user).not_to be(nil)
    end

  end

end
