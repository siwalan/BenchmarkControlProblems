import socket
import struct
import argparse
import os

try:
    import openseespy.opensees as ops
except:
    import opensees as ops

import numpy as np

parser = argparse.ArgumentParser(description="List of Argument for TCP Socket Connection",
                                 formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument("-et","--end-time", help="end-time", required= True)
parser.add_argument("-dt","--timestep", help="Timestep", required=True)
parser.add_argument("-f","--folder", help="folder location", required=True)
parser.add_argument("-p", "--port", help="Port for TCP Connection", required=True)
parser.add_argument("-ss","--full-states", help="end-time", required= True)

args = vars(parser.parse_args())

if (isinstance(args['full_states'], int)):
    full_states = args['full_states']
else:
    full_states = int(args['full_states'])

if (isinstance(args['timestep'], float)):
    dt = args['timestep']
else:
    dt = float(args['timestep'])
    
recorderFolder = (args['folder'])
if not (os.path.exists(os.path.join(os.getcwd(),"Result",recorderFolder))):
    os.makedirs(os.path.join(os.getcwd(),"Result",recorderFolder))

if (isinstance(args['end_time'], float)):
    endTime = args['end_time']
else:
    endTime = float(args['end_time'])

if (isinstance(args['port'], int)):
    PORT = args['data_amount']
else:
    PORT = int(args['port'])


import model
import modelRecorder
##################
#### Recorder ####
##################
recorderDeltaT = 0.01
RecorderFolder = (os.path.join(os.getcwd(),"Result",recorderFolder))
modelRecorder.recorder(RecorderFolder,recorderDeltaT)

print("Model Building Completed - Initializing Connection")

HOST = '127.0.0.1'

#### Base Isolation Control ####
ops.timeSeries('Constant',1,'-factor',1.0)
ops.pattern('UniformExcitation',1,1,'-accel',1,'-fact',1)
ops.parameter(1,'loadPattern',1,'factor')
ops.recorder('LoadRecorder','-file',(os.path.join(os.getcwd(),RecorderFolder,"GroundAcceleration.txt")),'-time','-dT',recorderDeltaT,'-pattern', 1)

#### Important Model Parameter
IDControlNode,IDControlDOF = 13,1

DOF_MCK = np.array([[10, -1, -1, -1],
[10, -1, -1, -1],
[11, 30, 31, 32],
[12, 27, 28, 29],
[13, 22, 23, 24],
[20, -1, -1, -1],
[21, 30, 25, 26],
[22, 27, 20, 21],
[23, 22, 16, 17],
[30, -1, -1, -1],
[31, 30, 18, 19],
[32, 27, 14, 15],
[33, 22, 10, 11],
[40, -1, -1, -1],
[41, 30, 12, 13],
[42, 27, 8, 9],
[43, 22, 4, 5],
[50, -1, -1, -1],
[51, 30, 6, 7],
[52, 27, 2, 3],
[53, 22, 0, 1],
]);

SystemSize = (DOF_MCK[:,1:4]).max()+1;

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.bind((HOST, PORT))
    s.listen()
    s.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
    conn, addr = s.accept()
    with conn:
        print("OpenSeesPyTCP Connection Server Initiated.")
        print("Connected using Port {}".format(PORT));

        ops.wipeAnalysis()
        ops.constraints('Transformation')
        ops.system('FullGeneral')
        ops.test('NormUnbalance', 1e-8, 50)
        ops.algorithm('Newton')
        ops.integrator('Newmark', 0.5, 0.25)
        ops.analysis('Transient')

        print("Integrator Setting Initialized")
        ok = 0
        t = 0
        print("Starting Connection")
        try:
            while (ok == 0 and t < endTime):
                            
                ### Implementation 1
                t = ops.getTime()


                if full_states == 1:
                    ss = np.zeros([SystemSize*2,1]);
                    for row in DOF_MCK:
                        dof = row[1:4]
                        node = int(row[0])
                        if dof[0] >= 0:
                            ss[dof[0]] = ops.nodeDisp(node)[0]
                            ss[dof[0]+SystemSize] = ops.nodeVel(node)[0]
                        if dof[1] >= 0:
                            ss[dof[1]] = ops.nodeDisp(node)[1]
                            ss[dof[1]+SystemSize] = ops.nodeVel(node)[1]
                        if dof[2] >= 0:
                            ss[dof[2]] = ops.nodeDisp(node)[2]
                            ss[dof[2]+SystemSize] = ops.nodeVel(node)[2]

                    sendMsg = struct.pack('>'+str(SystemSize*2+2)+'d',ops.getTime(), ops.nodeAccel(IDControlNode,IDControlDOF),  *ss)
                    conn.sendall(sendMsg)
                    #print("Sending Data")
                else:
                    sent_data = [ops.getTime()]
                    sent_data.append(ops.nodeAccel(IDControlNode,IDControlDOF))

                    sendMsg = struct.pack('>'+str(len(sent_data))+'d',*sent_data)
                    conn.sendall(sendMsg)
                    #print("Sending Data: OpenSees Time {} and Control Node Acceleration {}".format(sent_data[0],sent_data[1]))
                
                
                data = conn.recv(16)
                data = struct.unpack('>dd',data)


                SimulinkTime = data[0]
                controlAcceleration = data[1]
                #print("Receiving Data: Simulink Time {} and Control Acceleration".format(SimulinkTime, controlAcceleration))
                ops.updateParameter(1, controlAcceleration)
                if (abs(t-SimulinkTime)>= dt*0.1):
                    print("Timestep Error: Time Mismatch")
                    break

                ok = ops.analyze(1,dt)
                if (ok != 0):
                    print("Analyis Failed!")
                    ops.wipe()
                    s.close()

        except:
            print("Error")
            ops.wipe()
            s.close()

    print("OpenSees Analysis Completed")
    ops.wipe()
    s.close()
