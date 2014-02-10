require 'spec_helper'

describe PosCashEntry do
  describe "validations" do
    let(:company) { create(:barebone_company) }
    let(:cash_entry) { create(:cash_entry, company: company, amount: 100) }

    context "entry_type" do
      it { should allow_value("addition").for(:entry_type)  }
      it { should allow_value("subtraction").for(:entry_type)  }
      it { should allow_value("missing").for(:entry_type)  }
      it { should allow_value("surplus").for(:entry_type)  }
      it { should_not allow_value("credit").for(:entry_type)  }
    end

    describe "#validate_cash_is_updatable" do
      before do
        Timecop.travel(Time.utc(2013, 8, 9, 10, 10, 10)) do
          cash_entry
          cash_entry.update_attributes(amount: 123)
          cash_entry.amount.should == 123.0
        end
      end

      it "shouldn't update a record if an order exists after it" do
        Timecop.travel(Time.utc(2013, 8, 9, 10, 11, 10)) do
          create(:offline_order, store: company)
          cash_entry.update_attributes(amount: 145)
        end

        cash_entry.reload.amount.should == 123
      end

      it "shouldn't update a record if a newer cash entry exists" do
        Timecop.travel(Time.utc(2013, 8, 9, 10, 11, 10)) do
          create(:cash_entry, company: company)
          cash_entry.update_attributes(amount: 145)
        end

        cash_entry.reload.amount.should == 123
      end
    end
  end
end
