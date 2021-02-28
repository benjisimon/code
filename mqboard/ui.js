/*
 * A JS file for powering our ui
 */

var client = new Paho.MQTT.Client(Env.host, Env.port, Env.path, Env.clientId);

client.onConnectionLost = function() {
  $('.status').html("Connection Lost");
}

client.onMessageArrived = function(m) {
  $('.status').html("Message Arrived");
  var p = JSON.parse(m.payloadString);
  $('.message').html(p.message);
  $('.seq').html(p.sequence);
};

try {
  client.connect({
    userName: Env.username,
    password: Env.password,
    useSSL: true,
    mqttVersion: 3,
    onFailure: function(e) {
      $('.status').html("Connection Failed");
      $('.message').html(JSON.stringify(e));
    },
    onSuccess: function() {
      $('.status').html("Connection Success");
      client.subscribe(Env.topic);
    }
  });
} catch(ex) {
  $('.status').html("Connection Error");
}

