
function gup(name) { //get URL parameters
    return decodeURI(
        (RegExp(name + '=' + '(.+?)(&|$)').exec(location.search)||[,null])[1]
    );
}


function setCurrentEvent(obj){
  var row = $(obj).closest('tr');
  var num = row.attr("data-id");
  console.log('num',num)
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
function confirmCharacterRemoval(){
  	  return confirm("This will DELETE the character from all scenes where they appear. Are you sure?");
}
$(document).ready(function() {
	//enable tooltips on links
	$("a").tooltip({animation:false});
	$(".tippable").tooltip({animation:false});
	$(".confirmable").click(function(){
		return confirm("Are you sure?");
	});


   // $(".overlay a").addClass("submitable");
	$(".submitable").click(function(){ $(this).closest("form").submit(); return false; });
	$(".hide").hide();


	//SCENE EDITOR
	$(".overlay").hide();
	$(".scene-editor .overlay-topper a").click(function(){
		$(".overlay").slideUp();
		$(".overlay-topper").fadeOut();
		return false;
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
		return false;
	});
	//edit bg images
	$(".scene-editor .edit-bg-image").click(function(){ //dropdown
		setCurrentEvent(this);
		showOverlay(".bg-image");
		$(".overlay-topper span").text("Choose a Background Image...");
		return false;
	});
	$(".scene-editor .edit-music").click(function(){ //dropdown
		setCurrentEvent(this);
		showOverlay(".music");
		$(".overlay-topper span").text("Choose Background Music...");
		return false;
	});
	//edit poses
	$(".scene-editor .edit-pose").click(function(){
		 setCurrentEvent(this);
		 var id = $(this).attr("data-character-id");
		 showOverlay(".poses-for-"+id);
		 $(".overlay-topper span").text("Choose a Pose...");
		 return false;
	});
	//edit love poses
	$(".scene-editor .edit-love-pose").click(function(){
		 setCurrentEvent(this);
		 var id = $(this).attr("data-character-id");
		 showOverlay("div.love-poses");
		 $(".overlay-topper span").text("Choose a Pose...");
		 return false;
	});
	$(".scene-editor .edit-speak").click(function(){
		 //select current row
		 setCurrentEvent(this);
		 //get the speaker's name
		 var name = $(this).attr("data-name");
		 $(".glassbox .speaker").text(name);
		 if(name == ""){
		 	$(".glass").attr("src","/images/glassbox_n.png");
		 } else {
		 	$(".glass").attr("src","/images/glassbox.png");
		 }
		 //transfer character id, event type, and dialogue to the glass box form
		 var character_id = $(this).attr("data-character-id");
		 var event_type = $(this).attr("data-type");
		 var text = $(this).closest("tr").find(".event_text").val();
		 $(".glassbox input.character_id").val(character_id);
		 $(".glassbox input.event_type").val(event_type);
		 $(".overlay").add(".overlay-topper").hide();
		 //hide the glassbox dialogue and show the editor
		 $(".glassbox").css("display","block");
		 $(".glassbox .textarea").hide();
		 $(".glassbox .controls").css("display","inline-block");
		 $(".glassbox textarea").show().val(text).focus();
		 return false;
	});
	//row jumping
	$(".jump-to").click(function(){
		top.location.href = $(this).attr("data-url");
		return false;
	});
	 $(".glassbox textarea").keyup(function(e, obj) {
	 	while(this.scrollHeight > this.clientHeight){
	 		var str = $(this).val();
	 		$(this).val( str.substring(0, str.length-1) );
	 	}
    });
	 $(".add-more-text").click(function(){ //setup continuous text entry
	 	$("input.more_text").val($(".glassbox input.character_id").val());
	 	$("input.more_text_type").val($(".glassbox input.event_type").val());
	 	$(this).closest("form").submit();
	 	return false;
	 });
	 if(gup("more_text") != "null"){ //continue text entry
	 	$(".action-items a[data-character-id="+gup("more_text")+"][data-type="+gup("more_text_type")+"]").click();
	 }
	 if((gup("event_index") != "null")&&(gup("event_index") != "")){ //scroll current event into view
	 	try{ //will fail if event was deleted
	 	  $("tr[data-order-id="+gup("event_index")+"]").get(0).scrollIntoView();
	    } catch(err){}
	 }
	 $(".change-name").click(function(){
	 	form = $(this).closest('form');
	 	var nameable = form.find('.nameable');
	 	var name=prompt("What will you change it to?",nameable.val());
        if (name!=null) { 
        	nameable.val(name);
        	form.submit(); 
        }
        return false;
	 });
	 $(".delete-scene").click(function(){
	 	if(confirm('Are you sure? This will delete everything.')){
	 	  $(this).closest('form').submit(); 
	 	}
	 	return false;
	 });
	//END SCENE EDITOR

	//always put all content in the middle
	//popups.center($(".jumbotron"));

});