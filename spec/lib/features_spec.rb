require "spec_helper"

describe Feature do
  let(:feature) { double }

  describe ".alpha" do
    after do
      described_class.alpha { feature.run }
    end

    it "runs when not in production" do
      Rails.env.stub(:production?) { false }
      feature.should_receive(:run)
    end

    it "doesn't run when in production" do
      Rails.env.stub(:production?) { true }
      feature.should_not_receive(:run)
    end
  end

  describe ".pre_alpha" do
    after do
      described_class.pre_alpha { feature.run }
    end

    it "runs in anything except production and staging" do
      Rails.env.stub(:production?) { false }
      feature.should_receive(:run)
    end

    it "doesn't run in production" do
      Rails.env.stub(:production?) { true }
      feature.should_not_receive(:run)
    end

    it "doesn't run in staging" do
      Rails.env.stub(:production?) { false }
      Rails.env.stub(:staging?)    { true }
      feature.should_not_receive(:run)
    end
  end
end
