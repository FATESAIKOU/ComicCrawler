import sys
import unittest

from crawler_utils import getComicHome, getEpisodes, getImages


class CrawlingDoerTest(unittest.TestCase):
    def setUp(self):
        pass

    def tearDown(self):
        pass

    def test_get_comic_home(self):
        comic_home = getComicHome('食戟之靈')
        assert comic_home == 'https://comicbus.com/html/9337.html'

    def test_get_image2(self):
        episodes = getEpisodes('https://comicbus.com/html/9337.html')
        assert len(episodes) > 1

    def test_get_image3(self):
        images = getImages('https://comicabc.com/online/new-9337.html?ch=1')
        assert len(images) == 46


if __name__ == '__main__':
    unittest.main(verbosity=2)
