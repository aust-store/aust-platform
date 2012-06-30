module Store
  class CustomerCreation
    def self.create(data, company, persistence_class = Customer)
      customer = persistence_class.new(data)
      customer.company = company
      customer.save
    end
  end
end
