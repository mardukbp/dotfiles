(function(){

  e = document.createElement('label');
  e.id = 'liberator-status-spdy';
  e.style.fontWeight = 'bold'
  document.getElementById('liberator-status').appendChild(e);

  statusline.addField('spdy', 'The currently SPDY status', 'liberator-status-spdy', function (node, state) {
    if (state) {
      node.value = '\u26A1';
    } else {
      node.value = '';
    }
  });

  function updateSPDYState () {
    state = (gBrowser.getBrowserForTab(gBrowser.selectedTab).contentDocument.__SPDY) ? true : false;
    statusline.updateField('spdy', state);
  }

  autocommands.add('LocationChange', '.*', updateSPDYState);

  let observer = {
    observe: function(subject, topic, data) {
      let httpChannel = subject.QueryInterface(Ci.nsIHttpChannel);
      let tab = getTabFromHttpChannel(httpChannel);
      if (topic != 'http-on-examine-response') return;
      try {
        if (subject.getResponseHeader('X-Firefox-Spdy')) {
          gBrowser.getBrowserForTab(tab).contentDocument.__SPDY = true;
          updateSPDYState();
        }
      } catch (e) {}
    }
  }

  Cc['@mozilla.org/observer-service;1'].getService(Ci.nsIObserverService).addObserver(observer, 'http-on-examine-response', false);

  options.status += ',spdy'

  // Firefoxアドオンでちょっとコアにタブを扱う - 遙かへのスピードランナー - http://d.hatena.ne.jp/thorikawa/20090214/p1
  function getTabFromHttpChannel (httpChannel) {
    var tab = null;
    if (httpChannel.notificationCallbacks) {
      var interfaceRequestor = httpChannel.notificationCallbacks
          .QueryInterface(Ci.nsIInterfaceRequestor);
      try {
        var targetDoc = interfaceRequestor.getInterface(Ci.nsIDOMWindow).document;
      } catch (e) {
        return;
      }
      var webNav = httpChannel.notificationCallbacks.getInterface(Ci.nsIWebNavigation);
      var mainWindow = webNav.QueryInterface(Ci.nsIDocShellTreeItem)
          .rootTreeItem.QueryInterface(Ci.nsIInterfaceRequestor)
          .getInterface(Ci.nsIDOMWindow);

      var gBrowser = mainWindow.getBrowser();
      var targetBrowserIndex = gBrowser.getBrowserIndexForDocument(targetDoc);
      if (targetBrowserIndex != -1) {
        tab = gBrowser.tabContainer.childNodes[targetBrowserIndex];
      }
    }
    return tab;
  };

})();
// vim: ts=2 sw=2 et