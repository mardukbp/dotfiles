// Capture with org-protocol
// --------------------------
function org_capture (url, title, selection, window) {
    var cmd_str =
        'emacsclient \"org-protocol:/capture:/b/'+url+'/'+title+'/'+selection+'\"';
    if (window != null) {
      window.minibuffer.message('Issuing ' + cmd_str);
    }
    shell_command_blind(cmd_str);
}

interactive("org-capture", "Clip url, title, and selection to capture via org-protocol",
          function (I) {
              org_capture(encodeURIComponent(I.buffer.display_uri_string),
                        encodeURIComponent(I.buffer.document.title),
                                encodeURIComponent(I.buffer.top_frame.getSelection()),
                        I.window);
          });

define_key(content_buffer_normal_keymap, "C-c b", "org-capture");
