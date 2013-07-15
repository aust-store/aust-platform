module CapybaraHelpers
  module ContentHelpers
    def translation(path)
      I18n.t(path)
    end
  end
end
