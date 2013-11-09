require "view/layout_constraints"

describe View::LayoutConstraints do
  let(:controller) { double(params: params) }

  subject { described_class.new(controller) }

  describe "#show_vertical_taxonomy_menu?" do
    context "when main controller" do
      let(:params) { {controller: "store/home"} }

      it "returns true" do
        expect(subject).to be_show_vertical_taxonomy_menu
      end
    end

    context "when product controller" do
      let(:params) { {controller: "store/product"} }

      it "returns true" do
        expect(subject).to be_show_vertical_taxonomy_menu
      end
    end

    context "when categories controller" do
      let(:params) { {controller: "store/categories"} }

      it "returns true" do
        expect(subject).to be_show_vertical_taxonomy_menu
      end
    end

    context "when another controller that's not allowed" do
      let(:params) { {controller: "some_other_controller"} }

      it "returns true" do
        expect(subject).to_not be_show_vertical_taxonomy_menu
      end
    end
  end
end
