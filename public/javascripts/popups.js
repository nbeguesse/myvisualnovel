var popups = { }
popups.center = function(elem) {
    var arrPageSizes = popups.getPageSize();
    // Get page scroll
    var arrPageScroll = popups.getPageScroll();
    // Calculate top and left offset for the jquery-lightbox div object and show it
    $(elem).css({
        top:    arrPageScroll[1] + (arrPageSizes[3]-$(elem).height())/2,
        left:   arrPageScroll[0] + (arrPageSizes[2]-$(elem).width())/2,
        "z-index": 2000
    }).slideDown();
    // If window was resized, calculate the new overlay dimensions
    $(window).resize(function() {
        // Get page sizes
        var arrPageSizes = popups.getPageSize();
        // Get page scroll
        var arrPageScroll = popups.getPageScroll();
        // Calculate top and left offset for the jquery-lightbox div object and show it
        $(elem).css({
            top:    arrPageScroll[1] + (arrPageSizes[3]-$(elem).height())/2,
            left:   arrPageScroll[0] + (arrPageSizes[2]-$(elem).width())/2
        });
    });
}

popups.getPageSize = function() {
    var xScroll, yScroll;
    if (window.innerHeight && window.scrollMaxY) {  
        xScroll = window.innerWidth + window.scrollMaxX;
        yScroll = window.innerHeight + window.scrollMaxY;
    } else if (document.body.scrollHeight > document.body.offsetHeight){ // all but Explorer Mac
        xScroll = document.body.scrollWidth;
        yScroll = document.body.scrollHeight;
    } else { // Explorer Mac...would also work in Explorer 6 Strict, Mozilla and Safari
        xScroll = document.body.offsetWidth;
        yScroll = document.body.offsetHeight;
    }
    var windowWidth, windowHeight;
    if (self.innerHeight) { // all except Explorer
        if(document.documentElement.clientWidth){
            windowWidth = document.documentElement.clientWidth; 
        } else {
            windowWidth = self.innerWidth;
        }
        windowHeight = self.innerHeight;
    } else if (document.documentElement && document.documentElement.clientHeight) { // Explorer 6 Strict Mode
        windowWidth = document.documentElement.clientWidth;
        windowHeight = document.documentElement.clientHeight;
    } else if (document.body) { // other Explorers
        windowWidth = document.body.clientWidth;
        windowHeight = document.body.clientHeight;
    }   
    // for small pages with total height less then height of the viewport
    if(yScroll < windowHeight){
        pageHeight = windowHeight;
    } else { 
        pageHeight = yScroll;
    }
    // for small pages with total width less then width of the viewport
    if(xScroll < windowWidth){  
        pageWidth = xScroll;        
    } else {
        pageWidth = windowWidth;
    }
    arrayPageSize = new Array(pageWidth,pageHeight,windowWidth,windowHeight);
    return arrayPageSize;
};
popups.getPageScroll = function() {
    var xScroll, yScroll;
    if (self.pageYOffset) {
        yScroll = self.pageYOffset;
        xScroll = self.pageXOffset;
    } else if (document.documentElement && document.documentElement.scrollTop) {     // Explorer 6 Strict
        yScroll = document.documentElement.scrollTop;
        xScroll = document.documentElement.scrollLeft;
    } else if (document.body) {// all other Explorers
        yScroll = document.body.scrollTop;
        xScroll = document.body.scrollLeft; 
    }
    arrayPageScroll = new Array(xScroll,yScroll);
    return arrayPageScroll;
};  