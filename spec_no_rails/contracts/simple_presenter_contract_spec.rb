describe Presenter do
  it "should have an initializer with one argument" do
    Presenter.new(double).should_not be_nil
  end
end
