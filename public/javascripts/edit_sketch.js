$('document').ready(function() {
  $('#stage').districtMap({
    enableSketching   : true,
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
    savePath          : 'unsaved_sketches',
    authenticityToken : $('meta[name=csrf-token]').attr('content'),
    controls : {
      undoLastPath  : $('button#undo_last_path'),
      clearAllPaths : $('button#clear_all_paths'),
    },
  });
});
