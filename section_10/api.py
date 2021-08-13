import os
import json
from flask import Flask, jsonify

app = Flask(__name__)

FSDB_ROOT = os.environ['fsdb_root']


@app.route("/", methods=['GET'])
def showPage():
    page_content = "pc"
    return page_content


@app.route("/comics/", methods=['GET'])
def getComics():
    # comics = [
    #    {'id': f, 'comic_name': f}
    #    for f in sorted(os.listdir(FSDB_ROOT))
    # ]
    comics = ['c1', 'c2']

    return jsonify(comics)


@app.route("/episodeof/<comic_id>", methods=['GET'])
def getEpisodes(comic_id: str):
    # episodes = [
    #    {'id': os.path.join(comic_id, f), 'episode_name': f.split('.')[0]}
    #    for f in sorted(os.listdir(os.path.join(FSDB_ROOT, comic_id)))
    # ]
    episodes = ['e1', 'e2']

    return jsonify(episodes)


@app.route("/imageof/<comic_id>/<episode_id>", methods=['GET'])
def getImages(comic_id: str, episode_id: str):
    # with open(os.path.join(FSDB_ROOT, comic_id, episode_id), 'r') as src:
    #    images = [
    #        {'image_url': i}
    #        for i in json.load(src)['image_urls']
    #    ]
    images = ['i1', 'i2']

    return jsonify(images)


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
