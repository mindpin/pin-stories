# Tabulous gives you an easy way to set up tabs for your Rails application.
#
#   1. Configure this file.
#   2. Add <%= tabs %> and <%= subtabs %> in your layout(s) wherever you want
#      your tabs to appear.
#   3. Add styles for these tabs in your stylesheets.
#   4. Profit!

Tabulous.setup do |config|

  #----------
  #   TABS
  #----------
  #
  # This is where you define your tabs and subtabs.  The order that the tabs
  # appear in this list is the order they will appear in your views.  Any
  # subtabs defined will have the previous tab as their parent.
  #
  # TAB NAME
  #   must end in _tab or _subtab
  # DISPLAY TEXT
  #   the text the user sees on the tab
  # PATH
  #   the URL that gets sent to the server when the tab is clicked
  # VISIBLE
  #   whether to display the tab
  # ENABLED
  #   whether the tab is disabled (unclickable)

  config.tabs do
    [
      [ :users_tab, '用户', user_path(@user), true, true ],
      [ :stories_users_subtab, '被分配的Story', user_path(@user), true, true ],
      [ :issues_users_subtab, '创建的Issue', user_issues_path(@user), true, true ],
      [ :assigned_issues_users_subtab, '被分配的Issue', assigned_user_issues_path(@user), true, true ],
      [ :ideas_users_subtab, '想法', user_ideas_path(@user), true, true]
    ]
  end

  #-------------
  #   ACTIONS
  #-------------
  #
  # This is where you hook up actions with tabs.  That way tabulous knows
  # which tab and subtab to mark active when an action is rendered.
  #
  # CONTROLLER
  #   the name of the controller
  # ACTION
  #   the name of the action, or :all_actions
  # TAB
  #   the name of the tab or subtab that is active when this action is rendered

  config.actions do
    [
      [ :users, :all_actions, :users_tab ],
      [ :users, :show, :stories_users_subtab ]
    ]
  end

  #---------------------
  #   GENERAL OPTIONS
  #---------------------

  config.active_tab_clickable = true
  config.always_render_subtabs = false
  config.when_action_has_no_tab = :raise_error      # the default behavior
  config.html5 = false
  config.css.scaffolding = false
  config.tabs_ul_class = 'page-nav-tabs'
  config.subtabs_ul_class = 'page-nav-subtabs'
end
