(function(){
    e = document.createElement('label');
    e.id = 'liberator-status-zotero-collection';
    e.style.fontWeight = 'bold';
    document.getElementById('liberator-status').appendChild(e);

    statusline.addField('zotero-collection', 'Currently selected collection in Zotero', 'liberator-status-zotero-collection', function (node, state) {
            if (state) {
                node.value = '';
            } else {
                if (typeof(ZoteroPane.getSelectedCollection().name) != 'undefined') {
                    node.value = ZoteroPane.getSelectedCollection().name;
                } else {
                    node.value = '';
                }
            }
    });
            
    function updateZoteroCollection () {
        state = (typeof(ZoteroPane) === 'undefined') ? true : false;
        statusline.updateField('zotero-collection', state);
    };

    autocommands.add('LocationChange', '.*', updateZoteroCollection);

    options.status += ',zotero-collection'

})();
