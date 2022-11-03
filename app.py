import os
from flask import Flask, render_template, session, request
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import Table, create_engine
import logging


engine = create_engine("postgresql://dbuser1:pa88w0rd@172.17.0.2/carmanagerdb")

logging.basicConfig(
    format=' %(levelname)s - %(asctime)s - %(message)s ', level=logging.DEBUG)

db = SQLAlchemy()

app = Flask(__name__)
app.config["SQLALCHEMY_DATABASE_URI"] = "postgresql://dbuser1:pa88w0rd@172.17.0.2/carmanagerdb"
db.init_app(app)


class Users(db.Model):
    userid = db.Column('userid', db.Integer, primary_key=True)
    user = db.Column(db.String(10))
    password = db.Column(db.String(24))

    def __init__(self, userid, user, password):
        self.userid = userid
        self.user = user
        self.password = password


class Fuel(db.Model):
    fuelid = db.Column('fuelid', db.Integer, primary_key=True)
    fueltype = db.Column(db.String(10))

    def __init__(self, fuelid, fueltype):
        self.fuelid = fuelid
        self.fueltype = fueltype


class Cars(db.Model):
    carid = db.Column('carid', db.Integer, primary_key=True)
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


class Fuel_log(db.Model):
    fuellogid = db.Column('fuellogid', db.Integer, primary_key=True)
    carid = db.Column(db.Integer)
    fuel = db.Column(db.Float(4))
    odometer = db.Column(db.Float(4))
    petrolcost = db.Column(db.Float(4))
    currentdate = db.Column(db.DateTime(timezone=True))
    notes = db.Column(db.String(100))

    def __init__(self, fuellogid, carid, fuel, odometer, petrolcost, currentdate, notes):
        self.fuellogid = fuellogid
        self.carid = carid
        self.fuel = fuel
        self.odometer = odometer
        self.petrolcost = petrolcost
        self.currentdate = currentdate
        self.notes = notes


class Maintanance_type(db.Model):
    maintananceid = db.Column('maintananceid', db.Integer, primary_key=True)
    fix = db.Column(db.String(20))
    wash = db.Column(db.String(20))
    shop = db.Column(db.String(20))
    replacement = db.Column(db.String(20))

    def __init__(self, maintananceid, fix, wash, shop, replacement):
        self.maintananceid = maintananceid
        self.fix = fix
        self.wash = wash
        self.shop = shop
        self.replacement = replacement


class Maintanance_log(db.Model):
    maintlogid = db.Column('maintlogid', db.Integer, primary_key=True)
    maintananceid = db.Column(db.Integer)
    carid = db.Column(db.Integer)
    issue = db.Column(db.String(20))
    issue_cost = db.Column(db.String(20))
    currentdate = db.Column(db.DateTime(timezone=True))
    notes = db.Column(db.String(100))

    def __init__(self, maintlogid, maintananceid, carid, issue, issue_cost, currentdate, notes):
        self.maintlogid = maintlogid
        self.maintananceid = maintananceid
        self.carid = carid
        self.issue = issue
        self.issue_cost = issue_cost
        self.currentdate = currentdate
        self.notes = notes


class Consumption_cost(db.Model):
    concostid = db.Column('concostid', db.Integer, primary_key=True)
    carid = db.Column(db.Integer)
    consumption = db.Column(db.Float(4))
    cost = db.Column(db.Float(4))
    currentdate = db.Column(db.DateTime(timezone=True))

    def __init__(self, concostid, carid, consumption, cost, currentdate):
        self.concostid = concostid
        self.carid = carid
        self.consumption = consumption
        self.cost = cost
        self.currentdate = currentdate


class Maintenance_cost(db.Model):
    maincostid = db.Column('maincostid', db.Integer, primary_key=True)
    carid = db.Column(db.Integer)
    issue = db.Column(db.Float(4))
    cost = db.Column(db.Float(4))
    currentdate = db.Column(db.DateTime(timezone=True))

    def __init__(self, concostid, carid, issue, cost, currentdate):
        self.concostid = concostid
        self.carid = carid
        self.issue = issue
        self.cost = cost
        self.currentdate = currentdate


with app.app_context():
    db.create_all()
    logging.info('Database structure rebuild')


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


@app.route("/users")
def user_list():
    if not session.get('logged_in'):
        logging.info("Render login page")
        return render_template('login.html')
    else:
        logging.info("Render user page")
        users = db.session.execute(
            db.select(Users).order_by(Users.user)).scalars()
        return render_template("users.html", users=users)


@app.route("/fuel")
def fuel_list():
    if not session.get('logged_in'):
        logging.info("Render login page")
        return render_template('login.html')
    else:
        logging.info("Render fuel page")
        fuel = db.session.execute(
            db.select(Fuel).order_by(Fuel.fuelid)).scalars()
        return render_template("fuel.html", fuel=fuel)


@app.route("/cars")
def cars_list():
    if not session.get('logged_in'):
        logging.info("Render login page")
        return render_template('login.html')
    else:
        logging.info("Render cars page")
        cars = db.session.execute(
            db.select(Cars).order_by(Cars.brand)).scalars()
        return render_template('cars.html', cars=cars)


if __name__ == '__main__':
    app.secret_key = os.urandom(12)
    app.run(debug=True, host='0.0.0.0', port=5000)
    # SSL
    #app.run(debug=False, host='0.0.0.0', port=5000, ssl_context=('/etc/letsencrypt/live/your-domain/fullchain.pem', '/etc/letsencrypt/live/your-domain/privkey.pem'))
