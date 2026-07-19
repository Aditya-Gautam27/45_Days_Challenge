import time
import logging
import requests
from functools import wraps

logging.basicConfig(level=logging.INFO,
                    format='%(asctime)s | %(levelname)s | %(message)s')

logger = logging.getLogger(__name__)

def retry(retries =3, delay =1, backoff=2, exceptions=(requests.ConnectionError,)):
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            current_delay = delay
            for attempt in range(retries+1):
                try:
                    logger.info(f"Attempt {attempt}...")

                    return func(*args, **kwargs)

                except exceptions as e:

                    logger.warning(
                        f"Attempt {attempt} failed: {e}"
                    )

                    if attempt == retries:
                        logger.error("Maximum retries exceeded.")
                        raise

                    logger.info(
                        f"Retrying in {current_delay} seconds..."
                    )

                    time.sleep(current_delay)

                    current_delay *= backoff

        return wrapper
    return decorator
counter = 0


@retry(
    retries=5,
    delay=1,
    backoff=2,
    exceptions=(requests.ConnectionError,)
)
def fetch_data():

    global counter
    counter += 1

    if counter < 4:
        raise requests.ConnectionError("Network Error")

    return "Data fetched successfully!"


print(fetch_data())
