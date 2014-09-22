(function(){
    var collections = Zotero.getCollections();
    var coll_name = [];

    for (c in collections) {
        var id = collections[c].id;
        coll_name.push([collections[c].name + ' ' + '(' + String(id) + ')']);
    }

    commands.addUserCommand(['zc'], 'Select Zotero collection',
            function(args) {
                var regExp = /\(([^)]+)\)/;
                var id_num = regExp.exec(args);
                id_num = parseInt(id_num[1],10);
                // _collectionRowMap is only defined when
                // ZoteroOverlay.toggleDisplay(true)
                var row = ZoteroPane.collectionsView._collectionRowMap[id_num];
                ZoteroPane.collectionsView.selection.select(row);
                statusline.updateField('zotero-collection',false);
                //liberator.echo(id_num[1]);
            }, {
                completer: function(context, arg) {
                    context.title = ['Name'];
                    context.completions = coll_name; //array of arrays
                }
            });
    //TODO: Add Smart Completion using vimperator/content/config.js 258:298

})();
