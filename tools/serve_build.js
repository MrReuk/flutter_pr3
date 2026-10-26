const http = require('node:http');
const fs = require('node:fs');
const path = require('node:path');

const PORT = Number(process.argv[2] || 5556);
const API_PORT = Number(process.argv[3] || 8080);
const ROOT = path.resolve(process.argv[4] || path.join(__dirname, '..', 'build', 'web'));

const TYPES = {
  '.html': 'text/html; charset=utf-8',
  '.js': 'text/javascript; charset=utf-8',
  '.mjs': 'text/javascript; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.wasm': 'application/wasm',
  '.png': 'image/png',
  '.ico': 'image/x-icon',
  '.otf': 'font/otf',
  '.ttf': 'font/ttf',
  '.woff2': 'font/woff2',
  '.txt': 'text/plain; charset=utf-8',
};

function sendFile(res, file) {
  res.writeHead(200, {
    'Content-Type': TYPES[path.extname(file)] || 'application/octet-stream',
    'Cache-Control': 'no-store',
  });
  fs.createReadStream(file).pipe(res);
}

const server = http.createServer((req, res) => {
  if (req.url.startsWith('/api')) {
    const upstream = http.request(
      { host: 'localhost', port: API_PORT, path: req.url, method: req.method, headers: req.headers },
      (answer) => {
        res.writeHead(answer.statusCode, answer.headers);
        answer.pipe(res);
      },
    );
    upstream.on('error', () => req.socket.destroy());
    req.pipe(upstream);
    return;
  }

  const clean = decodeURIComponent(req.url.split('?')[0]);
  const file = path.join(ROOT, clean);
  if (!file.startsWith(ROOT)) {
    res.writeHead(403);
    res.end();
    return;
  }
  fs.stat(file, (error, stat) => {
    if (!error && stat.isFile()) return sendFile(res, file);
    sendFile(res, path.join(ROOT, 'index.html'));
  });
});

server.listen(PORT, () => {
  console.log('Приложение: http://localhost:' + PORT + ' (папка ' + ROOT + '), запросы /api уходят на порт ' + API_PORT);
});
