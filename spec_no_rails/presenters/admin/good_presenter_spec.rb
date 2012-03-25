require "./spec_no_rails/spec_helper"
require "./app/presenters/admin/good_presenter"

describe Admin::GoodPresenter do
  def attributes
    { created_at: Time.new(2012, 04, 14, 14, 14, 14) }
  end

  before do
    @good = stub attributes
    @presenter = Admin::GoodPresenter.new @good
  end
end
