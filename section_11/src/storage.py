import json
import pymysql


class Mysql:
    def __init__(self, db, db_host, db_port, db_user, db_password):
        self.connection = pymysql.connect(
            db=db,
            host=db_host,
            port=db_port,
            user=db_user,
            password=db_password,
            cursorclass=pymysql.cursors.DictCursor
        )

    def __del__(self):
        self.connection.close()

    def get(self, table_name, col='*', where=''):
        sql = "SELECT {} FROM {} {}".format(
            col,
            table_name,
            '' if where == '' else 'WHERE ' + where
        )

        with self.connection.cursor() as cursor:
            cursor.execute(sql)
            return cursor.fetchall()

    def save_uniq(self, table_name, data):
        rows = self.get(table_name, col='id', where='{}'.format(
            ' AND '.join([f"{k}='{data[k]}'" for k in data.keys()])
        ))
        if len(rows) > 0:
            return rows[0]['id']

        cols = data.keys()
        insert_sql = "INSERT INTO {} ({}) VALUES ({})".format(
            table_name,
            ','.join(cols),
            ','.join([f"'{data[c]}'" for c in cols])
        )

        with self.connection.cursor() as cursor:
            cursor.execute(insert_sql)
            self.connection.commit()
            return cursor.lastrowid

    def save_entire_episode(self, comic_name, episode_name, image_urls):
        comic_id = self.save_uniq('comics', data={'comic_name': comic_name})
        episode_id = self.save_uniq('episodes', data={
            'comic_id': comic_id,
            'episode_name': episode_name
        })

        for url in image_urls:
            self.save_uniq('images', data={
                'comic_id': comic_id,
                'episode_id': episode_id,
                'image_url': url
            })
