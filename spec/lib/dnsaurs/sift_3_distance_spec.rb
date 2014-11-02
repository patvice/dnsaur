require 'spec_helper'

describe Sift3DistanceModule do
  extend Sift3Distance

  describe "#sift_3_distance" do
    it "returns the different of two strings" do
      s1 = "example"
      s2 = "eample"
      expect(Sift3Distance.sift_3_distance s1, s2).to eq 1
    end
    it "returns zero when both arguments is nil or empty" do
      s1 = nil
      s2 = ""
      expect(Sift3Distance.sift_3_distance s1, s2).to eq 0
    end
    it "returns the length of the first string if the second sring is nil or empty" do
      s1 = "example"
      s2 = nil
      expect(Sift3Distance.sift_3_distance s1, s2).to eq s1.length
    end
    it "returns the length of the second string if the first string is nil or empty" do
      s1 = nil
      s2 = "example"
      expect(Sift3Distance.sift_3_distance s1, s2).to eq s2.length
    end
  end
end
