/*
 * A JS file for powering our ui
 */

var client = new Paho.MQTT.Client(Env.host, Env.port, Env.path, Env.clientId);

client.onMessageArrived = function(m) {
  $('.message').html(m.payloadString);
};

client.connect({
  userName: Env.username,
  password: Env.password,
  useSSL: true,
  mqttVersion: 3,
  onFailure: function(e) {
    console.log("FAIL!");
  },
  onSuccess: function() {
    console.log("WHoo!");
    client.subscribe(Env.topic);
  }
});


