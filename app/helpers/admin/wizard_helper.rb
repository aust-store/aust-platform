module Admin::WizardHelper
  def current_tab(tab)
    raw 'class="current"' if tab == @step.to_sym
  end
end
