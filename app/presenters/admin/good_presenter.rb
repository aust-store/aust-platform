class Admin::GoodPresenter < Presenter
  subjects :good
  expose :name, :reference, :description
  expose :created_at
end
