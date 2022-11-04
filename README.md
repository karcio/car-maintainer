# car-maintainer


## Clone repository
```
git clone git@github.com:karcio/car-maintainer.git
```

## Create an environment
```
cd car-maintainer
python3 -m venv venv
```

## Activate the environment
```
source venv/bin/activate
```

## Install requirements
```
pip install -r requirements.txt
```

## create file `.flaskenv` in root folder with sample content:
```
FLASK_APP=app
FLASK_DEBUG=0
```
## Run app
```
flask run
```