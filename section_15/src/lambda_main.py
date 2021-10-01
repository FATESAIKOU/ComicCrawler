import logging

LOGGER = logging.getLogger(__name__)
LOGGER.setLevel(logging.INFO)


def handler(event, context):
    LOGGER.info('Do process')
    hello_world = 'hello world'
    LOGGER.info('End process')
    return {
        'statusCode': 200,
        'body': hello_world
    }


if __name__ == "__main__":
    print(handler([], []))
