
var cover = "<div class='black glass' style='display:none; width:800px; height:600px'></div>;";
var anim = "<img src='/images/7-1.gif'>";
var titlecard = '<div id="title-wrapper"><div id="title"><div><div><span></span></div></div></div></div>';
var afterCreditsText = "<h3><a href='javascript:location.reload()'>Play Again</a><br/></h3><p><small>Powered by <br/><a href='/'>MyVisualNovel.com</a></small></p>";

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
		if( isInTag ){ //skip HTML tags
			typetext();
		}else{
			var curr = tickerText.substr(tickerCursor-2,1);
      voiceSound.play();
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
		s.setVolume(defaultVolume); //reset volume for the replay
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
 function setVolume(g){
  soundManager.defaultOptions.volume = g;
  defaultVoume = g;
  for(var i in soundManager.sounds) {
    soundManager.getSoundById(i).setVolume(g);
  } 

 }

//END SOUNDS

var currentEvent = 0;
var timeToWait = 1000;
var action;
var textIsTyping = false;
var waitingForUser = false;
var sm = soundManager;
var paused = false;
var pausedWhileTyping = false;
var defaultVolume = 100;
var femaleBlip, maleBlip, voiceSound;

function speak(){
    $("#textarea").text("");
    $(".glassbox .speaker").text("");
    $(".glassbox").fadeIn('slow',function(){
      $("#textarea").text(action['text']);
      $(".glassbox .speaker").text(action["get_character_name"]);
      createTicker();
    });
    if(action["character_type"] == "Ami"){
      voiceSound = femaleBlip;
    } else {
      voiceSound = maleBlip;
    }
}

function nextEvent(){
  action = scenes[currentEvent];
  console.log('action',action);
  if(paused){ return; } 
  if(currentEvent >= scenes.length){
  	//we are finished!!


    $(".viewer").hide();
    $("#sound-controls").css("visibility","hidden");
    var title = $(titlecard);
    title.find("span").html(afterCreditsText);
    title.insertAfter(".viewer");


    //$(".viewer").css("cursor", "auto");
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
     var facetag = '<img class="characters" src="'+action["subfilename"]+'" style="display: none;">';
    for(var i=1; i<3; i++){
      if(action['characters_present'][i] != null){ //skip blanks and nils
        if(action["characters_present"][i][0] == action['character_id']){ //if character file src changed
          $(".character"+i).addClass("character-old").fadeOut('slow',function(){ //remove old character if exists
            $(".character-old").remove();
          });
          $(tag).addClass("character"+i).insertBefore(".glassbox").fadeIn('slow');
          $(facetag).addClass("character"+i).insertBefore(".glassbox").fadeIn('slow', function(){ 
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
        var character = $(".character"+i);
        if(character.length > 0){
          character.fadeOut('slow',function(){
          });
          currentEvent += 1;
          setTimeout('nextEvent()',timeToWait+600);
        }
        
      }
    }
    
  } else if(action['event_type']=="CharacterSpeaksEvent"){
  	setupGlassBox(action);
  	speak();
  } else if(action['event_type']=="CharacterThinksEvent"){
  	setupGlassBox(action);
  	speak();
  } else if(action['event_type']=="NarrationEvent"){
  	setupGlassBox(action);
  	speak();
  } else if(action['event_type']=="TitleCardEvent"){
    $(".viewer").hide();
    var title = $(titlecard);
    title.find("span").text("ahooy!");
    title.insertAfter(".viewer");
    
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
      thisSound.play({loops:9999});
      self.lastSound = thisSound;
    }

  }

  
}

function pause(){
  pausedWhileTyping = textIsTyping;
  paused = true;
  sm.pauseAll();
  console.log(pausedWhileTyping)
}
function unpause(){
  paused = false;
  console.log(pausedWhileTyping)
  if(pausedWhileTyping){
    typetext();
  } else if(waitingForUser){
    waitingForUser = false;
    $("#textarea").text("");
    currentEvent += 1;
    nextEvent();
  } else {
    nextEvent();
  }
  sm.resumeAll();
}

$(document).ready(function() {
  $("#pause-button").click(function(){
    if(paused){
      unpause();
      $(this).find("i").removeClass().addClass("icon-pause");
    } else {
      pause();
      $(this).find("i").removeClass().addClass("icon-play");
    }
    return false;
  });
	$(".viewer").click(function(){
    if(paused){ return; }
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
      femaleBlip = sm.createSound({
        id:'Blip1',
        url:"/sounds/blipfemale2.mp3"
      });
      maleBlip = sm.createSound({
        id:'Blip2',
        url:"/sounds/blipmale2.mp3"
      });
    }
  $("#volume-control").bind("slider:changed", function (event, data) {
    // The currently selected value of the slider
    //console.log('value',data.value);
    setVolume(data.value);
    // The value as a ratio of the slider (between 0 and 1)
    //console.log('ratio',data.ratio);
  });


});