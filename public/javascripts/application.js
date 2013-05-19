
var currentOverlay = "";
function setCurrentEvent(num){
  
  $("input.event_id").val(num);
  $("tr").removeClass('selected');
  $("tr#row"+num).addClass('selected');
}
function showOverlay(name){
  $(".overlay").slideUp("slow", function(){
  	setTimeout(
  		function(){
  			$(name).slideDown();
  			$(".overlay-topper").show();
  		},500
  	)

  });
  
}
$(document).ready(function() {
	//enable tooltips on links
	$("a").tooltip();
	$(".tippable").tooltip();
	$(".confirmable").click(function(){
		return confirm("Are you sure?");
	});

	//scene index: enable starter location clicking
	//TODO: Can probably use less code here
	$(".scene-index table.event-packs").click(function(){
	  $(this).find("input.radio").attr('checked', 'checked');
	  $(this).closest("form").submit();
	});
	$(".scene-index table.scenes").click(function(){
	   top.location.href = $(this).find("a").attr("href");
	});

    $(".overlay a").addClass("submitable");
	$(".submitable").click(function(){ $(this).closest("form").submit(); });

	//SCENE EDITOR
	$(".scene-editor .script .more").hide();
	$(".overlay").hide();
	$(".overlay-topper").hide();
	$(".scene-editor .overlay-topper a").click(function(){
		$(".overlay").slideUp();
		$(".overlay-topper").fadeOut();
	});
	//drop down options when pencil is clicked
	$(".scene-editor #dropdown").click(function(){
		$(this).closest('tr').find('.more').slideToggle();
		var icon = $(this).find("i");
		if(icon.hasClass('icon-pencil')){
		  icon.removeClass('icon-pencil').addClass('icon-minus-sign');
		} else {
		  icon.removeClass('icon-minus-sign').addClass('icon-pencil');
		}
	});
	//change bg image menu
	$(".scene-editor .edit-bg-image").click(function(){ //dropdown
		var row = $(this).closest('tr');
		var event_id = row.attr("data-id");
		setCurrentEvent(event_id);
		showOverlay(".bg-image");
		
		$(".overlay-topper span").text("Choose a Background Image...");
	});
	$(".scene-editor .edit-pose").click(function(){
		 var row = $(this).closest('tr');
		 var event_id = row.attr("data-id");
		 setCurrentEvent(event_id);
		 var name = $(this).attr("data-name");
		 showOverlay(".poses-for-"+name);
		 $(".overlay-topper span").text("Choose a Pose...");
	});
	//row jumping
	$(".jump-to").click(function(){
		top.location.href = $(this).attr("data-url")
	});
	//END SCENE EDITOR

	//always put all content in the middle
	popups.center($(".jumbotron"));

});