import os
from flask import Flask, render_template, session, request
import logging

logging.basicConfig(
    format=' %(levelname)s - %(asctime)s - %(message)s ', level=logging.DEBUG)

app = Flask(__name__)


@app.route('/', methods=['GET'])
def home():
    if not session.get('logged_in'):
        logging.info("Render login page")
        return render_template('login.html')
    else:
        logging.info("Render home page")
        return render_template('index.html')


@app.route('/login', methods=['POST'])
def appLogin():

    if request.form['password'] == "pass" and request.form['username'] == "user":
        session['logged_in'] = True
        logging.info('Loging success')
    else:
        logging.error('Login denied - wrong credentials')
    return home()


@app.route("/logout")
def logout():
    session['logged_in'] = False
    return home()


if __name__ == '__main__':
    app.secret_key = os.urandom(12)
    app.run(debug=True, host='0.0.0.0', port=5000)
    # SSL
    #app.run(debug=False, host='0.0.0.0', port=5000, ssl_context=('/etc/letsencrypt/live/your-domain/fullchain.pem', '/etc/letsencrypt/live/your-domain/privkey.pem'))
