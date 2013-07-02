module SelectsHelper
  def select_for_companies
    Company.all.map { |c| [c.name, c.id] }
  end
end
