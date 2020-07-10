import socket
import time

signedIn=False

def autenticacao (s):
    global signedIn
    print("1-login\n2-Quit")
    menu = input("Choose: ")
    if menu == "1":
        username = input('username : ')
        s.sendall(username.encode())
        time.sleep(0.2)

        password = input('password : ')
        s.sendall(password.encode())

        final = s.recv(1024)
        final = final.decode()
        if final == "True":
            print("login com sucesso")
            signedIn=True
        else:
            print("tente outra vez")
            return False
    elif menu == "2":
        s.close()
    else:
        print("Choose either 1 or 2")
def set(s):

    v = s.recv(1024)
    if v.decode()=="ERRO setNumber":
        print("Error setting number or name")
    if v.decode()=="ERRO removeNumber":
        print("Error deleting contact number")
    if v.decode()=="ERRO removeContact":
        print("Error deleting contact")

    print(v.decode())
    return 0

def get(s):

    size = s.recv(1024)
    size = size.decode()
    if size == "ERRO getNumber":
        print("Error finding name")
    elif size =="ERRO reverse":
        print("Error finding number")
    else:
        for i in range(int(size)):
            v = s.recv(1024)
            print(v.decode())
    return 0

def main():
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect(('localhost', 5000))

    while(signedIn==False):
        autenticacao(s)

    while(1):
        comando1 = input("$ ")
        comando = comando1.split()
        if comando[0]=="getphone" and len(comando)==1:
            print("Existing comands:\n$ getphone -set name number\n$ getphone -del name number\n$ getphone -del name\n$ getphone name\n$ getphone number\n$ getphone quit")
        elif comando[0] =="getphone":
            if comando[1]=="quit":
                s.close()
                break
            elif comando[1]!="-set" and len(comando)<=3  or  comando[1]!="-del" and len(comando)<=2:
                print("Existing comands:\n$ getphone -set name number\n$ getphone -del name number\n$ getphone -del name\n$ getphone name\n$ getphone number\n$ getphone quit")
            elif comando[1]=="-set" or comando[1]=="-del":
                s.sendall(comando1.encode())
                set(s)
            else:
                s.sendall(comando1.encode())
                get(s)

        else:
            print("Existing comands:\n$ getphone -set name number\n$ getphone -del name number\n$ getphone -del name\n$ getphone name\n$ getphone number\n$ getphone quit")

    s.close()
main()
