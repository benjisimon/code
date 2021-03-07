/*
 * A JS file for powering our ui
 */

var client = new Paho.MQTT.Client(Env.host, Env.port, Env.path, Env.clientId);

function fontFamily() {
  var max = Env.fonts.length;
  var index = Math.floor(Math.random() * Math.floor(max));
  return Env.fonts[index];
}

function renderMessage(text) {
  var p = JSON.parse(text);
  var ff = fontFamily();
  $('.message').css('font-family', ff).html(p.message);
  $('.seq').html(p.sequence + " / " + ff);
}

function renderStatus(m) {
  $('.status').html(m);
  console.log("status: ", m);
}

client.onConnectionLost = function(rs) {
  renderStatus("Lost Connection: " + rs.errorMessage);
}

client.onMessageArrived = function(m) {
  renderStatus("Message Arrived");
  Cookies.set('last_message', m.payloadString, {expires: 365});
  renderMessage(m.payloadString);
};

try {
  client.connect({
    userName: Env.username,
    password: Env.password,
    useSSL: true,
    mqttVersion: 3,
    onFailure: function(e) {
      renderStatus("Connection Failed");
      $('.message').html(JSON.stringify(e));
    },
    onSuccess: function() {
      renderStatus("Connection Success");
      client.subscribe(Env.topic);
      var m = Cookies.get('last_message');
      if(m) {
        renderMessage(m);
      }
    }
  });
} catch(ex) {
  renderStatus("Connection Error: " + ex);
}

