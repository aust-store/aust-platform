module RouterConstraints
  class Iphone
    def matches?(request)
      user_agent = request.env["HTTP_USER_AGENT"]
      user_agent.try(:match, /iphone[ OS]{0,}[.]{0,1}[6-999]/i)
    end
  end

  class Default
    def matches?(request)
      !Iphone.new.matches?(request)
    end
  end
end
