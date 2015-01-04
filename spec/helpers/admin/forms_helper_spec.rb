require "spec_helper"

describe Admin::FormsHelper do
  describe ".taggable_input" do
    let(:model)    { double(all_tags: all_tags) }
    let(:tag1)     { double(name: "yes") }
    let(:tag2)     { double(name: "no") }
    let(:all_tags) { [tag1, tag2] }
    let(:form)     { double(object: double(tag_list: ["yes", "no"])) }

    it "returns input field with correct name" do
      form
        .should_receive(:input)
        .with(
          :taggable_field, {
          as: :string,
          required: false,
          input_html: {
            value: "yes, no",
            class: "js_taggable",
            data: {
              data: [
                {"value" => "yes", "text" => "yes"},
                {"value" => "no", "text" => "no"}
              ].to_json
            }
          }
        })
      helper.taggable_input(:taggable_field, form, model)
    end
  end
end
