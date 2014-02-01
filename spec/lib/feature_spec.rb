require "feature"

describe Feature do
  subject { described_class }

  before do
    stub_const("Rails", Class.new)
  end

  describe "#alpha" do
    context "production" do
      before do
        Rails.stub_chain(:env, :production?) { true }
      end

      it "doesn't yield a block" do
        mock = nil
        subject.alpha do
          mock = 1
        end
        mock.should be_nil
      end

      it "yields a block for a given company" do
        mock = nil
        subject.alpha(handle: "acpresentes", allow_company: ["acpresentes"]) do
          mock = 1
        end
        mock.should == 1
      end
    end

    context "not production" do
      before do
        Rails.stub_chain(:env, :production?) { false }
      end

      it "years a block if it's not Rails production" do
        mock = nil
        subject.alpha do
          mock = 1
        end
        mock.should == 1
      end
    end
  end
end
