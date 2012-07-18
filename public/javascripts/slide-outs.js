
var hook = "#hook";
var needles = "#needles";

var cos54 = 0.5878;
var sin54 = 0.8090;

var center = 0;


$(document).ready(function(){
 
  $(window).resize(function() { update_center(); handle_scroll(); } ); update_center();
  $(document).scroll(handle_scroll); handle_scroll();

});

function update_center()
{
  center = $(window).width() / 2.0;
}

function handle_scroll(e)
{
  var scroll = $(document).scrollTop();

  $(hook).css("left", center + scroll * sin54).css("top", scroll * cos54);
  $(needles).css("left", center - scroll * sin54).css("top", scroll * cos54);

}

