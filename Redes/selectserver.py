# -*- coding: utf-8 -*-qu
import socket, select
import traceback # para informação de excepções
import threading
import errno
import time
import pickle

SOCKET_LIST = []    # lista de sockets abertos
RECV_BUFFER = 4096  # valor recomendado na doc. do python
PORT = 5000
client={}
user={"Admin":"Admin"}

def autenticacao (sock):
    accept = False

    while(accept==False):
        username = sock.recv(1024)
        username = username.decode()
        password = sock.recv(1024)
        password = password.decode()
        try:
            if username in user.keys() and password in user.values():
                sock.sendall("True".encode())
                time.sleep(0.2)
                accept = True
            else:
                sock.sendall("NOTSIGN".encode())
                time.sleep(0.2)
        except Exception as e:
            return

def removeContact(nome):
    try:
        del client[nome]
        sock.sendall((nome + " deleted from de database").encode())
    except Exception as e:
        sock.sendall("ERRO removeContact".encode())

def getNumber(sock, nome):
    global client

    try:
        sock.sendall(str(len(client[nome])).encode())
        time.sleep(0.2)

        for number in client[nome]:
            sock.sendall((nome + " has number" + " " + str(number)).encode())
            time.sleep(0.2)
    except Exception as e:
        sock.sendall("ERRO getNumber".encode())


def setNumber(sock,nome,numero):
    global client
    try:
        if nome in client.keys():
            if numero not in client[nome]:
                client.setdefault(nome,[]).append(numero)
                sock.sendall((nome + " number set to " + str(numero)).encode())
            else:
                sock.sendall("ERRO setNumber".encode())
        else:
            client[nome]=[numero]
            sock.sendall((nome + " number set to " + str(numero)).encode())

    except Exception as e:
        sock.sendall("ERRO setNumber".encode())


def reverse (sock,numero):
    global client
    temp=[]
    n = 0
    try:
        for i in client:
            for c in client[i]:
                if c == numero :
                    temp.append(i)
                    n+=1

        if len(temp)==0:
            sock.sendall("ERRO reverse".encode())
        else:
            sock.sendall(str(len(temp)).encode())
            time.sleep(0.2)

            for i in temp:
                sock.sendall((str(numero) + " is the number for " + i).encode())
                time.sleep(0.2)

    except Exception as e:
        sock.sendall("ERRO reverse".encode())


def removeNumber(sock,nome,numero):
    global client

    try:
        for i in client[nome]:
            if len(client[nome]) < 2 :
                if numero in client[nome]:
                    sock.sendall((nome + " number " + str(numero) + " deleted from database").encode())
                    time.sleep(0.2)
                    del client[nome]
                else:
                    sock.sendall("ERRO removeNumber".encode())
                    time.sleep(0.2)
            else:
                if numero in client[nome] :
                    sock.sendall((nome + " number " + str(numero) + " deleted from database").encode())
                    time.sleep(0.2)
                    client[nome].remove(numero)
                else:
                    sock.sendall("ERRO removeNumber".encode())
                    time.sleep(0.2)
    except Exception as e:
        sock.sendall("ERRO removeNumber".encode())

def saveDic():
    global client
    pickle_out=open("dict_pickle","wb")
    pickle.dump(client,pickle_out)
    pickle_out.close()

def loadDic():
    global client
    try:
        pickle_in=open("dict_pickle","rb")
        client=pickle.load(pickle_in)
    except IOError:
        print ("Error File does not appear to exist.")

def main(data, sock):

    list = data.decode().split()
    print(list)
    if list[1]=="-set":
        i=2
        nome=""
        while list[i].isdigit()!=True:
            nome +=list[i] + " "
            i+=1

        nome = nome[:-1]
        numero = list[i]

        setNumber(sock,nome,numero)

    elif list[1]=="-del":
        i=2
        nome=""
        if list[-1].isdigit()==True:
            while list[i].isdigit()==False:
                nome +=list[i] + " "
                i+=1

            nome = nome[:-1]
            numero = list[i]
            removeNumber(sock,nome,numero)
        else:
            while i<len(list):
                nome +=list[i] + " "
                i+=1

            nome = nome[:-1]
            removeContact(nome)

    elif list[1].isdigit()==False:
        nome =""
        for i in range(1,len(list)):
            nome += list[i] + " "

        nome = nome[:-1]
        getNumber(sock,nome)

    elif list[1].isdigit()==True:
        reverse(sock,list[1])
    else:
        return 0

    print(client)

if __name__ == "__main__":
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server_socket.bind(("0.0.0.0", PORT))  # aceita ligações de qualquer lado
    server_socket.listen(10)
    #server_socket.setblocking(0) # o socket deixa de ser blocking

    # Adicionamos o socket à lista de sockets a monitorizar
    SOCKET_LIST.append(server_socket)

    print("Server started on port %d" % (PORT,))
    loadDic()
    timecount = 0
    while True:  # ciclo infinito

        # apagamos os sockets que "morreram" entretanto
        for sock in SOCKET_LIST:
            if sock.fileno() < 0:
                SOCKET_LIST.remove(sock)

        # agora, esperamos que haja dados em algum dos sockets que temos
        rsocks,_,_ = select.select(SOCKET_LIST,[],[], 5)

        if len(rsocks) == 0: # timeout
            timecount += 5
            print("Timeout on select() -> %d secs" % (timecount))
            if timecount % 60 == 0:  # passou um minuto
                timecount = 0
            continue

        for sock in rsocks:  # percorrer os sockets com nova informação

            if sock == server_socket: # há uma nova ligação
                newsock, addr = server_socket.accept()
                SOCKET_LIST.append(newsock)
                autenticacao(newsock)
                print("New client - %s" % (addr,))

            else: # há dados num socket ligado a um cliente
                try:
                    data = sock.recv(RECV_BUFFER)
                    if data:
                        t = threading.Thread(target = main, args = (data,sock))
                        t.start()

                    else: # não há dados, o cliente fechou o socket
                        print("Client disconnected 1")
                        saveDic()
                        sock.close()
                        SOCKET_LIST.remove(sock)

                except Exception as e: # excepção ao ler o socket, o cliente fechou ou morreu
                    print("Client disconnected")
                    print("Exception -> %s" % (e,))
                    print(traceback.format_exc())

                    sock.close()
                    SOCKET_LIST.remove(sock)
