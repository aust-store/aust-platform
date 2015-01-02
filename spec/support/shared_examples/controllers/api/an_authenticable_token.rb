shared_context "an authenticable token" do
  after do
    controller.stub(:doorkeeper_token) { nil }
    xhr request.request_method_symbol, request.params["action"], request.filtered_parameters
    response.status.should == 401
    response.body.strip.should == ""
  end
end
