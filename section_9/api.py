import os
import json
from flask import Flask, jsonify
from flask_cors import cross_origin

app = Flask(__name__)

FSDB_ROOT = os.environ['fsdb_root']


@app.route("/comics/", methods=['GET'])
@cross_origin()
def getComics():
    comics = [
        {'id': f, 'comic_name': f}
        for f in sorted(os.listdir(FSDB_ROOT))
    ]

    return jsonify(comics)


@app.route("/<comic_id>", methods=['GET'])
@cross_origin()
def getEpisodes(comic_id: str):
    episodes = [
        {'id': os.path.join(comic_id, f), 'episode_name': f.split('.')[0]}
        for f in sorted(os.listdir(os.path.join(FSDB_ROOT, comic_id)))
    ]

    return jsonify(episodes)


@app.route("/<comic_id>/<episode_id>", methods=['GET'])
@cross_origin()
def getImages(comic_id: str, episode_id: str):
    with open(os.path.join(FSDB_ROOT, comic_id, episode_id), 'r') as src:
        images = [
            {'image_url': i}
            for i in json.load(src)['image_urls']
        ]

    return jsonify(images)


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
