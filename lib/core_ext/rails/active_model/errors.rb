module ActiveModel
  class Errors
    # This returns only the first error message for each field
    def first_messages
      messages.each_with_object({}) do |(attribute, messages), memo|
        memo[attribute] = [messages.first]
      end
    end
  end
end
