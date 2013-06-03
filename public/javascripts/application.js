
function resizeTextArea(container, div) {
	aspectRatio = 800/600;
	if ( (container.width() / container.height()) < aspectRatio ) {
		//taller
	    div.css("width","85%").css("left","7%");
	    var width = $(".textarea").width();
	    div.css("height","21%").css("top","74%");
	    div.css("font-size",(width/30)+"px").css("line-height",(width/20)+"px");
	    $(".container-narrow").css("font-size",(width/50)+"px").css("line-height",(width/30)+"px");
	} else {
		//wider
	    div.css("height","21%").css("top","74%");
	    var height = $(".textarea").position().top;
	    div.css("width",(height*1.5)+"px").css("left",(height/7)+"px");
	    div.css("font-size",(height/20)+"px").css("line-height",(height/10)+"px");
	    $(".container-narrow").css("font-size",(height/30)+"px").css("line-height",(height/20)+"px");
	}
				
}
function resizeThumbnail(container, div) {
		//resize thumbnails on demand so they always look good
		var div = $("li .textarea");
		if(div.length != 0){ 
		    var width = div.position().left
		    div.css("height",(width*2)+"px").css("top",(width*7)+"px");
		    div.css("font-size",(width/3.8)+"px");
		    div = $("li .speaker");
		    div.css("top",(width*5.9)+"px");
		    div.css("font-size",(width/3.8)+"px");
	    }
	    $("li .characters").css("width",$("img.bg").width()+"px"); //manual adjust to make them look right
	    var character2 = $("li .character2");
	    if(character2.length != 0){
	    	var width = character2.width()/2;
	    	var height = character2.height();
	    	console.log(width)
	    	console.log(height)
	    	character2.css("margin-left",width+"px");
	    	character2.css("clip","rect(0 "+width+"px "+height+"px 0px)");
	    }


				
} 
function resizeSpeaker(container, div) {
	aspectRatio = 800/600;
	if ( (container.width() / container.height()) < aspectRatio ) {
		//taller
	    div.css("width","50%").css("left","7%");
	    div.css("height","5%").css("top","68.5%");
	    div.css("font-size","20px");
	} else {
		//wider
	    div.css("height","5%").css("top","68.5%");
	    var height = $(".textarea").position().top;
	    div.css("width",(height*1.5)+"px").css("left",(height/7)+"px").css("font-size",(height/20)+"px");
	}
				
}

function resizeHome() {
	resizeTextArea($(window), $(".textarea"));
	resizeSpeaker($(window), $(".speaker"));	
	var container = $(window);
    var div = $(".container-narrow");
    var aspectRatio = 800/600;
	if ( (container.width() / container.height()) < aspectRatio ) {
		//taller
	    // div.css("width","85%").css("left","7%");
	    // var width = $(".textarea").width();
	    // div.css("height","21%").css("top","74%");
	    // div.css("font-size",(width/25)+"px").css("line-height",(width/20)+"px");
	} else {
		//wider
	    //div.css("height","30%").css("top","5%");
	    var spec = container.height()/container.width();
	    //div.css("height",(spec)*400+"px")
	    //div.css("top",spec*15+"px");
 		var spec = container.width()/container.height();
	    //var height = div.height();
	    //.css("width",(spec)*150+"px")//
	    //div.css("font-size",(spec*15)+"px")//.css("line-height",(height/10)+"px");
	}	
}

function gup(name) { //get URL parameters
    return decodeURI(
        (RegExp(name + '=' + '(.+?)(&|$)').exec(location.search)||[,null])[1]
    );
}

//MODIFIED TICKERTYPE PLUGIN
var tickerCursor, tickerText;
var textIsTyping = false;
var waitingForUser = false;
var paused = false;
var voiceSound;
var anim = "<img src='/images/7-1.gif', style='height:16px'>";
function createTicker(){
	tickerText = $("#textarea").html();
	tickerCursor = 0;
	textIsTyping = true;
	typetext();
}


