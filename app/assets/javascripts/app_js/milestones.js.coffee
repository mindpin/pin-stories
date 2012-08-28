pie.load ->
  # 新增 用例 issue
  jQuery('.page-milestone-report-show .usecases .usecase a.new-issue').live 'click', ->
    jQuery(this).next('.new-issue-form').show();

  # 关闭表单
  jQuery('.page-milestone-report-show .usecases .usecase .new-issue-form a.cancel').live 'click', ->
    jQuery(this).closest('.new-issue-form').hide();


  jQuery('.page-milestone-report-show .usecases .usecase .issues a.edit-issue').live 'click', ->
    jQuery(this).parent().find('.edit-issue-form').show();

  jQuery('.page-milestone-report-show .usecases .usecase .edit-issue-form a.cancel').live 'click', ->
    jQuery(this).closest('.edit-issue-form').hide();