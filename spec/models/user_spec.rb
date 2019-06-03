require 'rails_helper'

describe User do
  describe "relationships" do
    it "should create Relationship where first user follows second" do
      first_user = create(:user, password: "password")
      second_user = create(:user, password: "password")
      first_user.follow(second_user)
      expect(Relationship.where(follower_id: first_user.id, following_id: second_user.id)).to_not be_nil
      expect(second_user.followers).to include(first_user)
    end

    it "should return true if first user follows second" do
      first_user = create(:user, password: "password")
      second_user = create(:user, password: "password")
      first_user.follow(second_user)
      expect(first_user.follows?(second_user)).to eq(true)
    end
  end
end
