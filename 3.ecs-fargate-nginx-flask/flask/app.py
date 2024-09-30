from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/')
def hello():
	return "Hello World!"

@app.route('/cache-me')
def cache():
	return "nginx will cache this response"

@app.route('/info')
def info():

	# print("request.headers: ", request.headers)

	resp = {
		'connecting_ip': request.headers.get('X-Real-IP'),
		'proxy_ip': request.headers.get('X-Forwarded-For'),
		'host': request.headers.get('Host'),
		'user-agent': request.headers.get('User-Agent')
	}

	return jsonify(resp)

@app.route('/flask-health-check')
def flask_health_check():
	return "success"