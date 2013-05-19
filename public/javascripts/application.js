



function setCurrentEvent(obj){
  var row = $(obj).closest('tr');
  var num = row.attr("data-id");
  $("input.event_id").val(num);
  if(typeof num === "undefined"){
  	//i.e. clicked "Add to Script!" instead of a row change
  } else {
   	var order = row.attr("data-order-id");
    $("input.event_order").val(order);
     $("tr").removeClass('selected');
    $("tr#row"+num).addClass('selected');
  }
}
function showOverlay(name){
	console.log('in overlay')
  $(".glassbox").hide();
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
	$(".glassbox .controls").hide();
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
	//edit bg images
	$(".scene-editor .edit-bg-image").click(function(){ //dropdown
		var row = $(this).closest('tr');
		var event_id = row.attr("data-id");
		setCurrentEvent(event_id);
		showOverlay(".bg-image");
		
		$(".overlay-topper span").text("Choose a Background Image...");
	});
	//edit poses
	$(".scene-editor .edit-pose").click(function(){
		console.log('in pose')
		 setCurrentEvent(this);
		 var name = $(this).attr("data-name");
		 console.log(name)
		 showOverlay(".poses-for-"+name);
		 $(".overlay-topper span").text("Choose a Pose...");
	});
	$(".scene-editor .edit-speak").click(function(){
		 
		 setCurrentEvent(this);
		 var name = $(this).attr("data-name");
		 var character_id = $(this).attr("data-character-id");
		 var event_type = $(this).attr("data-type");
		 $(".glassbox input.character_id").val(character_id);
		 $(".glassbox input.event_type").val(event_type);
		 $(".glassbox").show();
		 $(".glassbox .data").hide();
		 $(".glassbox .controls").show();
	});
	//row jumping
	$(".jump-to").click(function(){
		top.location.href = $(this).attr("data-url")
	});
	 $(".glassbox textarea").keyup(function(e, obj) {
	 	while(this.scrollHeight > this.clientHeight){
	 		var str = $(this).val();
	 		$(this).val( str.substring(0, str.length-1) );
	 	}
    });
	 $(".add-more-text").click(function(){
	 	
	 });
	//END SCENE EDITOR

	//always put all content in the middle
	popups.center($(".jumbotron"));

});