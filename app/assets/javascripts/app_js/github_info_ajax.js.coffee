pie.load ->
  $github_page = jQuery('.page-github')
  $load = jQuery('.page-github .load')
  return if !$github_page.exists()
  return if !$load.exists()

  last_sha = $github_page.data('last_sha')
  github_project_id = $github_page.data('github_project_id')

  jQuery.ajax
    type: 'GET'
    url: "/github_projects/#{github_project_id}/aj_show"
    data:
      last_sha : last_sha
    success: (res)->
      $new = jQuery(res)
      $github_page.before($new).remove()      
