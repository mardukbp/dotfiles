(function(){
    const ENABLE_ICON = 'data:image/png;base64,'
      + 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAIAAACQkWg2AAAABnRSTlMA/wAAAIBJekM9AAAB'
      + 'mElEQVR4nIWS3StDYRzHv895njOvaWy4WWPJcquE8nIrbSW54mrGjWsppbQtCuXajZd/QDKs'
      + 'UNxoLpYbKc1b2zm4mJ2NsGPNOC6OnHXGfO+eb8/neX6fp4e43aNWax3+iCgKK6uW3IZZrXXT'
      + '01OEkPzdiqL4fLPja04Al6H97aU3AAwAIcTmmMsHIoFJAIvDfgDja31Y8n8Dapw97cUGSilH'
      + 'CUlnshuB41+H1IDMJ5QsMb2cc3LMALha4fXOAPB6KIAKYcfroaIoaMBTKltaSqvlWGElDQgd'
      + 'nwBwtf6jxFRUXQDfYxRQYqIo+Hyz+eepSm/y+3MqI6czmvTVdbh/wGFvbBJuI2ZT9dbmbq4S'
      + '4w3l5ZTjOA1wOHuNxkrhNsIYLyXiOqX8MADBYFD3Gj9Kuh4AUeDJbUfcd4W/FhtbbEmfrT9+'
      + 'lJ0eBSJRl05JSsTNphop8WCrbwiHzw8O92j34EQtiZU1D7XZSpYtF51dHXa7XUrGGeNfUy8c'
      + 'x6XkV57xiaRUZawyFPFMTt4no9HHm2X1hvkFvZIuXyp4v/YfvuEoAAAAAElFTkSuQmCC';

    const DISABLE_ICON = 'data:image/png;base64,'
      + 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAIAAACQkWg2AAAABnRSTlMA/wAAAIBJekM9AAAB'
      + 'i0lEQVR4nH2SwUoCURSG/7lzZwJxYWqtRItQwm3LbCkStol8gLAW9QzB4AgW9QIJWc8QgVBI'
      + '7RQ3bsOmQGdsY466aCZ1RGwxksNo/rt7uN+55ztcJpk89vsD+CeKIt/e+awV6vcHBOGMYZjZ'
      + '2+PxOJ3OZK+9ACqVyk3OB4ACYBgmGo3OAoVCAcDJaRNA9noLueYEMBOLxXieZ1mWEDIYDPL5'
      + '/Nwhp8BoNBoOh71er9/vA4hEIqIoAqyYYgGgqYopVlHkKaBpmsPhMAxDEIQFSlOgXC6bjRcr'
      + 'URM1DwBEUVysRBVFTqczlkasVUnXdU3TTKsJ8P5R3T+Ih4KbcqPm9aw83D9alSilTqeTEDIF'
      + '4nu7Ltey3KhRyqntlk1p/lqLxaJtG39KtjoAZoyUtXqU/Fz8tejFOS9JkmEYpVKpVj+0Kant'
      + 'ltezqra/1tc2qtXX55cnNpFIcBwXDoeDwWDO9xbZ2Q6FQmqnRSmn6d+EEP1H4yjX7qhul5tf'
      + '4mi3263X65IkmS9cXtmVbPkFaGbHAxyF/18AAAAASUVORK5CYII=';

    e = document.createElement('label');
    e.setAttribute('id', 'liberator-status-proxy');
    e.setAttribute('src', DISABLE_ICON);
    var statusbar = document.getElementById('liberator-status');
    statusbar.appendChild(e);

    statusline.addField('proxy-indicator', 'Whether proxy is on or off', 'liberator-status-proxy', function (node, state) {
            indicator = document.getElementById('liberator-status-proxy');
            if (state) {
                //node.setAttribute('src', ENABLE_ICON);
                indicator.setAttribute('src', ENABLE_ICON);
            } else {
                //node.setAttribute('src', DISABLE_ICON);
                indicator.setAttribute('src', DISABLE_ICON);
            }
    });
            
    function updateProxyIndicator () {
        state = (options.getPref('network.proxy.type') == 0) ? false : true;
        statusline.updateField('proxy-indicator', state);
    };

    autocommands.add('LocationChange', '.*', updateProxyIndicator);

    options.status += ',proxy-indicator'

})();
