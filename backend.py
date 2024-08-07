from flask import Flask
from flask import request
import json

def getWorkoutsFilename(instId):
    return "./workouts/workouts_%s.txt" % instId

def getWorkouts(instId):
    try:
        with open(getWorkoutsFilename(instId), 'r') as file:
            data = file.read()
            if data:
                return data
    except:
        pass
    return "[]"

def upsertWorkout(instId, workout):
    workouts = json.loads(getWorkouts(instId))
    workouts = list(filter(lambda item: item['id'] != workout['id'], workouts))
    workouts.append(workout)
    with open(getWorkoutsFilename(instId), 'w+') as file:
        file.write(json.dumps(workouts))

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello from Flask!'

@app.route('/workouts')
def get_workouts():
    if 'installationId' in request.headers:
        instId = request.headers['installationId']
        return getWorkouts(instId)
    return '[]'

@app.route('/workout', methods = ['POST'])
def upsert_workouts():
    if 'installationId' in request.headers:
        instId = request.headers['installationId']
        workout = json.loads(request.data)
        upsertWorkout(instId, workout)
        return 'ok'
    return 'error'

# curl --header "installationId: 123456-6789" https://woko.pythonanywhere.com/workouts
# curl --header "installationId: 123456-6789" -X POST --data '{"username":"xyz","password":"xyz"}' https://woko.pythonanywhere.com/workout
