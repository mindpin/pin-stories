// MINDPIN PIE lib
// 帮助进行以下工作：
/**

pie.load(function)
帮助进行方法载入，在 jQuery.ready 基础上增加了异常捕获，
以防止由于某一段js载入不正确导致的全局js逻辑崩溃

*/

pie = {};

pie.load = function(func){
  jQuery(function(){
    try{
      func();
    }catch(e){
      console.log('PIE: js 加载错误: ' + e);
    }
  });
};