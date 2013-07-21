defrecord Record1,  attribute1: nil, attribute2: nil 

m = Record1[attribute1: 1, attribute2: 2]
Record1[attribute1: a, attribute2: b] = m
a
b
Record1[attribute1: c] = m
c