/* -*- mode: javascript -*-
 *
 * Google Sheets Script Editor version of the sun-position code
 */
/*
* See:
* http://www.blogbyben.com/2019/01/go-towards-light-direction-and-time.html
* https://github.com/benjisimon/code/blob/master/programming-praxis/sun-position.scm
* for an explanation as to what this is all about.
*/

eval(UrlFetchApp.fetch('https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment.js').getContentText());

function solarPosition(lat, lng, ts, tzOffset) {
  var doy = moment(ts).dayOfYear();
  var hod = moment(ts).hour() + (moment(ts).minute() / 60);
  var tz  = tzOffset === undefined ? (moment(ts).utcOffset() / 60) : tzOffset;
  
  var usingDegrees = function(fn) {
    return function(dd) { return fn(dd * 0.0174533); };
  }
  var toDegrees = function(fn) {
    return function(v) { return fn(v) * 57.2958; };
  }
  
  var cos = usingDegrees(Math.cos);
  var sin = usingDegrees(Math.sin);
  var tan = usingDegrees(Math.tan);
  var acos = toDegrees(Math.acos);
  var asin = toDegrees(Math.asin);
  var atan = toDegrees(Math.atan);
  
  var lstm = tz * 15;
  
  var eot = (function() {
    var b = (360 / 365) * (doy - 81);
    return (9.87 * sin(2*b)) -
           (7.53 * cos(b)) -
           (1.5 * sin(b));
  })();
  
  var tcf = (4 * (lng - lstm)) + eot;
  var lst = hod + (tcf / 60);
  var hra = 15 * (lst - 12);
    
  var d = 23.45 * sin((360/365) * (doy - 81));
  
  var e = asin(((sin(d)) * sin(lat)) +
               ((cos(d)) * cos(lat) * cos(hra)));
  
  var a = (function() {
    var a = acos(((sin(d) * cos(lat)) - (cos(d) * sin(lat) * cos(hra))) /
                 (cos(e)));
    return hra < 0 ? a : (360 - a);
  })();
  
  var sr = 12 - (((1/15) * acos(-1 * tan(lat) * tan(d)))) - (tcf / 60);
  var ss = 12 + (((1/15) * acos(-1 * tan(lat) * tan(d)))) - (tcf / 60);
  
  return {
    elevation: e,
    azimuth: a,
    sunrise: sr / 24,
    sunset: ss / 24,
  };
}


/**
 * Elevation of the sun
 *
 * @param lat latitude of interest
 * @param lng longitude of interest
 * @param ts timestamp
 * @param tzOffset optional timezone offset from UTC. 
 * @return elevation in degrees
 * @customfunction
 */
function elevation(lat, lng, ts, tzOffset) {
  return solarPosition(lat, lng, ts, tzOffset).elevation;
}

/**
 * Azimuth (compass direction) of the sun
 *
 * @param lat latitude of interest
 * @param lng longitude of interest
 * @param ts timestamp
 * @param tzOffset optional timezone offset from UTC. 
 * @return azimuth in degrees
 * @customfunction
 */
function azimuth(lat, lng, ts, tzOffset) {
  return solarPosition(lat, lng, ts, tzOffset).azimuth;
}

/**
 * Sunrise
 *
 * @param lat latitude of interest
 * @param lng longitude of interest
 * @param ts timestamp
 * @param tzOffset optional timezone offset from UTC. 
 * @return sunrise as Google Sheets time
 * @customfunction
 */
function sunrise(lat, lng, ts, tzOffset) {
  return solarPosition(lat, lng, ts, tzOffset).sunrise;
}

/**
 * Sunset
 *
 * @param lat latitude of interest
 * @param lng longitude of interest
 * @param ts timestamp
 * @param tzOffset optional timezone offset from UTC. 
 * @return sunset as Google Sheets time
 * @customfunction
 */
function sunset(lat, lng, ts, tzOffset) {
  return solarPosition(lat, lng, ts, tzOffset).sunset;
}
