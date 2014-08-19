// SOCKS configuration
// Take advantage that 0 corresponds to No proxy
// and 1 corresponds to Manual proxy

var socks_ssh = "localhost";
var socks_ssh_port = 12345;
user_pref('network.proxy.socks', socks_ssh);
user_pref('network.proxy.socks_port', socks_ssh_port);
user_pref('network.proxy.type', 0);

function toggle_socks() {
    var pref = get_pref("network.proxy.type");

    if (pref == 0) {
	    session_pref('network.proxy.type', 1);
        clear_cookies();
        cwd = make_file("~/Downloads/Papers");

        var cmd_str = 'urxvtc -e ~/bin/icn';
        shell_command_blind(cmd_str);
    }
    else {
	    session_pref('network.proxy.type', 0);
        cwd = make_file("~/Downloads");
    }
}

interactive("toggle-socks",
	   "Toggle SOCKS proxy on and off",
	   toggle_socks);


// Import arXiv citation and PDF to ebib
// --------------------------------------
function ebib_import_arxiv (url) {
    var cmd_str = 'emacsclient -ne \'(ebib-import-arxiv \"' + url + '\")\'';
    shell_command_blind(cmd_str);
}

interactive("arxiv2ebib", "Download PDF and add bibtex entry for current preprint to ebib",
            function (I) {
		ebib_import_arxiv(I.buffer.display_uri_string);
            });

define_key(content_buffer_normal_keymap, "C-c c", "arxiv2ebib");

// Import bibtex entry to ebib
// ----------------------------
function ebib_import_bibtex (url, filename) {
    var cmd_str = 'emacsclient -ne \'(ebib-import-bibtex \"' + url + '\" ' + '\"' + filename + '\")\'';
    
    shell_command_blind(cmd_str);
}

interactive("bibtex2ebib", "Download PDF and add bibtex entry for current preprint to ebib",
            function (I) {
		ebib_import_bibtex(I.buffer.display_uri_string,
				  (yield I.minibuffer.read($prompt = "Enter filename: ")));
            });

define_key(content_buffer_normal_keymap, "C-c f", "bibtex2ebib");

