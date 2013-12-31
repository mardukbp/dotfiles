// Sources:
// http://emacs-fu.blogspot.mx/2010/12/conkeror-web-browsing-emacs-way.html (org integration)
// https://github.com/bradx3/dotfiles/blob/master/.conkerorrc
// https://github.com/tommytxtruong/conkerorrc/
// http://conkeror.org/Tips
// https://github.com/gucong/conkerorrc
// https://github.com/vhallac/conkerorrc
// https://github.com/xtaran/conkerorrc

// {{{ Defuns

// Trick iCloud into thinking this is firefox (incompatible with Google)
//user_pref("general.useragent.compatMode.firefox", true);

function user_agent_switch () {
    // Get the "general.useragent.compatMode." branch
    var prefs = Components.classes["@mozilla.org/preferences-service;1"]
                    .getService(Components.interfaces.nsIPrefService);
    prefs = prefs.getBranch("general.useragent.compatMode.");
    
    var value = prefs.getBoolPref("firefox");
    prefs.setBoolPref("firefox", !value);
}

interactive("user-agent-switch",
	    "Switch user agent to Firefox",
	    user_agent_switch);

// Clear all caches
function clear_cache() {
    cache_clear(CACHE_ALL);
}

interactive("cache-clear",
	    "Clear all caches",
	    clear_cache);

// }}}

// Key-kill-mode - Attempt to fix tab completion in iPython Notebook
require("key-kill");
key_kill_mode.test.push(build_url_regexp($domain = "localhost"));

// {{{ Buffers

// Open external url links in new buffer
//url_remoting_fn = load_url_in_new_buffer;

// don't kill the last buffer in a window
//can_kill_last_buffer = false;

// }}}

// {{{ VIDEO - AUDIO
// external_content_handlers.set("video/*", "mplayer");
// external_content_handlers.set("audio/*", "dtach -n /tmp/ghoule mplayer");
// external_content_handlers.set("application/ogg", "dtach -n /tmp/harpye mplayer");
// external_content_handlers.set("application/x-ogg", "dtach -n /tmp/parque mplayer");

// }}}

// {{{ Preferences

//user_pref("general.useragent.override", "Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20100101 Firefox/13.0.1");

// Allow access to file:/// URIs
user_pref("capability.policy.policynames", "localfilelinks");
user_pref("capability.policy.localfilelinks.sites", "http://localhost:4000");
user_pref("capability.policy.localfilelinks.checkloaduri.enabled", "allAccess");

// user_pref("keyword.enabled", true);
// user_pref("keyword.URL", "http://www.google.com/search?ie=UTF-8&oe=utf-8&q=");

// Disable IPv6 for faster page loading
user_pref("network.dns.disableIPv6",true);

// }}}

// {{{ Page modes
// -----------
require("page-modes/wikipedia.js");
wikipedia_enable_didyoumean = true;

require("page-modes/google-search-results.js");
google_search_bind_number_shortcuts();

require("page-modes/duckduckgo.js");

// }}}

// {{{ Sessions
// ----------
require("session.js");
session_auto_save_auto_load = true;
// Breaks session-auto-save
//session_dir = make_file("/home/marduk/.conkerorrc/sessions");

// }}}

// {{{ Sensible defaults

homepage = "about:blank";

// Keep the found item selected after search mode ends
isearch_keep_selection = true;

// auto completion in the minibuffer
minibuffer_auto_complete_default = true;
url_completion_use_history = true; 
url_completion_use_bookmarks = true;

// view source in your editor
view_source_use_external_editor = true;

// }}}

// Bookmarks with Clark
// ---------------------
// http://code.ryuslash.org/cgit.cgi/clark/about/

// {{{ Stylesheets
// -------------
// Get more from: userstyles.org
let (sheet = get_home_directory()) {
    sheet.appendRelativePath(".conkerorrc/stylesheets/");
    sheet.append("flashblock.css");
    //sheet.append("zenburn.css");
    //sheet.append("dark.css");
    register_user_stylesheet(make_uri(sheet));
}

// }}}

// {{{ Protocol handlers
// ------------------
set_protocol_handler("magnet", find_file_in_path("transmission-gtk"));
set_protocol_handler("git", make_file("/home/marduk/.conkerorrc/git-protocol-handler.sh"));

// }}}

// {{{ Custom URIs

//Browser object for git URIs
define_browser_object_class(
    "git-uri",
    "Browser object for selecting Git URIs.",
    xpath_browser_object_handler("//a[starts-with(@href, 'git://')]"),
    $hint = "git:// URIs"
);

define_key(content_buffer_normal_keymap, "* g", "browser-object-git-uri");

// }}}

// {{{ Key-bindings

// -----------------
define_key(text_keymap, 'C-w', 'cmd_deleteWordBackward');
define_key(content_buffer_normal_keymap, "C-=", "zoom-in-text");
define_key(content_buffer_normal_keymap, "A-f", "follow-new-buffer-background");
define_key(content_buffer_normal_keymap, "C-f", "follow-new-buffer");
define_key(content_buffer_normal_keymap, "h", "home");
//define_key(content_buffer_normal_keymap, "A-w", "delete-window");
define_key(content_buffer_normal_keymap, "M-s", "session-load-window-current-replace");
define_key(content_buffer_normal_keymap, "C-;", "isearch-forward");

// }}}

// {{{ Modeline

//require("mode-line.js");

// funky icons in the modeline
// load_paths.unshift("chrome://conkeror-contrib/content/");
// require("mode-line-buttons.js");
// mode_line_add_buttons(standard_mode_line_buttons, true);

// we don't need a clock
remove_hook("mode_line_hook", mode_line_adder(clock_widget));

// Active download count
add_hook("mode_line_hook", mode_line_adder(downloads_status_widget));

// Proxy settings

function proxy_widget(window){
    this.class_name = "proxy-widget";
    text_widget.call(this, window);
    this.add_hook("select_buffer_hook");
}
proxy_widget.prototype = {
    constructor: proxy_widget,
    __proto__: text_widget.prototype,
    update: function(){
    	var proxy = get_pref("network.proxy.type");
    	this.view.text = proxy;
    }
};
 
add_hook("mode_line_hook", mode_line_adder(proxy_widget));

// }}}


// Local variables:
// mode: js
// End:
