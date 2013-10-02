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
function ebib_import_bibtex (url) {
    var cmd_str = 'emacsclient -ne \'(ebib-import-bibtex \"' + url + '\")\'';
    shell_command_blind(cmd_str);
}

interactive("bibtex2ebib", "Download PDF and add bibtex entry for current preprint to ebib",
            function (I) {
		ebib_import_bibtex(I.buffer.display_uri_string);
            });

define_key(content_buffer_normal_keymap, "C-c f", "bibtex2ebib");

