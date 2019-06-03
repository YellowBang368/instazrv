require 'rails_helper'

describe Relationship do
  describe "validation" do
    it "should raise exception if it already exists" do
      first_user = create(:user, password: "password")
      second_user = create(:user, password: "password")
      first_user.follow(second_user)
      expect( -> {first_user.follow(second_user)}).to raise_exception
    end

    it "should raise exception if the user is trying to follow himself" do
      user = create(:user, password: "password")
      expect( -> {user.follow(user)}).to raise_exception
    end
  end
end
