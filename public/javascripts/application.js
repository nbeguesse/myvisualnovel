
function setCurrentEvent(num){
  $(".overlay").slideUp();
  $("input.event_id").val(num);
  $("tr").removeClass('selected');
  $("tr#row"+num).addClass('selected');
}
$(document).ready(function() {
	//always put all content in the middle
	popups.center($(".jumbotron"));
	//enable tooltips on links
	$("a").tooltip();
	$(".confirmable").click(function(){
		return confirm("Are you sure?");
	});

	//scene index: enable starter location clicking
	$(".scene-index table.event-packs").click(function(){
	  $(this).find("input.radio").attr('checked', 'checked');
	  $(this).closest("form").submit();
	});
	$(".scene-index table.scenes").click(function(){

	   top.location.href = $(this).find("a").attr("href");
	});

	//SCENE EDITOR
	$(".scene-editor .script .more").hide();
	$(".overlay").hide();
	$(".overlay-topper").hide();
	$(".scene-editor .overlay-topper a").click(function(){
		$(".overlay").hide();
		$(".overlay-topper").hide();
	});
	//drop down options when pencil is clicked
	$(".scene-editor #dropdown i").click(function(){
		$(this).closest('tr').find('.more').slideToggle();
		if($(this).hasClass('icon-pencil')){
		  $(this).removeClass('icon-pencil').addClass('icon-minus-sign');
		} else {
		  $(this).removeClass('icon-minus-sign').addClass('icon-pencil');
		}
	});
	//change bg image menu
	$(".scene-editor .edit-bg-image").click(function(){ //dropdown
		var row = $(this).closest('tr');
		var event_id = row.attr("data-id");
		setCurrentEvent(event_id);
		$(".bg-image").slideDown();
		$(".overlay-topper").show();
	});
	$(".bg-image img").click(function(){ //click
		$(this).closest("form").submit();
	});

});