shared_context "an authenticable token" do
  after do
    request.headers['Authorization'] = nil
    xhr request.request_method_symbol, request.params["action"], request.filtered_parameters
    response.status.should == 401
    response.body.strip.should == "HTTP Token: Access denied."
  end
end
