import os
import json

from os import path
from flask import Flask, jsonify
from storage import Mysql

app = Flask(__name__)

DB_HOST = os.environ['db_host']
DB_PORT = os.environ['db_port']
DB_USER = os.environ['db_user']
DB_PASS = os.environ['db_pass']
mysql_storage = Mysql('comicdb', DB_HOST, int(DB_PORT), DB_USER, DB_PASS)


@app.route("/", methods=['GET'])
def showPage():
    html_path = path.join(
        path.dirname(path.realpath(__file__)),
        'index.html'
    )

    with open(html_path, 'r') as src:
        return src.read()


@app.route("/comics/", methods=['GET'])
def getComics():
    comics = mysql_storage.get('comics', col='id,comic_name')

    return jsonify(comics)


@app.route("/episodeof/<comic_id>", methods=['GET'])
def getEpisodes(comic_id: str):
    episodes = mysql_storage.get(
        'episodes',
        col='id,episode_name',
        where=f"comic_id='{comic_id}'"
    )

    return jsonify(episodes)


@app.route("/imageof/<episode_id>", methods=['GET'])
def getImages(episode_id: str):
    images = mysql_storage.get(
        'images',
        col='image_url',
        where=f"episode_id='{episode_id}'"
    )

    return jsonify(images)


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
