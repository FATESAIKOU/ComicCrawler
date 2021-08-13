import os
import json
from flask import Flask, jsonify
from storage import S3

app = Flask(__name__)

BUCKET_NAME = os.environ['bucket_name']
FSDB_ROOT = os.environ['fsdb_root']

s3_storage = S3(BUCKET_NAME)


@app.route("/", methods=['GET'])
def showPage():
    return s3_storage.downloadData('index.html')


@app.route("/comics/", methods=['GET'])
def getComics():
    comics = [
        {'id': f, 'comic_name': f}
        for f in sorted(s3_storage.list(FSDB_ROOT))
    ]

    return jsonify(comics)


@app.route("/episodeof/<comic_id>", methods=['GET'])
def getEpisodes(comic_id: str):
    episodes = [
        {'id': os.path.join(comic_id, f), 'episode_name': f.split('.')[0]}
        for f in sorted(s3_storage.list(FSDB_ROOT, comic_id))
    ]

    return jsonify(episodes)


@app.route("/imageof/<comic_id>/<episode_id>", methods=['GET'])
def getImages(comic_id: str, episode_id: str):
    images = [
        {'image_url': i}
        for i in json.loads(s3_storage.downloadData(FSDB_ROOT, comic_id, episode_id))['image_urls']
    ]

    return jsonify(images)


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
