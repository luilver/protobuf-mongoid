require "spec_helper"

describe Protobuf::Mongoid::Persistence do
  let(:user) { User.new(user_attributes) }
  let(:user_attributes) { { :first_name => "foo", :last_name => "bar", :email => "foo@test.co" } }
  let(:proto_hash) { { :name => "foo bar", :email => "foo@test.co" } }
  let(:proto) { UserMessage.new(proto_hash) }

  describe ".create" do
    it "accepts a protobuf message and creates a valid user" do
      user = User.create(proto)
      expect(user).to be_persisted
      expect(user).to be_valid
      expect(user.first_name).to eq("foo")
      expect(user.last_name).to eq("bar")
      expect(user.email).to eq("foo@test.co")
    end

    it "accepts a hash and creates a valid user" do
      user = User.create(user_attributes)
      expect(user).to be_persisted
      expect(user).to be_valid
      expect(user.first_name).to eq("foo")
      expect(user.last_name).to eq("bar")
      expect(user.email).to eq("foo@test.co")
    end
  end

  describe ".create!" do
    it "accepts a protobuf message and creates a valid user" do
      user = User.create!(proto)
      expect(user).to be_persisted
      expect(user).to be_valid
      expect(user.first_name).to eq("foo")
      expect(user.last_name).to eq("bar")
      expect(user.email).to eq("foo@test.co")
    end

    it "accepts a hash and creates a valid user" do
      user = User.create!(user_attributes)
      expect(user).to be_persisted
      expect(user).to be_valid
      expect(user.first_name).to eq("foo")
      expect(user.last_name).to eq("bar")
      expect(user.email).to eq("foo@test.co")
    end
  end

  describe "#assign_attributes" do
    let(:user) { ::User.new }

    it "accepts a protobuf message" do
      user.assign_attributes(proto)
      expect(user.changed?).to be true
    end

    it "accepts a hash" do
      user.assign_attributes(user_attributes)
      expect(user.changed?).to be true
    end
  end

  describe "#update" do
    it "accepts a protobuf message" do
      expect_any_instance_of(User).to receive(:save)
      user.update(proto)
    end

    it "accepts a hash" do
      expect_any_instance_of(User).to receive(:save)
      user.update(user_attributes)
    end
  end

  describe "#update!" do
    it "accepts a protobuf message and updates the user" do
      user = User.create!(user_attributes)
      user.update!(proto)
      expect(user.first_name).to eq("foo")
      expect(user.last_name).to eq("bar")
      expect(user.email).to eq("foo@test.co")
    end

    it "accepts a hash and updates the user" do
      user = User.create!(user_attributes)
      user.update!(first_name: "new_foo", last_name: "new_bar")
      expect(user.first_name).to eq("new_foo")
      expect(user.last_name).to eq("new_bar")
    end
  end
end
