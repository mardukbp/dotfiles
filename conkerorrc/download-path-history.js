// Use parent path in history entries and current filename to
// construct the new save path suggestion.  Use M-n, M-p to browse
// through them as usual history browsing.

function content_handler_save (ctx) {
    var suggested_path = suggest_save_path_from_file_name(
        ctx.launcher.suggestedFileName, ctx.buffer);
    var file = yield ctx.window.minibuffer.read_file_check_overwrite(
        $prompt = "Save as:",
        $initial_value = suggested_path,
        $history = "save",
        $select);
    register_download(ctx.buffer, ctx.launcher.source);
    ctx.launcher.saveToDisk(file, false);
}

function minibuffer_history_next (window, count) {
    var m = window.minibuffer;
    var s = m.current_state;
    if (!(s instanceof text_entry_minibuffer_state))
        throw new Error("Invalid minibuffer state");
    if (!s.history || s.history.length == 0)
        throw interactive_error("No history available.");
    if (count == 0)
        return;
    var index = s.history_index;
    if (count > 0 && index == -1)
        throw interactive_error("End of history; no next item");
    else if (count < 0 && index == 0)
        throw interactive_error("Beginning of history; no preceding item");
    if (index == -1) {
        s.saved_last_history_entry = m._input_text;
        index = s.history.length + count;
    } else
        index = index + count;

    if (index < 0)
        index = 0;

    if (s.prompt == "Save as:") {
        let leaf = make_file(m._input_text).leafName;
        let file;
        m._restore_normal_state();
        if (index >= s.history.length) {
            index = -1;
            file = make_file(s.saved_last_history_entry).parent;
            file.append(leaf);
            m._input_text = file.path;
        } else {
            file = make_file(s.history[index]).parent;
            file.append(leaf);
            m._input_text = file.path;
        }
    }
    else {
        m._restore_normal_state();
        if (index >= s.history.length) {
            m._input_text = s.saved_last_history_entry;
        } else {
            m._input_text = s.history[index];
        }
    }
    s.history_index = index;
    m._set_selection();
    s.handle_input();
}
