### Walrus operator
Compute and assign values simultaneously
```python
if (value := complex_calculation()) > 15:
    print(value)
```

### Filter
```python
odd_numbers = list(filter(lambda x: x % 2 != 0, numbers))
```

### Decorator simple
```python
def uppercase_decorator(func):
    def wrapper():
        result = func()
        return result.upper()
    return wrapper

@uppercase_decorator
def say_hello():
    return "hello"

print(say_hello())  # Outputs: HELLO
```

### Decorator complex
```python
from functools import wraps
import time

def rate_limiter(max_calls_per_second):
    calls = []
    
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            current_time = time.time()
            calls.append(current_time)
            calls[:] = [t for t in calls if current_time - t < 1]
            
            if len(calls) > max_calls_per_second:
                print("Rate limit exceeded.")
                return None
            
            return func(*args, **kwargs)
        
        return wrapper
    return decorator

@rate_limiter(5)
def fetch_data():
    print("Fetching data...")

for i in range(10):
    fetch_data()
```
Another example as decorator and as a class
```python
def add_symbol(symbol):
  def decorator(func):
    def wrapper(name):
      return func(name) + symbol
    return wrapper
  return decorator

# As a class

class add_symbol():
    def __init__(self, symbol):
        self.symbol = symbol

    def __call__(self, func):
        def wrapper(name):
            return func(name) + self.symbol
        return wrapper

# These are equivalent
```
### Itertools
```python
import itertools

for i in itertools.pairwise('abcdefg'):
    print(i)

'''
('a', 'b')
('b', 'c')
('c', 'd')
('d', 'e')
('e', 'f')
('f', 'g')
'''

import itertools

for i in itertools.accumulate('abcdefg'):
    print(i)

'''
a
ab
abc
abcd
abcde
abcdef
abcdefg
'''

from itertools import product

for i,j,k in product([1,2], [3,4], [5,6]):
  print(i, j, k)

'''
1 3 5
1 3 6
1 4 5
1 4 6
2 3 5
2 3 6
2 4 5
2 4 6
'''

import itertools 

words = ['apple', 'ant', 'arm', 'boy', 'bee', 'cat', 'donkey']

def condition(x):
  return x[0]  # returns first letter of element

for key, group in itertools.groupby(words, condition):
    print(key, list(group))

# for key, group in itertools.groupby(words, lambda x:x[0]):

'''
a ['apple', 'ant', 'arm']
b ['boy', 'bee']
c ['cat']
d ['donkey']
'''

import itertools

for i in itertools.compress('ABCD', [1,0,0,0]):
    print(i, end=' ')

# A

```

### Pipe
```python
from toolz import pipe
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
average = pipe(numbers, 
               filter(lambda n: n % 2 == 0), 
               map(lambda n: n * 10), 
               map(lambda n: n + 5), 
               lambda x: sum(x) / len(x))
print(average)

# Equivalent to but more legible than

numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
average = sum(map(lambda n: n + 5, map(lambda n: n * 10, filter(lambda n: n % 2 == 0, numbers)))) / len(numbers)
print(average)
```

### Profiling
```python
python -m cProfile test.py
```
Returns:
 - **ncalls**: The number of times the function was called.
 - **tottime**: The total time spent in the function (excluding time spent in called functions).
 - **percall**: The time spent per call (equals tottime divided by ncalls).
 - **cumtime**: The cumulative time spent in the function, including time spent in called functions.
 - **percall**: The cumulative time spent per call (equals cumtime divided by ncalls).

 ```python
 python -m timeit '"-".join(str(n) for n in range(100))'
 ```
#### using decorators
```python
def benchmark(func):
    """
    A decorator that prints the time a function takes
    to execute.
    """
    import time
    def wrapper(*args, **kwargs):
        t = time.clock()
        res = func(*args, **kwargs)
        print("{0} {1}".format(func.__name__, time.clock()-t))
        return res
    return wrapper


def logging(func):
    """
    A decorator that logs the activity of the script.
    (it actually just prints it, but it could be logging!)
    """
    def wrapper(*args, **kwargs):
        res = func(*args, **kwargs)
        print("{0} {1} {2}".format(func.__name__, args, kwargs))
        return res
    return wrapper


def counter(func):
    """
    A decorator that counts and prints the number of times a function has been executed
    """
    def wrapper(*args, **kwargs):
        wrapper.count = wrapper.count + 1
        res = func(*args, **kwargs)
        print("{0} has been used: {1}x".format(func.__name__, wrapper.count))
        return res
    wrapper.count = 0
    return wrapper

@counter
@benchmark
@logging
def reverse_string(string):
    return str(reversed(string))

print(reverse_string("Able was I ere I saw Elba"))
print(reverse_string("A man, a plan, a canoe, pasta, heros, rajahs, a coloratura, maps, snipe, percale, macaroni, a gag, a banana bag, a tan, a tag, a banana bag again (or a camel), a crepe, pins, Spam, a rut, a Rolo, cash, a jar, sore hats, a peon, a canal: Panama!"))

#outputs:
#reverse_string ('Able was I ere I saw Elba',) {}
#wrapper 0.0
#wrapper has been used: 1x 
#ablE was I ere I saw elbA
#reverse_string ('A man, a plan, a canoe, pasta, heros, rajahs, a coloratura, maps, snipe, percale, macaroni, a gag, a banana bag, a tan, a tag, a banana bag again (or a camel), a crepe, pins, Spam, a rut, a Rolo, cash, a jar, sore hats, a peon, a canal: Panama!',) {}
#wrapper 0.0
#wrapper has been used: 2x
#!amanaP :lanac a ,noep a ,stah eros ,raj a ,hsac ,oloR a ,tur a ,mapS ,snip ,eperc a ,)lemac a ro( niaga gab ananab a ,gat a ,nat a ,gab ananab a ,gag a ,inoracam ,elacrep ,epins ,spam ,arutaroloc a ,shajar ,soreh ,atsap ,eonac a ,nalp a ,nam A
```