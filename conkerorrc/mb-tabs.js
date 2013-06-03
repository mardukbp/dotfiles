// Tab bar
require("new-tabs.js");

// Open tabs with middle click
// -----------------------------
require("clicks-in-new-buffer.js");
clicks_in_new_buffer_target = OPEN_NEW_BUFFER_BACKGROUND; 
clicks_in_new_buffer_button = 1; //  midclick links in new buffers

// Reopen closed tab
// ------------------

// create an Array to hold the closed tabs
var my_closed_buffers = new Array();

// save the URL of the current buffer before closing it (max 10 buffers)
interactive("my-close-and-save-current-buffer",
	"close and save the current buffer for later restore",
	function(I) {
	    if(my_closed_buffers.length==10){
		    my_closed_buffers.shift(); // remove older item to save
		    // memory, just save maximum 10 buffers
		}
		my_closed_buffers.push(I.buffer.document.URL);
		kill_buffer(I.buffer); //kill the current buffer
	});

// rebind "q" key
undefine_key(default_global_keymap, "q");
define_key(default_global_keymap, "q", "my-close-and-save-current-buffer");

// reopen the closed buffers
interactive("my-open-closed-buffer",
  "open the last closed buffer", 
  function(I){
    // check if the array length > 0
    if(my_closed_buffers.length>0){
      // load the URL in new windows
      load_url_in_new_buffer(
        my_closed_buffers[my_closed_buffers.length - 1], I.window);
      // remove the first item in the array
      my_closed_buffers.pop();
    }
  });

define_key(default_global_keymap, "M-r", "my-open-closed-buffer");
