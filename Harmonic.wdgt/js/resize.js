
/**************************/
// General live-resize code
// This code shows how to implement live-resizing in a widget
/**************************/

var lastPos;		// tracks where the last mouse position was throughout the drag

// The mouseDown function is called the user clicks on the growbox.  It prepares the
// widget to be resized and registers handlers for the resizing operations
function mouseDown(event)
{

	//stop widget from loading
	shouldRefresh = 0;


	var x = event.x + window.screenX;		// the placement of the click
	var y = event.y + window.screenY;
	
	document.addEventListener("mousemove", mouseMove, true);  	// begin tracking the move
	document.addEventListener("mouseup", mouseUp, true);		// and notify when the drag ends

	lastPos = {x:x, y:y};		// track where the initial mouse down was, for later comparisons
								// the mouseMove function

	event.stopPropagation();
	event.preventDefault();
}


// mouseMove performs the actual resizing of the widget.  It is called after mouseDown
// activates it and every time the mouse moves.
function mouseMove(event)
{
	
	var screenX = event.x + window.screenX;		// retrieves the current mouse position
	var screenY = event.y + window.screenY;
		
	var deltaX = 0;		// will hold the change since the last mouseMove event
	var deltaY = 0;

	if ( (window.outerWidth + (screenX - lastPos.x)) >= 150 ) { 		// sets a minimum width constraint
		deltaX = screenX - lastPos.x;								// if we're greater than the constraint,
		lastPos.x = screenX;										// save the change and update our past position
	}

	if ( (window.outerHeight + (screenY - lastPos.y)) >= 177 ) {		// setting contrains for the heght
		deltaY = screenY - lastPos.y;
		lastPos.y = screenY;
	}
	
	window.resizeBy(deltaX, deltaY);	// resizes the widget to follow the mouse movement

	event.stopPropagation();
	event.preventDefault();


    gMyScrollArea.refresh(); 

}


// mouseUp is called when the user stops resizing the widget.  It removes the mouseMove and
// mouseUp event handlers, so that the widget doesn't continute resizing (because the mouse
// button is now up
function mouseUp(event)
{
	document.removeEventListener("mousemove", mouseMove, true);
	document.removeEventListener("mouseup", mouseUp, true);	

	event.stopPropagation();
	event.preventDefault();
	
    widget.setPreferenceForKey(window.outerWidth, prefkey("widgetWidth"));
	widget.setPreferenceForKey(window.outerHeight, prefkey("widgetHeight"));

	//restart widget refreshing
	shouldRefresh = 1;

}
