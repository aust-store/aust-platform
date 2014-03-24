require "spec_helper"

describe Store::Reports::Inventory do
  let(:company) { create(:barebone_company) }
  let(:item1) { create(:inventory_item, company: company, point_of_sale: false) }
  let(:item2) { create(:inventory_item, company: company, website_sale: false) }

  let(:company2) { create(:barebone_company) }
  let(:item3)    { create(:inventory_item, company: company2) }

  subject { described_class.new(company) }

  before do
    item1
    item2.entries.last.update_attributes(website_sale: true)
    item2.entries.last.update_attributes(point_of_sale: false)

    item1.price.should == 12.34
    item1.prices << create(:inventory_item_price, value: "12.37")
    item1.reload.price.should == 12.37
  end

  specify "the test is correct" do
    item1.entries.count.should == 3
    item1.entries.each { |e| e.quantity.should == 8 }
  end

  describe "#summary" do
    it "returns a hash with all values" do
      item1_revenue = item1.price * item1.total_quantity
      item2_revenue = item2.price * item2.total_quantity

      subject.summary.should == {
        total_inventory_items: 2,
        total_entries: 48,
        total_entries_on_sale_at_website: 32,
        total_entries_on_sale_at_pos: 16,
        stock_value: Money.new(9.11) * 48, # 48 (entries) * 9.11 (cost)
        stock_estimated_revenue: item1_revenue + item2_revenue
      }
    end
  end
end
