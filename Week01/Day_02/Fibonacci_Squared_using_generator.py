def fibonacci():
    a,b=0,1

    while True:
        yield a + b
        a, b= b, a+b

fib = fibonacci()

for i in range(100):
    print(next(fib))

squares = (x*x for x in range(1000000))
for number in squares:
    print(number)
