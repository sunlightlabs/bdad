(function($){
  $.fn.districtMap = function(options) {

    // ===== Defaults =====

    var defaults = {
      enableSketching   : true, // allow user to sketch on top
      enableZoom        : true, // zoom to district from country map
      states            : null, // state data
      districts         : null, // district data
      initialViewBox    : null, // '-20 -20 780 440'
      zoomDuration      : 5000, // in milliseconds
      fields : {
        sketchToken     : null, // jQuery selector to a hidden field
        combinedCode    : null, // jQuery selector to a hidden field
        sketchPaths     : null, // jQuery selector to a hidden field
        population      : null, // jQuery selector to an element
      },
      replaySketch      : null, // Replay sketch (if sketchPaths present)
      replayInterval    : 5,    // Replay delay (if replayDelay is true)
      savePath          : null, // 'unsaved_sketches'
      authenticityToken : null, // Cross Site Request Forgery Token
      controls : {
        undoLastPath    : null, // jQuery selector to undo button
        clearAllPaths   : null, // jQuery selector to clear button
      },
      spinnerImageTag   : "<img src='/images/spinner.gif'/>",
      styles : {
        sketch : {
          fill          : '#FFCCCC',
          fillOpacity   : 0.75,
          opacity       : 0.75,
          stroke        : '#606060',
          strokeWidth   : 0.5,
        },
        district : {
          fill          : '#CCCCFF',
          fillOpacity   : 0.75,
          opacity       : 0.75,
          stroke        : '#606060',
          strokeWidth   : 0.5,
        },
        districts : {
          fillOpacity   : 0,
          opacity       : 0.3,
          stroke        : '#A0A0A0',
          strokeWidth   : 0.5,
        },
        states : {
          fill          : '#408040',
          fillOpacity   : 1,
          opacity       : 0.3,
          stroke        : '#C0C0C0',
          strokeWidth   : 1,
        }
      },
    };

    var settings = $.extend(true, {}, defaults, options);

    // ===== Save Useful Selectors =====

    var $this          = $(this);
    var $sketchToken   = settings.fields.sketchToken;
    var $combinedCode  = settings.fields.combinedCode;
    var $sketchPaths   = settings.fields.sketchPaths;
    var $population    = settings.fields.population;
    var $undoLastPath  = settings.controls.undoLastPath;
    var $clearAllPaths = settings.controls.clearAllPaths;

    // ===== More Variables =====

    if($sketchToken) {
      var sketchToken = $sketchToken[0].value;
    }
    var combinedCode = $combinedCode[0].value;
    var stateCode = combinedCode.substring(0, 2);
    if($sketchPaths) {
      var sketchPaths = $sketchPaths[0].value;
    }
    var districts = settings.districts.features;
    var district  = districts[combinedCode];
    var states    = settings.states.features;
    var baseURL   = window.location.protocol + '//' + window.location.host;
    var saveURL   = baseURL + '/' + settings.savePath;
    var svgPaths  = [];

    // ===== High Level Drawing Functions =====

    var draw = function(svg) {
      configureViewBox(svg);
      var topGroup = svg.group({});
      drawStates(svg, topGroup);
      drawDistricts(svg, topGroup);
      drawDistrict(svg, topGroup);
      var sketchGroup = svg.group(topGroup, settings.styles.sketch);
      if($sketchPaths) {
        drawExistingSketch(svg, sketchGroup);
      }
      if(settings.enableZoom) {
        zoomToDistrict(svg);
      }
      if(settings.enableSketching) {
        enableSketchPad(svg, sketchGroup);
      }
    };

    var configureViewBox = function(svg) {
      var startingViewBox = settings.initialViewBox
        ? settings.initialViewBox
        : viewBoxValue(district.bounds);
      svg.configure({
        viewBox : startingViewBox
      }, false);
    };

    var drawStates = function(svg, parentGroup) {
      var group = svg.group(parentGroup, settings.styles.states);
      var path = reducePaths(states);
      svg.path(group, path);
    };

    var drawDistricts = function(svg, parentGroup) {
      var group = svg.group(parentGroup, settings.styles.districts);
      var path = reducePaths(districts);
      svg.path(group, path);
    };

    var drawDistrict = function(svg, parentGroup) {
      var group = svg.group(parentGroup, settings.styles.district);
      var path = reduceArray(district.paths);
      svg.path(group, path);
    };

    var zoomToDistrict = function(svg) {
      var viewBox = viewBoxValue(district.bounds);
      $(svg.root()).animate({
        svgViewBox : viewBox
      }, settings.zoomDuration);
    };

    var drawExistingSketch = function(svg, parentGroup) {
      var pathStrings = splitPath(sketchPaths);
      if(settings.replaySketch) {
        replayPaths(svg, parentGroup, pathStrings);
      } else {
        drawPaths(svg, parentGroup, pathStrings);
      }
    };

    var drawPaths = function(svg, parentGroup, pathStrings) {
      for(var i = 0, n = pathStrings.length; i < n; ++i) {
        var path = svg.path(parentGroup, pathStrings[i]);
        svgPaths.push(path);
      }
    };

    var replayPaths = function(svg, parentGroup, pathStrings) {
      // Setup indexes...
      var indexes = [];
      for(var i = 0, ni = pathStrings.length; i < ni; ++i) {
        var pathString = pathStrings[i];
        indexes[i] = [];
        for(var j = 0, nj = pathString.length; j < nj; ++j) {
          if(j > 0 && pathString[j] == 'L') {
            indexes[i].push(j);
          }
        }
      }
      // Loop over indexes...
      var intervalID;
      var currentPath;
      var path;
      var i = 0;
      var j = 0;
      var ni = indexes.length;
      var erase = true;
      var step = function() {
        var nj = indexes[i].length;
        if(currentPath && j > 0) {
          svg.remove(currentPath);
        }
        path = pathStrings[i].substring(0, indexes[i][j]);
        if(j == nj - 1) {
          path += 'Z';
        }
        currentPath = svg.path(parentGroup, path);
        if(j == nj - 1) {
          svgPaths.push(currentPath);
        }
        ++j;
        if(j == nj) {
          ++i;
          j = 0;
          if(i == ni) {
            clearInterval(intervalID);
          }
        }
      };
      var start = function() {
        intervalID = setInterval(step, settings.replayInterval);
      };
      if(ni > 0) {
        setTimeout(start, settings.zoomDuration);
      }
    };

    var enableSketchPad = function(svg, parentGroup) {
      var root        = svg.root();
      var point       = root.createSVGPoint();
      var mouseDown   = false;
      var pathString  = '';
      var currentPath = null;
      
      // ===== Events ======

      var dragStart = function(event) {
        mouseDown = true;
        var p = getMousePoint(event);
        pathString = 'M' + p.x + ' ' + p.y;
        event.preventDefault();
      };

      var dragging = function(event) {
        if(mouseDown) {
          var p = getMousePoint(event);
          pathString += 'L' + p.x + ' ' + p.y;
          drawPath();
          event.preventDefault();
        }
      };

      var dragStop = function(event) {
        updatePopulation();
        mouseDown = false;
        pathString += 'Z';
        drawPath();
        svgPaths.push(currentPath);
        currentPath = null;
        saveDrawing();
        event.preventDefault();
      };

      var drawPath = function() {
        if(currentPath) {
          svg.remove(currentPath);
        }
        currentPath = svg.path(parentGroup, pathString);
      };

      var undoLastPath = function() {
        updatePopulation();
        var path = svgPaths.pop();
        if(path) {
          svg.remove(path);
          saveDrawing();
        }
      };

      var clearAllPaths = function() {
        updatePopulation();
        for(var i = 0, n = svgPaths.length; i < n; ++i) {
          svg.remove(svgPaths[i]);
        }
        svgPaths = [];
        saveDrawing();
      };

      // Return the mouse location in SVG coordinates
      var getMousePoint = function(e) {
        var matrix = parentGroup.getCTM().inverse();
        point.x = e.offsetX;
        point.y = e.offsetY;
        var p = point.matrixTransform(matrix);
        return { x : p.x, y : p.y };
      };

      // Return concatenated string of SVG paths
      var getCombinedSVGPaths = function() {
        var path = '';
        for(var i = 0, n = svgPaths.length; i < n; ++i) {
          path += svgPaths[i].getAttribute('d');
        }
        return path;
      };

      var saveDrawing = function() {
        data = {
          'combined_code'      : combinedCode,
          'paths'              : getCombinedSVGPaths(),
          'token'              : sketchToken,
          'authenticity_token' : settings.authenticityToken,
        };
        $.post(saveURL, data, function(data) {
          updatePopulation(data.population);
        }, 'json');
      };

      $this.mousedown(dragStart).mousemove(dragging).mouseup(dragStop);
      if($undoLastPath) {
        $undoLastPath.click(undoLastPath);
        $(document).bind('keydown', 'ctrl+z', undoLastPath);
      }
      if($clearAllPaths) {
        $clearAllPaths.click(clearAllPaths);
        $(document).bind('keydown', 'ctrl+l', clearAllPaths);
      }
    };

    // ===== Other Functions =====

    var updatePopulation = function(population) {
      var content = (population == null)
        ? settings.spinnerImageTag
        : addCommasToNumber(population);
      $population.html(content);
    };

    // Only works for integers, not decimals.
    var addCommasToNumber = function(x) {
      return x.toString().replace(/\B(?=(?:\d{3})+(?!\d))/g, ',');
    };

    // Concatenates an array of strings
    var reduceArray = function(xs) {
      var x = '';
      for(var i = 0, n = xs.length; i < n; ++i) {
        x += xs[i];
      }
      return x;
    };

    // Concatenates all paths from an object
    var reducePaths = function(items) {
      var path = ''
      for(var key in items) {
        path += reduceArray(items[key].paths);
      }
      return path;
    };
    
    // Take one path string and split into an array of paths
    var splitPath = function(path) {
      var paths = [];
      var current = '';
      for(var i = 0, n = path.length; i < n; ++i) {
        current += path[i];
        if(path[i] == 'Z') {
          paths.push(current);
          current = '';
        }
      }
      return paths;
    };

    var calculateRange = function(bounds) {
      return {
        x : bounds.maxX - bounds.minX,
        y : bounds.maxY - bounds.minY,
      };
    };

    var calculateCenter = function(bounds) {
      return {
        x : (bounds.maxX + bounds.minX) / 2.0,
        y : (bounds.maxY + bounds.minY) / 2.0,
      };
    };

    var viewBoxValue = function(bounds) {
      var range    = calculateRange(bounds);
      var center   = calculateCenter(bounds);
      var halfEdge = Math.max(range.x, range.y);
      var edge     = halfEdge * 2.0;
      return [
        center.x - halfEdge,
        center.y - halfEdge,
        edge,
        edge,
      ].join(' ');
    };

    // ===== The Main Function =====

    // Return this.each to maintain chainability for jQuery.
    return this.each(function() {
      $this.svg({ onLoad : draw });
    });
  };
})(jQuery);
