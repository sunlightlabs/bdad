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
});
