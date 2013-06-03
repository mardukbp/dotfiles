// Downloads
// -----------
cwd = make_file("/media/Archivos/Downloads");
remove_hook("download_added_hook", open_download_buffer_automatically);

function suggest_save_path_from_file_name (file_name, buffer) {
    var cwd = with_current_buffer(buffer, function (I) I.local.cwd);
    var file = cwd.clone();
    for (let re in replace_map) {
        if (file_name.match(re)) {
            if (replace_map[re].path) {
                file = make_file(replace_map[re].path);
            }
            file_name = replace_map[re].transformer(file_name);
        }
    }
    file.append(file_name);
    return file.path;
}

var replace_map = {
    // ".": {
    //     "transformer": function (filename) {
    //         return filename.replace( /[\W ]+/g   , "-"   )
    //                        .replace( /^-+/       , ""    )
    //                        .replace( /-+$/       , ""    )
    //                        .replace( /-([^-]+)$/ , ".$1" )
    //                        .toLowerCase();
    //     }
    // },
    "\.torrent$": {
        "path": "/media/Archivos/Downloads/torrents/",
        "transformer": function (filename) {
            return filename;
        }
    },
    "\.djvu$": {
        "path": "/media/Archivos/Downloads/Libros/",
        "transformer": function (filename) {
            return filename;
        }
    }
};
