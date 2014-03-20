require "spec_helper"

describe CustomField do
  describe "validations" do
    describe "#name" do
      it "doesn't allow duplicated names" do
        field1 = create(:custom_field, name: "Field Whatever")
        field1.should be_valid
        field2 = build(:custom_field, name: "Field Whatever")
        field2.should_not be_valid
      end
    end

    describe "field_type" do
      it "allows string, radio etc" do
        build(:custom_field, field_type: "string").should be_valid
        build(:custom_field, field_type: "radio").should be_valid
      end

      it "doesn't allow anything else" do
        build(:custom_field, field_type: "hahah").should_not be_valid
      end
    end
  end

  describe "callbacks" do
    describe "create_alphanumeric_name on before_save" do
      let(:field) { create(:custom_field, name: "Field Whatever") }

      it "generates an alphanumeric name" do
        field.alphanumeric_name.should == "field_whatever"
      end

      it "doesn't generate an existing alphanumeric name" do
        field.update_attributes(name: "another name")
        field2 = create(:custom_field, name: "Field Whatever Transação")

        field.alphanumeric_name.should == "field_whatever"
        field2.alphanumeric_name.should == "field_whatever_transacao"
        field2.update_attributes(name: "yet another name")
        field3 = create(:custom_field, name: "Field Whatever")
        field3.alphanumeric_name.should == "field_whatever_2"
      end
    end
  end

  describe "#string?" do
    it "return true for string" do
      subject = build(:custom_field, field_type: "string")
      expect(subject).to be_string
    end

    it "return false for anything else" do
      subject = build(:custom_field, field_type: "radio")
      expect(subject).to_not be_string
    end
  end

  describe "#radio?" do
    it "return true for radio" do
      subject = build(:custom_field, field_type: "radio")
      expect(subject).to be_radio
    end

    it "return false for anything else" do
      subject = build(:custom_field, field_type: "string")
      expect(subject).to_not be_radio
    end
  end

  describe "#radio_values" do
    it "returns all values" do
      subject = build(:custom_field,
                      field_type: "radio",
                      options: {"values" => ["Compra", "Venda", ""]})
      expect(subject.radio_values).to eq(["Compra", "Venda"])
    end

    it "returns all values when they're string" do
      subject = build(:custom_field,
                      field_type: "radio",
                      options: {"values" => "[\"Compra\", \"Venda\", \"\"]"})
      expect(subject.radio_values).to eq(["Compra", "Venda"])
    end
  end
end
