$('document').ready(function() {
  $('#gallery .sketch').each(function(index) {
    var $this = $(this);
    $this.districtMap({
      enableSketching   : false,
      enableZoom        : false,
      states            : STATES,
      districts         : DISTRICTS,
      fields : {
        sketchToken  : $this.find('input.sketch_token'),
        combinedCode : $this.find('input.combined_code'),
        sketchPaths  : $this.find('input.sketch_paths'),
      },
    });
  });
});