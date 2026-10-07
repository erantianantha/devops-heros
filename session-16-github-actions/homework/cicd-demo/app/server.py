"""HTTP wrapper so the calculator can run in a container: GET /add?a=1&b=2, /health."""
import json
from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import parse_qs, urlparse

from app.calculator import add, divide, multiply, subtract

OPS = {"add": add, "subtract": subtract, "multiply": multiply, "divide": divide}


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        url = urlparse(self.path)
        op = url.path.strip("/")
        if op == "health":
            return self.reply(200, {"status": "ok"})
        if op not in OPS:
            return self.reply(404, {"error": "use /add, /subtract, /multiply, /divide"})
        q = parse_qs(url.query)
        try:
            result = OPS[op](float(q["a"][0]), float(q["b"][0]))
        except (KeyError, ValueError) as e:
            return self.reply(400, {"error": str(e)})
        self.reply(200, {"op": op, "result": result})

    def reply(self, code, body):
        data = json.dumps(body).encode()
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        self.end_headers()
        self.wfile.write(data)


if __name__ == "__main__":
    HTTPServer(("0.0.0.0", 8000), Handler).serve_forever()
