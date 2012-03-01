require 'spec_helper'

feature "Solr search", search: true do
  scenario "searches a good by name" do
    good = Factory(:good, :name => "Of Mice and Men")
    Good.search { fulltext "Mice" }.results.should == [good]
  end
end