// 给jQuery对象增加 input 的方法，绑定输入事件
jQuery.fn.input = function(fn) {
  var _this = this;
  return fn
  ?
  this.bind({
    'input.input' : function(evt) {
      _this.unbind('keydown.input');
      fn.call(this, evt);
    },
    'keydown.input' : function(evt) {
      fn.call(this, evt);
    }
  })
  :
  _this.trigger('keydown.input');
};

// 定义 placeholder 方法，用来给表单域声明提示信息
// 相应的调用在 ../events/mindpin-form.js.coffee 中

(function(){
  jQuery.fn.placeholder = function() {
    try{
      jQuery(this).each(function(){
        var input_elm = jQuery(this)
          .change(function(){ _active(input_elm) })
          .input(function(){ _active(input_elm) })

        //初始化
        _active(input_elm);
      })
    }catch(e){console.log(e)};
  };

  function _active(input_elm){
    var label_elm = input_elm.parent().find('label');
    var value = input_elm.val();

    value == '' ? label_elm.show() : label_elm.hide();
  }
})();