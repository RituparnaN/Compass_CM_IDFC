//color array 


var chartColrSet1 = ["#178d79","#22b399","#b0282b","#455f82","#398fc7","#e05958","#d08229","#eaa143","#676866"];
var chartColorSet2 = ["#22b399","#398fc7","#e05958","#455f82","#178d79","#b0282b","#d08229","#eaa143","#676866"];
var chartColorSet3 = ["#e05958","#22b399","#398fc7"];
var chartColorSet4 = ["#22b399","#e05958","#398fc7","#eaa143","#676866"];

//
Chart.defaults.global.title.fontSize = 14;
Chart.defaults.global.title.fontFamily = "proximaNova-regular";
Chart.defaults.global.title.fontStyle = 'normal';
Chart.defaults.global.plugins.datalabels.display = false;

Chart.plugins.register({
	  afterDraw: function(context) {
		 // console.log(context);
	    if (context.config.options.showDatapoints) {
	    	var ctx = context.chart.ctx;
            context.data.datasets.forEach(function (dataset) {
            	// console.log(dataset);
              for (var i = 0; i < dataset.data.length; i++) {
            	if (dataset.data[i] != 0) {
                  var model = dataset._meta[Object.keys(dataset._meta)[0]].data[i]._model;
                  var textY = model.y + (dataset.type == "line" ? -3 : 15);
                  ctx.font = Chart.helpers.fontString(Chart.defaults.global.defaultFontSize, 'normal', Chart.defaults.global.defaultFontFamily);
                  ctx.textAlign = 'start';
                  ctx.textBaseline = 'middle';
                  ctx.fillStyle = dataset.type == "line" ? "black" : "black";
                  ctx.save();
                  ctx.translate(model.x, textY-15);
                  ctx.rotate(4.7);
                  ctx.fillText(dataset.data[i], 0, 0);
                  ctx.restore();
                }
              }
            });
	    }
	  }
});

//for showing dropdown of download menus
downloadButtonHovered = function(graph, canvasId, csvArray, graphName) {
	//console.log(graph+", "+canvasId+", "+csvArray+", "+graphName)
	if($(".graph-dropdown-content").is(':visible')){
		$(".graph-dropdown-content").remove();
		//console.log(" removed the previous dropdown div");
	}
	var dropdownMenuContent = document.createElement("div");
	dropdownMenuContent.classList.add("graph-dropdown-content");
	dropdownMenuContent.style.display = "block";

	var pdfParam = "printGraph('" + canvasId + "')";
	var csvParam = "exportToCsv(" + csvArray + ",'" + graphName + "')";
	var jpgParam = "exportToImage('" + canvasId + "','" + graphName + "')";
	var href = "javascript:void(0)";

	var pdfA = document.createElement('a');
	var pdfText = document.createTextNode('PDF');
	pdfA.appendChild(pdfText);
	pdfA.setAttribute("href", href);
	pdfA.setAttribute("onclick", pdfParam);

	var csvA = document.createElement('a');
	var csvText = document.createTextNode('CSV');
	csvA.appendChild(csvText);
	csvA.setAttribute("href", href);
	csvA.setAttribute("onclick", csvParam);

	var jpgA = document.createElement('a');
	var jpgText = document.createTextNode('JPG');
	jpgA.appendChild(jpgText);
	jpgA.setAttribute("href", href);
	jpgA.setAttribute("onclick", jpgParam);

	dropdownMenuContent.appendChild(pdfA);
	dropdownMenuContent.appendChild(csvA);
	dropdownMenuContent.appendChild(jpgA);
	graph.parentElement.append(dropdownMenuContent);
	//console.log(dropdownMenuContent);
}

downloadButtonLeaved = function(graph) {
	$(".graph-dropdown-content").remove();
}

//for printing graph

