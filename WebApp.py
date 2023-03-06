from flask import Flask
import socket

app = Flask(__name__)

@app.route("/")
def ip():
    local_ip = socket.gethostbyname(socket.gethostname())
    return "[+] Your local IP is :" + local_ip
if __name__ == '__main__':
    app.run(host='0.0.0.0',port=5000)
