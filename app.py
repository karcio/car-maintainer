from flask import Flask, render_template
from flask_login import LoginManager

app = Flask(__name__)
login_manager = LoginManager()


@app.route("/")
def main_app():
    return render_template('index.html')
