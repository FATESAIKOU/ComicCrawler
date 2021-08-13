"""
Implement for using aws s3 as a storage
"""

import io
import os
import boto3


class S3:
    def __init__(self, bucket_name):
        self._bucket = boto3.resource('s3').Bucket(bucket_name)

    def list(self, *path_arr):
        fns = set()

        prefix = ''
        if len(path_arr) > 0:
            prefix = os.path.join(*path_arr)
            prefix = prefix if prefix[-1] == '/' else prefix + '/'

        for o in self._bucket.objects.filter(Prefix=prefix):
            if len(o.key) > len(prefix):
                fns.add(o.key[len(prefix):].split('/')[0])

        return list(fns)

    def downloadData(self, *path_arr):
        filename = os.path.join(*path_arr)

        content = io.BytesIO()
        self._bucket.download_fileobj(filename, content)
        content.seek(0)

        return content.read().decode('utf-8')