printGraph = function(elementId, graphName) {
	let tagName = $("#"+elementId).prop("tagName");
	if(tagName == 'CANVAS'){
		var dataUrl = document.getElementById(elementId).toDataURL();
		var windowContent = '<!DOCTYPE html>';
		windowContent += '<html>';
		//windowContent += '<head><title>Customer Risk Rating</title></head>';
		windowContent += '<body>';
		windowContent += '<img src="' + dataUrl+ '" style="display: block; margin: auto;">';
		windowContent += '</body>';
		windowContent += '</html>';
		const printWin = window.open('', '', 'width=' + screen.availWidth + ',height='+ screen.availHeight);
		printWin.document.open();
		printWin.document.write(windowContent);
		printWin.document.addEventListener('load', function() {
			printWin.focus();
			printWin.print();
			printWin.document.close();
			printWin.close();
		}, true);
	}else{
		//code for printing div ,table.
		//var parentDivId = document.getElementById(elementId).closest('div').id;
		var node = document.getElementById(elementId);
	    var canvas = document.createElement('canvas');
	    canvas.width = node.scrollWidth;
	    canvas.height = node.scrollHeight;
	    
	    domtoimage.toPng(node).then(function (pngDataUrl) {
	        var img = new Image();
	        img.onload = function () {
	        var context = canvas.getContext('2d');
	        context.drawImage(img, 0, 0);
	      };
	      
			var windowContent = '<!DOCTYPE html>';
			windowContent += '<html>';
			windowContent += '<body>';
			windowContent += '<img src="' + pngDataUrl+ '" style="display: block; margin: auto;">';
			windowContent += '</body>';
			windowContent += '</html>';
			const printWin = window.open('', '', 'width=' + screen.availWidth + ',height='+ screen.availHeight);
			printWin.document.open();
			printWin.document.write(windowContent);
			printWin.document.addEventListener('load', function() {
				printWin.focus();
				printWin.print();
				printWin.document.close();
				printWin.close();
			}, true);
	    });
	
	}    
	//alert(canvasId);
	
}

printAllGraphs = function(divId) {
	var graphsAll = document.getElementById(divId).getElementsByTagName("canvas");
	var windowContent = '<!DOCTYPE html>';
	windowContent += '<html>';
	windowContent += '<body>';
	
	for (var i = 0; i < graphsAll.length; i++) {
	   var graphs = graphsAll[i].id;
	   var dataUrl = document.getElementById(graphs).toDataURL();
	   windowContent += '<img src="' + dataUrl + '" style="margin: 40px 10px;">'; 
	}
	windowContent += '</body>';
	windowContent += '</html>';
	const printWin = window.open('', '', 'width=' + screen.availWidth + ',height='+ screen.availHeight);
	printWin.document.open();
	printWin.document.write(windowContent);
	printWin.document.addEventListener('load', function() {
		printWin.focus();
		printWin.print();
		printWin.document.close();
		printWin.close();
	}, true);
}

// for export to csv
exportToCsv = function(csvArray, graphName) {
	var csvString = "";

	csvArray.forEach(function(RowItem, RowIndex) {
		RowItem.forEach(function(ColItem, ColIndex) {
			csvString += ColItem + ',';
		});
		csvString += "\r\n";
	});
	csvString = "data:application/csv," + encodeURIComponent(csvString);
	var x = document.createElement("A");
	x.setAttribute("href", csvString);
	x.setAttribute("download", graphName + ".csv");
	document.body.appendChild(x);
	x.click();
}


//for export to img
exportToImage = function(elementId, graphName){
	let tagName = $("#"+elementId).prop("tagName");
	if(tagName == 'CANVAS'){
		var dataUrl = document.getElementById(elementId).toDataURL(); 
		var link = document.createElement('a');
		link.href = dataUrl;
		link.download = graphName+".jpg";
		document.body.appendChild(link);
		link.click();
	}else{
		var mode = 1 // default 1 (save to image), mode 2 = save to canvas
	   // console.log("Process start");
	    var node = document.getElementById(elementId);
	    // get the div that will contain the canvas
	    //var canvas_out = document.getElementById('canvas_out');
	    var canvas = document.createElement('canvas');
	    canvas.width = node.scrollWidth;
	    canvas.height = node.scrollHeight;
	    
	    domtoimage.toPng(node).then(function (pngDataUrl) {
	        var img = new Image();
	        img.onload = function () {
	        var context = canvas.getContext('2d');
	        context.drawImage(img, 0, 0);
	      };
	
	      if (mode == 1){ // save to image
	    	  var link = document.createElement("a");
	          link.download = graphName+".jpg";
	          link.href = pngDataUrl;
	          document.body.appendChild(link);
	          link.click();   
	      }else if (mode == 2){ // save to canvas
	        img.src = pngDataUrl;
	        canvas_out.appendChild(img);
	      }
	    //console.log("Process finish");
	    });
	}	
}

//for resizing graph mainly dc js graphs
$.event.special.widthChanged = {
    remove: function() {
        $(this).children('iframe.width-changed').remove();
    },
    add: function () {
        var element = $(this);
        var iframe = element.children('iframe.width-changed');
        if (!iframe.length) {
            iframe = $('<iframe/>').addClass('width-changed').prependTo(this);
        }
        var oldWidth = element.width();
        function elementResized() {
            var width = element.width();
            if (oldWidth != width) {
                element.trigger('widthChanged', [width, oldWidth]);
                oldWidth = width;
            }
        }
        var timer = 0;
        var ielement = iframe[0];
        (ielement.contentWindow || ielement).onresize = function() {
            clearTimeout(timer);
            timer = setTimeout(elementResized, 20);
        };
    }
}





