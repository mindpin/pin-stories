pie.load ->
  # 新增 用例 issue
  jQuery('.page-milestone-report-show .usecases .usecase a.new-issue').live 'click', ->
    jQuery(this).next('.new-issue-form').show();

  # 关闭表单
  jQuery('.page-milestone-report-show .usecases .usecase .new-issue-form a.cancel').live 'click', ->
    jQuery(this).closest('.new-issue-form').hide();


  jQuery('.page-milestone-report-show .issue a.edit-issue').live 'click', ->
    jQuery(this).closest('.issue').find('.form').show();

  jQuery('.page-milestone-report-show .issue .form a.cancel').live 'click', ->
    jQuery(this).closest('.form').hide();


  jQuery(document).delegate '.page-milestone-report-show .state .toggle-st', 'click', ->
    state = jQuery(this).data('state')
    id = jQuery(this).closest('.issue').data('id')
    $state = jQuery(this).closest('.state')

    jQuery.ajax
      url: "/milestone_issues/#{id}/change_state"
      type: 'put'
      data: {'state' : state}
      success: (res)->
        $state.after(res).remove()