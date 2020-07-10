import sys
import math

binary=[]
size=[]

def read(image):
    global binary
    global size
    file = open(image,"r")
    cnt = 0
    for line in file:
        line = line.split()
        if line[0][0]=='P' or line[0][0]=='#':
            cnt+=1
            continue
        elif len(size)==0:
            for char in line:
                 size.append(int(char))
                 cnt+=1
        else:
            for char in line:
                binary.append(char)
                cnt+=1

def compress(data):
    output=[]
    dic={"0":0,"1":1}
    n=""
    i=2
    for value in data:
        a=n+value
        if a in dic:
            n=a
        else:
            output.append(dic[n])
            dic[a]=i
            i+=1
            n=value

    output.append(dic[n])
    return output

def write_data(compressed,final):
    with open(final, 'w') as f:
        f.write(str(size[0]) + " " + str(size[1]) + "\n")
        for item in compressed:
            f.write("%s " % item)


def entropia(binary):
    zero = 0
    one = 0
    ent = 0
    ent_z = 0
    ent_o = 0
    for b in binary:
        if b == '0':
            zero+=1
        else:
            one+=1

    pZero = zero/len(binary)
    pOne = one/len(binary)

    if pZero==0 and pOne!=0:
    	ent_z = ((-pOne)*math.log(pOne,2))
    if pZero!=0 and pOne==0:
    	ent_o = ((-pZero)*math.log(pZero,2))
    if pZero!=0 and pOne!=0:
    	ent = ((-pZero)*math.log(pZero,2))+((-pOne)*math.log(pOne,2))
    return ent

def entropia_condional(binary):
	zero = 0
	one = 0
	zero_temp = 0
	one_temp = 0
	zero_zero = 0
	zero_one = 0
	one_zero = 0
	one_one = 0
	ent_zero_z = 0
	ent_zero_o = 0
	ent_one_z = 0
	ent_one_o = 0
	ent = 0

	for b in binary:

		if zero_temp == 1:

			if b == '0':
				zero_zero+=1
				one_temp = 0
				zero_temp = 1
				zero+=1
			else:
				zero_one+=1
				one_temp = 1
				zero_temp = 0
				one+=1
		elif one_temp == 1:

			if b == '0':
				one_zero+=1
				one_temp = 0
				zero_temp = 1
				zero+=1
			else:
				one_one+=1
				one_temp = 1
				zero_temp = 0
				one+=1
		else:

			if b=='0':
				zero_temp = 1
				zero+=1
			else:
				one_temp = 1
				one+=1

	pZero_zero = zero_zero/len(binary)
	pZero_one = zero_one/len(binary)
	pOne_zero = one_zero/len(binary)
	pOne_one = one_one/len(binary)

	if(pZero_zero!=0):
		ent_zero_z = -pZero_zero*math.log(pZero_zero,2)
	if(pZero_one!=0):
		ent_zero_o = -pZero_one*math.log(pZero_one,2)
	if(pOne_zero!=0):
		ent_one_z = -pOne_zero*math.log(pOne_zero,2)
	if(pOne_one!=0):
		ent_one_o = -pOne_one*math.log(pOne_one,2)

	pZero = zero/len(binary)
	pOne = one/len(binary)

	ent = pZero * (ent_zero_z + ent_zero_o) + pOne * (ent_one_o+ent_one_z)
	return ent

def performance(input,output):
    total=0
    for i in output:
        if i > 0:
            digits = int(math.log10(i))+1
        else:
            digits = 1
        total +=digits

    temp = len(input)-total
    return (temp/len(input))*100

def main():
    read(sys.argv[1])
    write_data(compress(binary),sys.argv[2])
    print("ficheiro comprimido em " + sys.argv[2])
    print("Desempenho:", performance(binary,compress(binary)), "%")
    print("Entropia:", entropia(binary))
    print("Entropia condicional:", entropia_condional(binary))

if __name__ == '__main__':
  main()
