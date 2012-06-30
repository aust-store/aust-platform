class DecorationBuilder
  def self.good(good)
    Admin::GoodDecorator.decorate(good)
  end
end
