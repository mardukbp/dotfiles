// Insert / instead of SPC when auto-completing in the minibuffer

function get_partial_completion_input_state (x, prefix_end, suffix_begin, orig_str) {
    if (suffix_begin < orig_str.length) {
        if (orig_str[suffix_begin] == " ")
            suffix_begin++;
        let sel = x.length + prefix_end + 1;
        return [orig_str.substring(0, prefix_end) + x + "/" + orig_str.substring(suffix_begin),
                sel, sel];
    } else {
        let sel = x.length + prefix_end;
        return [orig_str.substring(0, prefix_end) + x, sel, sel];
    }
}
