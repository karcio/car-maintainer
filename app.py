import os
from flask import Flask, render_template, session, request
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import create_engine
import logging

#engine = create_engine("postgresql://dbuser1:pa88w0rd@172.17.0.2/carmanagerdb")

logging.basicConfig(
    format=' %(levelname)s - %(asctime)s - %(message)s ', level=logging.DEBUG)

db = SQLAlchemy()

app = Flask(__name__)
app.config["SQLALCHEMY_DATABASE_URI"] = "postgresql://dbuser1:pa88w0rd@172.17.0.2/carmanagerdb"
db.init_app(app)


class fuel(db.Model):
    fuelid = db.Column('id', db.Integer, primary_key=True)
    fueltype = db.Column(db.String(10))

    def __init__(self, fuelid, fueltype):
        self.fuelid = fuelid
        self.fueltype = fueltype


class cars(db.Model):
    carid = db.Column('id', db.Integer, primary_key=True)
    brand = db.Column(db.String(10))
    typename = db.Column(db.String(10))
    engine = db.Column(db.Integer)
    year = db.Column(db.String(4))
    carowner = db.Column(db.String(10))
    fuelid = db.Column(db.Integer)

    def __init__(self, carid, brand, typename, engine, year, carowner, fuelid):
        self.carid = carid
        self.brand = brand
        self.typename = typename
        self.engine = engine
        self.year = year
        self.carowner = carowner
        self.fuelid = fuelid


class fuel_log(db.Model):
    fuellogid = db.Column('id', db.Integer, primary_key=True)
    carid = db.Column(db.Integer)
    fuel = db.Column(db.Float(4))
    odometer = db.Column(db.Float(4))
    petrolcost = db.Column(db.Float(4))
    currentdate = db.Column(db.String(10))
    notes = db.Column(db.Integer)

    def __init__(self, fuellogid, carid, fuel, odometer, petrolcost, currentdate, notes):
        self.fuellogid = fuellogid
        self.carid = carid
        self.fuel = fuel
        self.odometer = odometer
        self.petrolcost = petrolcost
        self.currentdate = currentdate
        self.notes = notes


with app.app_context():
    db.create_all()


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
