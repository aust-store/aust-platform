require "decorators/admin/good_decorator"

shared_examples_for "admin good decorator contract" do
  subject { Admin::GoodDecorator }

  it "decorates good" do
    expect do
      subject.decorated_collection.should include [
        :good
      ]
    end.to_not raise_error
  end
end
