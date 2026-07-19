import time
from functools import wraps

def timeit(f):
    @wraps(f)
    def wrapper(*args, **kwargs):
        start = time.time()
        result = f(*args, **kwargs)
        end = time.time()
        print(f"{f.__name__} took {end - start:.6f} seconds")
        return result
    return wrapper

@timeit
def hello_world():
    print("Hello World")

hello_world()
