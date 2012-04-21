require "spec_helper"

describe Admin::GoodDecorator do
  def attributes
    { created_at: Time.new(2012, 04, 14, 14, 14, 14) }
  end

  before do
    @good = stub attributes
    @presenter = Admin::GoodDecorator.new @good
  end
end
