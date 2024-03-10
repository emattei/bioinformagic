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