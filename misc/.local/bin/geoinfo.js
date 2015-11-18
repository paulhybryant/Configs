#!/usr/bin/env node

var http = require('http');
// Need to npm link commander to make it available
var program = require('commander');

program
  .version('0.0.1')
  .option('-n, --nocache', 'Do not use cache')
  .option('-e, --nocn', 'Do not use sites in China to get location')
  .parse(process.argv);

if (program.nocache)
  console.log('nocache');

if (program.nocn) {
  var options = {
    host: 'ipinfo.io',
    path: ''
  };
} else {
  var options = {
    host: 'int.dpool.sina.com.cn',
    path: '/iplookup/iplookup.php?format=json'
  };
}

callback = function(response) {
  var str = '';

  //another chunk of data has been recieved, so append it to `str`
  response.on('data', function (chunk) {
    str += chunk;
  });

  //the whole response has been recieved, so we just print it out here
  response.on('end', function () {
    fs = require('fs');
    fs.writeFile('/tmp/.util.geoinfo', str)
  });
}

http.request(options, callback).end();
