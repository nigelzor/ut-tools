#!/usr/bin/env node
'use strict'

var os = require('os');
var path = require('path');
var http = require('http');
var connect = require('connect');
var parseurl = require('parseurl');
var morgan = require('morgan');
var serveStatic = require('serve-static');
var fs = require('fs');

var port = process.env.PORT || 3000;
var host = process.env.HOSTNAME || (localIp() + ':' + port);
var dir = process.env.UT_HOME || path.join(process.env.HOME, 'Programs/UnrealTournament/drive_c/UnrealTournament');

try {
	fs.statSync(dir);
} catch (e) {
	console.log(e + '\nSet UT_HOME to your Unreal Tournament folder');
	process.exit(1);
}

try {
	var ini = path.join(dir, 'System', 'UnrealTournament.ini');
	var content = fs.readFileSync(ini, 'utf8')
		.replace(/^RedirectToURL=.*$/m, "RedirectToURL=http://" + host + "/files/")
		.replace(/^UseCompression=True$/m, "UseCompression=False");
	fs.writeFileSync(ini, content);
} catch (e) {
	console.log('Failed to update UnrealTournament.ini\n' + e);
}

function localIp() {
	var ifaces = os.networkInterfaces();
	for (var name in ifaces) {
		var iface = ifaces[name];
		for (var i = 0; i < iface.length; i++) {
			var address = iface[i];
			if (address.family === 'IPv4' && !address.internal) {
				return address.address;
			}
		}
	}
	return '127.0.0.1';
}

var app = connect();

app.use(morgan('combined'));

var mapping = {
	'.unr': serveStatic(path.join(dir, 'Maps')),
	'.u':   serveStatic(path.join(dir, 'System')),
	'.uax': serveStatic(path.join(dir, 'Sounds')),
	'.utx': serveStatic(path.join(dir, 'Textures')),
	'.umx': serveStatic(path.join(dir, 'Music')),
};

app.use('/files', function (req, res, next) {
	var file = parseurl(req).pathname;
	var ext = path.extname(file);
	var mapped = mapping[ext];
	if (mapped) {
		mapped(req, res, next);
	} else {
		next();
	}
});

function nope(res, code) {
	var msg = "<h2>" + code + " " + http.STATUS_CODES[code] + "</h2>\n";
	res.statusCode = code;
	send(res, msg);
}

function send(res, msg) {
	res.setHeader('Content-Type', 'text/html; charset=UTF-8');
	res.setHeader('Content-Length', Buffer.byteLength(msg));
	res.end(msg);
}

app.use(function (req, res) {
	if (req.url === '/') {
		var msg = "<h2>System/UnrealTournament.ini</h2>\n" +
			"<pre>" +
			"[IpDrv.HTTPDownload]\n" +
			"RedirectToURL=http://" + host + "/files/\n" +
			"ProxyServerHost=\n" +
			"ProxyServerPort=3128\n" +
			"UseCompression=False\n" +
			"</pre>\n";
		send(res, msg);
	} else {
		nope(res, 404);
	}
});


var server = app.listen(port);

console.log('listening on port', port);
