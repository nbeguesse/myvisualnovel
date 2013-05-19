jQuery.fn.extend({
  slideRightShow: function() {
    return this.each(function() {
        $(this).show('slide', {direction: 'right'}, 1000);
    });
  },
  slideLeftHide: function() {
    return this.each(function() {
      $(this).hide('slide', {direction: 'left'}, 1000);
    });
  },
  slideRightHide: function() {
    return this.each(function() {
      $(this).hide('slide', {direction: 'right'}, 1000);
    });
  },
  slideLeftShow: function() {
    return this.each(function() {
      $(this).show('slide', {direction: 'left'}, 1000);
    });
  },
  slideUpShow: function() {
    return this.each(function() {
        $(this).show('slide', {direction: 'down'});
    });
  },
  slideDownHide: function() {
    return this.each(function() {
      $(this).hide('slide', {direction: 'down'}, 1000);
    });
  },
});