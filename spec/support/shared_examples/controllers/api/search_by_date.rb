shared_examples_for "an api endpoint with date search" do |root_name, factory_name|
  describe "search today's resources" do
    before do
      # TODO fix this crap
      company_key = (build(factory_name).respond_to?(:company)) ? :company : :store

      Timecop.travel(2.days.ago) do
        @resource1 = create(factory_name, company_key => @company)
      end
      @resource2 = create(factory_name, company_key => @company)
    end

    it "returns only what was created today" do
      xhr :get, :index, created_at: "today"

      json = ActiveSupport::JSON.decode(response.body)
      json[root_name.to_s].all? do |resource|
        DateTime.parse(resource["created_at"]).day == Time.zone.now.day
      end.should be_true
    end
  end
end
