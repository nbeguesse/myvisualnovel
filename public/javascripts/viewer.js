
var cover = "<div class='black glass' style='display:none; width:800px; height:600px'></div>;";
var anim = "<img src='/images/7-1.gif'>";
var titlecard = '<div id="title-wrapper"><div id="title"><div><div><span></span></div></div></div></div>';
var afterCreditsText = "<h3><a href='javascript:location.reload()'>Play Again</a><br/></h3><p><small>Powered by <br/><a href='/'>MyVisualNovel.com</a><br/>Create your own!</small></p>";


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
   self.lastSound = null;
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
var sm = soundManager;
var pausedWhileTyping = false;
var defaultVolume = 100;
var femaleBlip, maleBlip;

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
  //console.log('action',action);
  if(paused){ return; } 
  if(currentEvent >= scenes.length){

  	//we are finished!!
    //show replay option!!
    $(".viewer").hide();
    $("#sound-controls").css("visibility","hidden");
    var title = $(titlecard);
    title.find("span").html(afterCreditsText);
    title.hide().insertAfter(".viewer");
    title.fadeIn('slow');


  } else if(action['event_type']=="PreloadEvent"){
    currentEvent += 1;
    nextEvent();
  } else if (action['event_type']=="BackgroundImageEvent"){
  	$(".glassbox").fadeOut();
  	$("#bg-content").fadeOut('slow', function(){ //fade out old background
	  	$("#bg-content").attr("src",images[currentEvent]).fadeIn('slow', function(){
	  		 currentEvent += 1;
	  		 setTimeout('nextEvent()',timeToWait);
	  	});
    });
  } else if (action['event_type']=="CharacterPoseEvent"){
    $(".glassbox").hide();
    //smooth fade new content over old
    var black = $("<img src='"+images[currentEvent]+"' class='characters img-rounded'>");
    black.insertBefore("#bg-content");
    $("#bg-content").addClass("old").fadeOut('slow', function(){
      $(".old").remove();
      black.attr("id","bg-content")
      currentEvent += 1;
      setTimeout('nextEvent()',timeToWait);
    });

 
  } else if (action['event_type']=="LovePoseEvent"){
    var black = $(cover);
    black.insertAfter(".glassbox").fadeIn('slow', function(){
       //look ahead at the next scene, and if its a CharacterPoseEvent
       //show it all at once
       var next = scenes[currentEvent+1];
       if((next != null)&&(next['event_type']=="CharacterPoseEvent")){
        currentEvent += 1;
       }
       $("#bg-content").attr("src",images[currentEvent]).show();

       black.fadeOut('slow', function(){
         currentEvent += 1;
         setTimeout('nextEvent()',timeToWait);
         black.remove();
       });
    });  
    

	} else if(action['event_type']=="CharacterVanishEvent"){
    //same as CharacterPoseEvent
    $(".glassbox").hide();
    //smooth fade new content over old
    var black = $("<img src='"+images[currentEvent]+"' class='characters img-rounded'>");
    black.insertBefore("#bg-content");
    $("#bg-content").addClass("old").fadeOut('slow', function(){
      $(".old").remove();
      black.attr("id","bg-content")
      currentEvent += 1;
      setTimeout('nextEvent()',timeToWait);
    });
    
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
    //assume it comes after scene end event
    // so everything is already black
    var title = $(titlecard);
    title.find("span").html(action['text']);
    title.hide().insertBefore(".glassbox");
    title.fadeIn('slow', function(){
      currentEvent += 1;
      setTimeout(function(){
        title.fadeOut('slow',function(){
          title.remove();
          nextEvent();
        });
      },2000);
    });

    
  } else if(action['event_type']=="SceneEndEvent"){
  	$(".glassbox").hide();
    stopLastSound();
    var black = $(cover);
    black.insertAfter(".glassbox").fadeIn('slow', function(){
      $("#bg-content").hide();
      black.remove();
      currentEvent += 1;
      setTimeout('nextEvent()',timeToWait);
    });
  } else if(action['event_type']=="BackgroundMusicEvent"){
    //$(".glassbox").hide();
    if(action['filename'] == ""){
      //console.log('Starting Silence...');
      stopLastSound();
      currentEvent+=1;
      setTimeout('nextEvent()',timeToWait/2);
      return false;
    }
    var soundURL = action['filename'];
    var thisSound = self.getSoundByURL(soundURL);
    
    if (thisSound) {
      // already exists
      if (thisSound == self.lastSound) {
        //console.log('Already playing...')
        //already playing. do nothing!
        currentEvent += 1;
        nextEvent();
        return false;
      } else {
        //console.log("playing already loaded sound")
      	stopLastSound();

        thisSound.play({loops:9999});
        self.lastSound = thisSound;
        //no need to go to nextEvent, since its in onplay
        return false;
      }
    } else {
	  stopLastSound();
      //console.log('making new sound');
      // create sound
      thisSound = sm.createSound({
       id:'MP3Sound'+(self.soundCount++),
       url:soundURL,
        onplay: function(){
        	currentEvent += 1;
        	setTimeout('nextEvent()',timeToWait/2);

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
  //console.log(pausedWhileTyping)
}
function unpause(){
  paused = false;
  //console.log(pausedWhileTyping)
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



var soundManagerLoaded = false;
var titleLoaded = false;
var started = false;
var soundLoaded = false;
var imagesLoaded = false;
var currentSceneLoading = 0;
var assetList = [];
var initialAssetsLoaded = false;

function preloadStuff(){
  //start preloading
  var assets = assetList[currentSceneLoading];
  if(assets == null) { return; } //done!!
  soundLoaded = true;
  imagesLoaded = true;
  var div = $("<div>");
  //console.log(assets);
  for(var i=0; i<assets.length; i++){
    var asset = assets[i];
    if(asset.indexOf(".mp3")> 0 ){
      soundLoaded=false;
      //console.log('mp3',asset);
      var thisSound = sm.createSound({
        url:asset,
        autoLoad:true,
        onload:function(){
          //console.log('SOUND LOADED', thisSound.url);
          soundLoaded=true;
          scenePreloaded();
          window.soundsByURL[thisSound.url] = thisSound;
        }
      });
    } else {
      imagesLoaded = false;
      $("<img>").attr("src",asset).appendTo(div);
    }
  }
  div.imagesLoaded()
  .always( function( instance ) {
    imagesLoaded=true;
    //console.log('loaded them');
    scenePreloaded();
  });
}

function scenePreloaded(){
  if(imagesLoaded && soundLoaded){
    //console.log('done preloading both');
    initialAssetsLoaded = true;
    currentSceneLoading += 1;
    startIfLoaded();
    preloadStuff();
  }
}

function startIfLoaded(){
  if(started){ return true; }
  if(soundManagerLoaded && titleLoaded && initialAssetsLoaded){
   // console.log("STARTING");
    started = true;
    $("#title-wrapper").fadeOut('slow',function(){
      $("#title-wrapper").remove();
      nextEvent();
    });
  }
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

  //prepare preloading
  for(var i=0; i<scenes.length; i++){
    if(scenes[i]['event_type']=="PreloadEvent"){
      assetList.push(scenes[i].text);
    }
  }
  //put up loading animation
    var title = $(titlecard);
    title.find("span").html("<img src='/images/ajax-loader.gif'>");
    title.hide().insertBefore(".glassbox");
    title.fadeIn('slow', function(){
      titleLoaded = true;
      startIfLoaded();
    });

	soundManager.url = '/swf/soundmanager2_flash9.swf';
    soundManager.onload = function() {
      soundManagerLoaded = true;
      startIfLoaded();
      preloadStuff(); //starts preloading which starts viewer
      femaleBlip = sm.createSound({
        id:'Blip1',
        url:"/sounds/blipfemale2.mp3",
        autoload:true
      });
      maleBlip = sm.createSound({
        id:'Blip2',
        url:"/sounds/blipmale2.mp3",
        autoload:true
      });
    }
  $("#volume-control").bind("slider:changed", function (event, data) {
    setVolume(data.value);
  });


  



});