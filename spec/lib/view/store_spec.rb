require "unit_spec_helper"
require "view/store"

describe View::Store do
  it_should_behave_like "a store view"

  subject { described_class.new(theme) }
end
