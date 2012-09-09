module Store
  class CustomerCreation
    def self.create(data, company_id, persistence_class = Customer)
      customer = persistence_class.new(data)
      customer.company_id = company_id
      customer
    end
  end
end