var isInTag = false;
function typetext() {	
	var thisChar = tickerText.substr(tickerCursor, 1);
	if( thisChar == '<' ){ isInTag = true; }
	if( thisChar == '>' ){ isInTag = false; }
	var charTime = 50;
	$('#textarea').html(lefty + tickerText.substr(0, tickerCursor++));
	if(tickerCursor < tickerText.length+1)
		if( isInTag ){ //skip HTML tags
			typetext();
		}else{
			var curr = tickerText.substr(tickerCursor-2,1);
			if(voiceSound != null){
      		  voiceSound.play();
      	    }
			if ((curr==".")||(curr=="?"||curr=="!")){ charTime = 200;}
      if(!paused){
			  setTimeout("typetext()", charTime);

      }
		}
	else {
		textIsTyping = false;
		waitingForUser = true;
		$("#textarea").html(lefty+tickerText+righty+anim)
		tickerText = "";
	}	
}
//END TICKERTYPE PLUGIN

var currentEvent;
var lefty = ""; var righty = "";

function setupGlassBox(action){
	 if(action['event_type'] == "NarrationEvent"){
	 	$("img.glass").attr("src","/images/glassbox_n.png");
	 } else {
	 	$("img.glass").attr("src","/images/glassbox.png");
	 }
	 if(action['event_type']=="CharacterSpeaksEvent"){
	   lefty="&ldquo;"; righty = "&rdquo;";
	 } else if(action['event_type']=="CharacterThinksEvent"){
	 	lefty="<i class='thought'>("; righty=")</i>";
	 } else {
	 	lefty=""; righty="";
	 }
}

function loadScene(order, anyway){
  if((currentEvent==order)&&(!anyway)){ return; }
  var action = events[order];
  $("img.bg").attr("src",action["characters_present"][0][1]);
  $("img.characters").remove();
  $("div.action-items-holder").removeClass("char-present").addClass("char-missing");
  var tag = '<img class="characters">';
    for(var i=1; i<3; i++){
      var charfile = action['characters_present'][i];
      if(charfile != null){ //skip blanks and nils
          $(tag).attr("src",charfile[1]).addClass("character"+i).insertBefore(".glassbox"); //put their body
          $(tag).attr("src",charfile[2]).addClass("character"+i).insertBefore(".glassbox"); //put their face
          $("div.poses-for-"+charfile[0]).find("input.subfilename").val(charfile[2]); //put their face as default in the form
          $("div.action-items-for-"+charfile[0]).removeClass("char-missing").addClass("char-present"); //refresh action items
      }
    }
    if(["CharacterSpeaksEvent","NarrationEvent","CharacterThinksEvent"].indexOf(action["event_type"])>=0){
    	$(".glassbox").show();
    	$(".glassbox .controls").hide();
    	 $(".glassbox .speaker").text(action['get_character_name']);
    	 setupGlassBox(action);
		 $(".textarea").html(lefty+action['text']+righty);

		 $(".glassbox textarea").val(action['text']);
    } else {
    	$(".glassbox").hide();
    }
    currentEvent = order;
}

