$('document').ready(function() {
  $('#stage').districtMap({
    enableSketching   : false,
    enableZoom        : true,
    states            : STATES,
    districts         : DISTRICTS,
    initialViewBox    : '-20 -20 780 440',
    zoomDuration      : 2000,
    fields : {
      sketchToken  : $('#sketch_token'),
      combinedCode : $('#combined_code'),
      population   : $('#population_value'),
      sketchPaths  : $('#sketch_paths'),
    },
    replaySketch      : true,
  });
  $('#gallery .sketch').each(function(index) {
    var $this = $(this);
    $this.districtMap({
      enableSketching   : false,
      enableZoom        : false,
      states            : STATES,
      districts         : DISTRICTS,
      fields : {
        sketchToken  : $this.find('#sketch_token'),
        combinedCode : $this.find('#combined_code'),
        sketchPaths  : $this.find('#sketch_paths'),
      },
    });
  });
});
