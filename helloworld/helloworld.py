import os
from flask import Flask

application = Flask(__name__)
application.config['DEBUG'] = False


@application.route("/")
def hello():
    return "\
        <h1>Hello World!</h1>\
        <ul><li>Load balanced pod IP: {}</li>\
        <li>Load balanced pod name: {}</li>\
        <li>Load balanced pod namespace: {}</li></ul>".format(
        os.getenv("POD_IP", "Not Available"),
        os.getenv("POD_NAME", "Not Available"),
        os.getenv("POD_NAMESPACE", "Not Available")
    )


@application.route("/health")
def health():
    return "200 OK!"


if __name__ == "__main__":  # pragma: no cover
    application.run(host='0.0.0.0')