function setCurrentEvent(row){
  // var row = $(obj).closest('tr');
  if(row.hasClass('selected')){return;}
   var num = row.attr("data-id");
  $(".script .more").hide();
  //$(".script .dropdown i").removeClass('icon-minus-sign').addClass('icon-pencil');
  row.find('.more').show();
  $("input.event_id").val(num);
  if(typeof num === "undefined"){
  	//i.e. clicked "Add to Script!" instead of a row change
  	$("textarea").val("");
  } else {
   	var order = row.attr("data-order-id");
   	loadScene(order, false);
    $("input.event_order").val(order);
     $("tr").removeClass('selected');
    $("tr#row"+num).addClass('selected');
  }
}
function showOverlay(name){
  $(".glassbox").hide();
  $(".overlay .thumbnails").css("visibility","hidden");
;  $(".overlay").slideUp("slow", function(){
  	setTimeout(
  		function(){
  			$(name).slideDown('slow', function(){
  				$(".overlay .thumbnails").css("visibility","visible");
  			});
  			$(".overlay-topper").show();
  		},500
  	)

  });
  
}
function confirmCharacterRemoval(){
  	  if(confirm("This will DELETE the character from all scenes where they appear. Are you sure?")){
  	  	$(this).closest("form").submit(); return false;
  	  } else {
  	  	top.location = top.location.href;
  	  }
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
	if($("#scene-editor").length > 0){
	}
	$("#scene-editor .overlay-topper a").click(function(){
		$(".overlay").slideUp();
		$(".overlay-topper").fadeOut();
		$("tr.selected").find(".more").show();
		loadScene(currentEvent, true);
		return false;
	});
	//drop down options when pencil is clicked
	$("table.script tr").click(function(){
		if(!$(this).hasClass('selected')){
			setCurrentEvent($(this));
			$(".overlay").hide();
		    $(".overlay-topper").hide();
		}
		//dont return false or buttons wont work;
	});
	$("#scene-editor .dropdown").click(function(){
		row = $(this).closest('tr');
		var icon = $(this).find("i");
		  setCurrentEvent(row);
		return false;
	});
	//edit bg images
	$("#scene-editor .edit-bg-image").click(function(){ //dropdown
	 	setCurrentEvent($(this).closest('tr'));
		showOverlay(".bg-image");
		$(".overlay-topper span").text("Choose a Background Image...");
		return false;
	});
	$("#scene-editor .edit-music").click(function(){ //dropdown
		setCurrentEvent($(this).closest('tr'));
		showOverlay(".music");
		$(".overlay-topper span").text("Choose Background Music...");
		return false;
	});
	//edit poses
	$("#scene-editor .edit-clothes").click(function(){
		 setCurrentEvent($(this).closest('tr'));
		 var id = $(this).attr("data-character-id");
		 showOverlay(".poses-for-"+id);
		 $(".overlay-topper span").text("Choose Clothes...");
		 return false;
	});
	$("#scene-editor .edit-pose").click(function(){
		 setCurrentEvent($(this).closest('tr'));
		 var id = $(this).attr("data-character-id");
		 showOverlay(".poses-for-"+id);
		 $(".overlay-topper span").text("Choose A Pose...");
		 return false;
	});
	//edit faces
	$("#scene-editor .edit-face").click(function(){
		 setCurrentEvent($(this).closest('tr'));
		 var id = $(this).attr("data-character-id");
		 console.log(id);
		 showOverlay(".faces-for-"+id);
		 $("input.character_id").val(id);
		 $(".overlay-topper span").text("Choose a Face...");
		 return false;
	});

	 $("#scene-editor .edit-speak").click(function(){
	// 	 //select current row
	 	 setCurrentEvent($(this).closest('tr'));
	// 	 //get the speaker's name
		 var name = $(this).attr("data-name");
		 $(".glassbox .speaker").text(name);
		 if(name == ""){
		 	$(".glass").attr("src","/images/glassbox_n.png");
		 } else {
		 	$(".glass").attr("src","/images/glassbox.png");
		 }
	// 	 //transfer character id, event type, and dialogue to the glass box form
	 	 var character_id = $(this).attr("data-character-id");
	 	 var event_type = $(this).attr("data-type");
	 	 var text = $(this).closest("tr").find(".event_text").val();
	 	 $(".glassbox input.character_id").val(character_id);
	 	 $(".glassbox input.event_type").val(event_type);
	 	 $(".overlay").add(".overlay-topper").hide();
	// 	 //hide the glassbox dialogue and show the editor
	 	 $(".glassbox").css("display","block");
	 	 $(".glassbox .textarea").hide();
	 	 $(".glassbox .controls").css("display","inline-block");
	 	 $(".glassbox textarea").show().focus();
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
	 	if(confirm('Are you sure? This will delete everything. This cannot be undone.')){
	 	  $(this).closest('form').submit(); 
	 	}
	 	return false;
	 });
	//END SCENE EDITOR


    //sharing
	$("a.share-link").click(function(){
		$(this).closest("li").find("p.share").slideToggle('slow');
	});
	// $("p.share .share-link").live('focus', function () {
 //            $(this).select();
 //     });
	//drag sorting
	$(function() {
		$( "#sortable" ).sortable({
			update: function( event, ui ) {
			  li = ui.item;
			  for(var i=0; i<$("#sortable li").length; i++){
			  	if($($("#sortable li")[i]).attr("data-id")==li.attr("data-id")){
			  	  $.post(li.attr("data-url"), {order_index:i}, function(data) {
					});
			  	}
			  }
			}
		});
		$( "#sortable" ).disableSelection();
	});
	//resize homepage trigger 			  
	if($("body.homepage").length > 0){                  			
	  $(window).resize(resizeHome).trigger("resize");
	  createTicker();
    }
    if($("li .tiny-viewer").length > 0){
      setTimeout(
    	function(){
         $(window).resize(resizeThumbnail).trigger("resize");
   		},250);
      }

});