import sys

lzw=[]
size=[]


def read(compressed_file):
    global lzw
    global size
    temp=""
    file = open(compressed_file, "r")
    cnt = 0
    for line in file:
        line=line.split()
        if cnt == 0:
            for char in line:
                size.append(int(char))
                cnt+=1
        else:
            for char in line:
                lzw.append(int(char))

def decompress(data):
    decompressed=[]
    dic={0:"0",1:"1"}
    i=2
    for v,n in enumerate(data):
        a=n
        decompressed+=dic[a]
        if(v+1<len(data)):
            p=data[v+1]
        if p in dic.keys():
            dic[i]=dic[a]+dic[p][0]
            i+=1
        else:
            dic[i]=dic[a]+dic[a][0]
            i+=1

    return decompressed


def write_data(image_file,final):
    with open(final, 'w') as f:
        f.write("P1\n")
        f.write(str(size[0]) + " " + str(size[1]) + "\n")
        for i,item in enumerate(image_file):
            if i%size[0]==0 and i!=0:
                f.write("\n")

            f.write("%s " % item)

def main():
    read(sys.argv[1])
    write_data(decompress(lzw),sys.argv[2])
    print("Ficheiro descomprimido em " + sys.argv[2])

if __name__ == '__main__':
  main()
