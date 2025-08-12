/*
 * A JS file for making jquery based forms
 * easier to work with.
 */

function rand(min, max) {
  min = Math.ceil(min);
  max = Math.floor(max);
  return Math.floor(Math.random() * (max - min) + min);
}

function token(len) {
  var text = "";
  for(var i = 0; i < len; i++) {
    var c = String.fromCharCode(rand(0, 26) + 65);
    text += c;
  }
  return text;
}

function randDob() {
  return rand(1,12) + "/" + rand(1,29) + "/" + ((new Date().getYear()) - rand(10, 70));
}

function dateify(numDays) {
  var t = new Date((new Date()).getTime() + (numDays * 24 * 60 * 60 * 1000));
  var p = function(x) { return x < 10 ? "0" + x : x; };
  return t.getFullYear() + "-" + p(t.getMonth() + 1) + "-" + p(t.getDate());
}

function randPhone() {
  return rand(200,799) + "-" + rand(200,999) + "-" + rand(1000,9999);
}

function randomOption(selector) {
  const $ = window.$ ? window.$ : window.jQuery;
  var all = $(selector).find('option').toArray().filter(function(o) {
    return $(o).attr('value') != '';
  });
  var index = rand(0, all.length);
  return $(all[index]).val();
}

function S(name, val) {
  const $ = window.$ ? window.$ : window.jQuery;
  var elt = $('*[name="' + name + '"]');
  if(val == '*') {
    $(elt).val(randomOption(elt));
  } else if($(elt).attr('type') == 'checkbox') {
    $(elt).prop('checked', val);
  } else {
    $(elt).val(val);
  }

  $(elt).change();
}
