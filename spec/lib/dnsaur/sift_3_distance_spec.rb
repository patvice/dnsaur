require 'spec_helper'

describe Sift3Distance do
  class DummySift3Distance
  end

  before(:each) do
    @sift_3_distance = DummySift3Distance.new
    @sift_3_distance.extend(Sift3Distance)
  end

  describe "#sift_3_distance" do
    it "returns the different of two strings" do
      s1 = "example"
      s2 = "eample"
      expect(@sift_3_distance.sift_3_distance s1, s2).to eq 1
    end
    it "returns zero when both arguments is nil or empty" do
      s1 = nil
      s2 = ""
      expect(@sift_3_distance.sift_3_distance s1, s2).to eq 0
    end
    it "returns the length of the first string if the second sring is nil or empty" do
      s1 = "example"
      s2 = nil
      expect(@sift_3_distance.sift_3_distance s1, s2).to eq s1.length
    end
    it "returns the length of the second string if the first string is nil or empty" do
      s1 = nil
      s2 = "example"
      expect(@sift_3_distance.sift_3_distance s1, s2).to eq s2.length
    end
  end
end
