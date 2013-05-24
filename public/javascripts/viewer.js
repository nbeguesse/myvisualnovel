var lefty = ""; var righty = "";
var cover = "<div class='black glass' style='display:none; width:800px; height:600px'></div>;";

//MODIFIED TICKERTYPE PLUGIN
var tickerCursor, tickerText;
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
		$("#textarea").html(lefty+tickerText+righty)
		tickerText = "";
	}	
}
//END TICKERTYPE PLUGIN

function speak(){
  	$("#textarea").text("");
    $(".glassbox .speaker").text("");
  	$(".glassbox").fadeIn('slow',function(){
  		$("#textarea").text(action['text']);
  		$(".glassbox .speaker").text(action["get_character_name"]);
  		createTicker();
  	});
}

//START SOUNDS
  this.sounds = [];
  this.soundsByURL = [];
  this.indexByURL = [];
  this.lastSound = null;
  this.soundCount = 0;
  this.getSoundByURL = function(sURL) {
    return (typeof self.soundsByURL[sURL] != 'undefined'?self.soundsByURL[sURL]:null);
  }
  soundManager.setup({
  // disable or enable debug output
  debugMode: false,
  // use HTML5 audio for MP3/MP4, if available
  preferFlash: false,
  useFlashBlock: true,
  // path to directory containing SM2 SWF
  url: '/swf/',
  // optional: enable MPEG-4/AAC support (requires flash 9)
  flashVersion: 9
  });
 function fadeOutSound(soundID,amount) {
	var s = soundManager.getSoundById(soundID);
	var vol = s.volume;
	if (vol == 0) { 
		s.stop();
		s.setVolume(100); //reset volume
		return false;
	}
	s.setVolume(Math.max(0,vol+amount));
	setTimeout(function(){fadeOutSound(soundID,amount)},20);
  }
 function stopLastSound(){
   if (self.lastSound) {
    fadeOutSound(self.lastSound.id, -5);
   }
 }
//END SOUNDS

var currentEvent = 0;
var timeToWait = 1000;
var action;
var textIsTyping = false;
var waitingForUser = false;
  var sm = soundManager;

function nextEvent(){
  action = scenes[currentEvent];
  console.log('action',action);
  if(currentEvent >= scenes.length){
  	//we are finished!!
    $(".viewer").css("cursor", "auto");
  } else if (action['event_type']=="BackgroundImageEvent"){
  	$(".glassbox").fadeOut();
  	$("#bg-content").fadeOut('slow', function(){ //fade out old background
	  	$("#bg-content").attr("src",action['filename']).fadeIn('slow', function(){
	  		 currentEvent += 1;
	  		 setTimeout('nextEvent()',timeToWait);
	  	});
    });
  } else if (action['event_type']=="CharacterPoseEvent"){
    $(".glassbox").hide();
	   var tag = '<img class="characters" src="'+action["filename"]+'" style="display: none;">';
    for(var i=1; i<3; i++){
      if(action['characters_present'][i] != null){ //skip blanks and nils
        if(action["characters_present"][i][0] == action['character_id']){ //if character file src changed
          $("#character"+i).attr("id","character-old").fadeOut('slow',function(){ //remove old character if exists
            $("#character-old").remove();
          });
          $(tag).attr("id","character"+i).insertBefore(".glassbox").fadeIn('slow', function(){  //add new char
            currentEvent += 1;
            setTimeout('nextEvent()',timeToWait);
          });
        }
      }
    }

  } else if (action['event_type']=="LovePoseEvent"){
    var black = $(cover);
    var tag = '<img class="characters" src="'+action["filename"]+'">';
    black.insertAfter(".glassbox").fadeIn('slow', function(){
      $(".characters").remove();
      if(action['characters_present'][0] != null){ //place bg
        $("#bg-content").show().attr("src",action['characters_present'][0][1]);
      }
      if(action['characters_present'][1] != null){ //place love pose
        $(tag).attr("id","character"+1).insertBefore(".glassbox");
      }
      black.fadeOut('slow', function(){
        currentEvent += 1;
        setTimeout('nextEvent()',timeToWait);
        black.remove();
      });
    });  
    

	} else if(action['event_type']=="CharacterVanishEvent"){
    for(var i=1; i<3; i++){
      if(action['characters_present'][i] == null){
        //note: will run twice if 2 vanishings at once
        $("#character"+i).fadeOut('slow',function(){
          currentEvent += 1;
          setTimeout('nextEvent()',timeToWait);
        });
      }
    }
    
  } else if(action['event_type']=="CharacterSpeaksEvent"){
  	$(".glassbox .glass").attr("src","/images/glassbox.png");
  	lefty="&ldquo;"; righty = "&rdquo;";
  	speak();
  } else if(action['event_type']=="CharacterThinksEvent"){
  	$(".glassbox .glass").attr("src","/images/glassbox.png");
  	lefty="<i class='thought'>("; righty=")</i>";
  	speak();
  } else if(action['event_type']=="NarrationEvent"){
  	$(".glassbox .glass").attr("src","/images/glassbox_n.png");
  	lefty=""; righty="";
  	speak();
  } else if(action['event_type']=="SceneEndEvent"){
  	$(".glassbox").hide();
    stopLastSound();
    var black = $(cover);
    black.insertAfter(".glassbox").fadeIn('slow', function(){
      $(".characters").remove();
      $("#bg-content").hide();
      black.remove();
      currentEvent += 1;
      setTimeout('nextEvent()',timeToWait);
    });
  } else if(action['event_type']=="BackgroundMusicEvent"){
    //$(".glassbox").hide();
    if(action['filename'] == ""){
      stopLastSound();
      currentEvent+=1;
      setTimeout('nextEvent()',timeToWait);
      return false;
    }
    var soundURL = action['filename'];
    var thisSound = self.getSoundByURL(soundURL);
    
    if (thisSound) {
      // already exists
      if (thisSound == self.lastSound) {
        //already playing. do nothing!
      } else {
        console.log('in console1')
      	stopLastSound();
        //play already loaded sound
        thisSound.play({loops:9999});
        self.lastSound = thisSound;
      }
    } else {
	  stopLastSound();

      // create sound
      thisSound = sm.createSound({
       id:'MP3Sound'+(self.soundCount++),
       url:soundURL,
        onplay: function(){
        	currentEvent += 1;
        	setTimeout('nextEvent()',timeToWait);
        },
      });
      self.soundsByURL[soundURL] = thisSound;
      self.sounds.push(thisSound);
      thisSound.play({loops:999});
      self.lastSound = thisSound;
    }

  }

  
}


$(document).ready(function() {
	$(".viewer").click(function(){
		if(textIsTyping){
			tickerCursor = tickerText.length+1
		} else if (waitingForUser){
			waitingForUser = false;
			$("#textarea").text("");
			currentEvent += 1;
			nextEvent();
		}
    return false;
	});
	soundManager.url = '/swf/soundmanager2_flash9.swf';
    soundManager.onload = function() {
      nextEvent(); //starts viewer
    }

});