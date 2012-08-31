module UserAssignHelper
  def juser_assigns(model)
    render 'aj/user_assigns', :model => model
  end
end