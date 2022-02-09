#!/usr/bin/env python

positions=[]
x=[-0.11,-0.11,-0.11,0.0,0.0,0.0]
for _ in range(21):
	x[0]=x[0]+0.01
	x[0]=round(x[0],2)
	x[1]=x[1]+0.01
	x[1]=round(x[1],2)
	x[2]=x[2]+0.01
	x[2]=round(x[2],2)
	positions.append(x[:])

print(positions)


print(" ")
print(" ")



indeces=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1]

for ind in indeces:
	print(positions[ind])
