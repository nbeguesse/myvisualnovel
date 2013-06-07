var disqus_shortname = 'mvnforum2';
var disqus_url = location.href;
var disqus_config = function () { 
	this.language = "en";
};
var disqus_api_key = "r66MDumZy08VXMs9gJS2Lz3Ko9cVGQB00iv08DsHHkSOFs6T8kw0WsZEvJ5y4Aaj";

$(document).ready(function() {
	$("#newThread").submit(newThread);

	if(location.hash == "")
		$('#topic').hide();

	//Load threads
	$.ajax({
		type: "GET",
		url: "https://disqus.com/api/3.0/forums/listThreads.jsonp",
		data: {
			api_key: disqus_api_key,
			forum: "mvnforum2",
			limit: 100,
			include: ["open"],
		},
		dataType: "jsonp",
		success: gotThreadList,
		error: function(json){
			$("#threadList").text("ERROR: " + JSON.stringify(json));
		},
	});	

});

function gotThreadList(resp)
{
	var tl = $("#threadList");
	tl.empty();

	for(var ti in resp.response)
	{
		var t = resp.response[ti];
		if(t.posts == 0)
			continue;
		var line = createThread(t);
		tl.append(line);
	}
}

function createThread(t)
{
	var line = $("#threadListTemplate").clone(false);
	line.removeAttr('id');
	line.find(".title").text(t.title);
	line.find(".comments").find('i').text(t.posts);
	d = new Date(t.createdAt); 
	line.find(".created-date").text(d.toLocaleString());
	line.find(".title").attr('href', t.link);
	line.click(openThreadClick);
        line.data('thread', t);
	return line;
}

function newThread(){
	var title = $("#newThreadName").val();
	var t = {
				//TODO: Change this and also change the URL at http://disqus.com/api/applications/2355017/
                link: "http://myvisualnovel.com/forum/#!" + title,
                title: title,
        }

	var line = createThread(t);
	$("#threadList").prepend(line);

	openThread(line);
	return false;
}

function openThreadClick(e){
        var line = $(this);
        openThread(line);
	return false;
}

function openThread(line){
        var t = line.data('thread');

	$('#topic').show();
        $('html, body').animate({
                scrollTop: $("#topic").offset().top
        }, 500);
	$('#topic h1').text(t.title);

    DISQUS.reset({
      reload: true,
      config: function () {
/*      this.page.identifier = t.identifiers[0];*/
        this.page.url = t.link;
        this.page.title = t.title;
        this.language = "en";
      }
    });
};

