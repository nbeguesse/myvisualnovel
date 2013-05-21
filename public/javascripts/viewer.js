var lefty = ""; var righty = "";

//MODIFIED TICKERTYPE PLUGIN
var tickerCursor, tickerText;
function createTicker(){
	tickerText = $(".textarea").html();
	tickerCursor = 0;
	textIsTyping = true;
	typetext();
}


var isInTag = false;
function typetext() {	
	var thisChar = tickerText.substr(tickerCursor, 1);
	if( thisChar == '<' ){ isInTag = true; }
	if( thisChar == '>' ){ isInTag = false; }
	var charTime = 28;
	$('.textarea').html(lefty + tickerText.substr(0, tickerCursor++));
	if(tickerCursor < tickerText.length+1)
		if( isInTag ){
			typetext();
		}else{
			var curr = tickerText.substr(tickerCursor-2,1);
			if ((curr==".")||(curr=="?"||curr=="!")){ charTime = 200;}
			setTimeout("typetext()", charTime);
		}
	else {
		textIsTyping = false;
		waitingForUser = true;
		$(".textarea").html(lefty+tickerText+righty)
		tickerText = "";
	}	
}
//END TICKERTYPE PLUGIN

function speak(){
  	$(".glassbox .textarea").text("");
  	$(".glassbox").fadeIn('slow',function(){
  		$(".glassbox .textarea").text(action['text']);
  		$(".glassbox .speaker").text(action["get_character_name"]);
  		createTicker();
  	});
}

var currentEvent = 0;
var timeToWait = 1000;
var action;
var textIsTyping = false;
var waitingForUser = false;
function nextEvent(){
  action = scenes[currentEvent];
  console.log('action',action);
  if (action['event_type']=="BackgroundImageEvent"){
  	$(".glassbox").fadeOut();
  	$("img.bg-content").fadeOut('slow', function(){ //fade out old background
	  	$("img.bg-content").attr("src",action['filename']).fadeIn('slow', function(){
	  		 currentEvent += 1;
	  		 setTimeout('nextEvent()',timeToWait);
	  	});
    });
  } else if (action['event_type']=="CharacterPoseEvent"){
  	var oldpose = $(".characters[data-character-id="+action['character_id']+"]"); //remove old pose
	var tag = '<img class="characters" src="'+action["filename"]+'" style="display: none;" data-character-id="'+action["character_id"]+'">';
	if(action["characters_present"][0][0]==action["character_id"]){ 
	  //tells you which position the char is in
	}
	if(oldpose.length > 0){
		oldpose.fadeOut('slow', function(){oldpose.remove()});
	}
	$(tag).insertBefore(".glassbox").fadeIn('slow', function(){
		currentEvent += 1;
		setTimeout('nextEvent()',timeToWait);
	});
	
    
  } else if(action['event_type']=="CharacterSpeaksEvent"){
  	$(".glassbox").removeClass("narration");
  	lefty="&ldquo;"; righty = "&rdquo;";
  	speak();
  } else if(action['event_type']=="CharacterThinksEvent"){
  	$(".glassbox").removeClass("narration");
  	lefty="<i class='thought'>("; righty=")</i>";
  	speak();
  } else if(action['event_type']=="NarrationEvent"){
  	$(".glassbox").addClass("narration");
  	lefty=""; righty="";
  	speak();
  } else if(action['event_type']=="SceneEndEvent"){
  	$(".glassbox").hide();
  	$(".characters").fadeOut('slow', function(){
  		$("img.bg-content").fadeOut('slow', function(){
  		  currentEvent += 1;
	  	  setTimeout('nextEvent()',timeToWait);
  		});
  	});
  }

  
}
$(document).ready(function() {
	$(".viewer").click(function(){
		if(textIsTyping){
			tickerCursor = tickerText.length+1
		} else if (waitingForUser){
			waitingForUser = false;
			$(".glassbox .textarea").text("");
			currentEvent += 1;
			nextEvent();
		}
	});
    nextEvent(); //starts viewer

});