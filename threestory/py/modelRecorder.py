try:
    import openseespy.opensees as ops
except:
    import opensees as ops

import os

def recorder (RecorderFolder, recorderDeltaT):
    ops.recorder('Node','-file',(os.path.join(os.getcwd(),RecorderFolder,"FloorDisp.txt")),'-time','-dT',recorderDeltaT,'-node',*[11, 12, 13],'-dof',1,'disp')
    ops.recorder('Node','-file',(os.path.join(os.getcwd(),RecorderFolder,"BaseShear.txt")),'-time','-dT',recorderDeltaT,'-node',*[10,20,30,40,50],'-dof',1,'reaction')
    ops.recorder('Node','-file',(os.path.join(os.getcwd(),RecorderFolder,"FloorAcceleration.txt")),'-time','-dT',recorderDeltaT,'-node',*[11,12,13],'-dof',1,'accel')

    d  = 100000;
    bf = 100000;

    ops.recorder('Element','-file',(os.path.join(os.getcwd(),RecorderFolder,"1BeamStressStrainI.txt")),'-time','-dt',recorderDeltaT,'-ele',*[1121, 2131, 3141, 4151],'section',1,'fiber',d/2,bf/2,'stressStrain')
    ops.recorder('Element','-file',(os.path.join(os.getcwd(),RecorderFolder,"1BeamStressStrainJ.txt")),'-time','-dt',recorderDeltaT,'-ele',*[1121, 2131, 3141, 4151],'section',5,'fiber',d/2,bf/2,'stressStrain')

    ops.recorder('Element','-file',(os.path.join(os.getcwd(),RecorderFolder,"2BeamStressStrainI.txt")),'-time','-dt',recorderDeltaT,'-ele',*[1222, 2232, 3242, 4252],'section',1,'fiber',d/2,bf/2,'stressStrain')
    ops.recorder('Element','-file',(os.path.join(os.getcwd(),RecorderFolder,"2BeamStressStrainJ.txt")),'-time','-dt',recorderDeltaT,'-ele',*[1222, 2232, 3242, 4252],'section',5,'fiber',d/2,bf/2,'stressStrain')

    ops.recorder('Element','-file',(os.path.join(os.getcwd(),RecorderFolder,"3BeamStressStrainI.txt")),'-time','-dt',recorderDeltaT,'-ele',*[1323, 2333, 3343, 4353],'section',1,'fiber',d/2,bf/2,'stressStrain')
    ops.recorder('Element','-file',(os.path.join(os.getcwd(),RecorderFolder,"3BeamStressStrainJ.txt")),'-time','-dt',recorderDeltaT,'-ele',*[1323, 2333, 3343, 4353],'section',5,'fiber',d/2,bf/2,'stressStrain')

    ops.recorder('Element','-file',(os.path.join(os.getcwd(),RecorderFolder,"1ColStressStrainI.txt")),'-time','-dt',recorderDeltaT,'-ele',*[1011, 1112, 1213],'section',1,'fiber',d/2,bf/2,'stressStrain')
    ops.recorder('Element','-file',(os.path.join(os.getcwd(),RecorderFolder,"1ColStressStrainJ.txt")),'-time','-dt',recorderDeltaT,'-ele',*[1011, 1112, 1213],'section',5,'fiber',d/2,bf/2,'stressStrain')

    ops.recorder('Element','-file',(os.path.join(os.getcwd(),RecorderFolder,"2ColStressStrainI.txt")),'-time','-dt',recorderDeltaT,'-ele',*[2021, 2112, 2213],'section',1,'fiber',d/2,bf/2,'stressStrain')
    ops.recorder('Element','-file',(os.path.join(os.getcwd(),RecorderFolder,"2ColStressStrainJ.txt")),'-time','-dt',recorderDeltaT,'-ele',*[2021, 2112, 2213],'section',5,'fiber',d/2,bf/2,'stressStrain')

    ops.recorder('Element','-file',(os.path.join(os.getcwd(),RecorderFolder,"3ColStressStrainI.txt")),'-time','-dt',recorderDeltaT,'-ele',*[3031, 3132, 3233],'section',1,'fiber',d/2,bf/2,'stressStrain')
    ops.recorder('Element','-file',(os.path.join(os.getcwd(),RecorderFolder,"3ColStressStrainJ.txt")),'-time','-dt',recorderDeltaT,'-ele',*[3031, 3132, 3233],'section',5,'fiber',d/2,bf/2,'stressStrain')

    ops.recorder('Element','-file',(os.path.join(os.getcwd(),RecorderFolder,"4ColStressStrainI.txt")),'-time','-dt',recorderDeltaT,'-ele',*[4041, 4142, 4243],'section',1,'fiber',d/2,bf/2,'stressStrain')
    ops.recorder('Element','-file',(os.path.join(os.getcwd(),RecorderFolder,"4ColStressStrainJ.txt")),'-time','-dt',recorderDeltaT,'-ele',*[4041, 4142, 4243],'section',5,'fiber',d/2,bf/2,'stressStrain')

    ops.recorder('Element','-file',(os.path.join(os.getcwd(),RecorderFolder,"5ColStressStrainI.txt")),'-time','-dt',recorderDeltaT,'-ele',*[5051, 5152, 5253],'section',1,'fiber',d/2,bf/2,'stressStrain')
    ops.recorder('Element','-file',(os.path.join(os.getcwd(),RecorderFolder,"5ColStressStrainJ.txt")),'-time','-dt',recorderDeltaT,'-ele',*[5051, 5152, 5253],'section',5,'fiber',d/2,bf/2,'stressStrain')

    ops.recorder('Element','-file',(os.path.join(os.getcwd(),RecorderFolder,"1BeamGlobalForce.txt")),'-time','-dt',recorderDeltaT,'-ele',*[1121, 2131, 3141, 4151],'globalForce')
    ops.recorder('Element','-file',(os.path.join(os.getcwd(),RecorderFolder,"2BeamGlobalForce.txt")),'-time','-dt',recorderDeltaT,'-ele',*[1222, 2232, 3242, 4252],'globalForce')
    ops.recorder('Element','-file',(os.path.join(os.getcwd(),RecorderFolder,"3BeamGlobalForce.txt")),'-time','-dt',recorderDeltaT,'-ele',*[1323, 2333, 3343, 4353],'globalForce')

    ops.recorder('Element','-file',(os.path.join(os.getcwd(),RecorderFolder,"1BeamPlasticDeformation.txt")),'-time','-dt',recorderDeltaT,'-ele',*[1121, 2131, 3141, 4151],'plasticDeformation')
    ops.recorder('Element','-file',(os.path.join(os.getcwd(),RecorderFolder,"2BeamPlasticDeformation.txt")),'-time','-dt',recorderDeltaT,'-ele',*[1222, 2232, 3242, 4252],'plasticDeformation')
    ops.recorder('Element','-file',(os.path.join(os.getcwd(),RecorderFolder,"3BeamPlasticDeformation.txt")),'-time','-dt',recorderDeltaT,'-ele',*[1323, 2333, 3343, 4353],'plasticDeformation')

    ops.recorder('Element','-file',(os.path.join(os.getcwd(),RecorderFolder,"1ColGlobalForce.txt")),'-time','-dt',recorderDeltaT,'-ele',*[1011, 1112, 1213],'globalForce')
    ops.recorder('Element','-file',(os.path.join(os.getcwd(),RecorderFolder,"2ColGlobalForce.txt")),'-time','-dt',recorderDeltaT,'-ele',*[2021, 2112, 2213],'globalForce')
    ops.recorder('Element','-file',(os.path.join(os.getcwd(),RecorderFolder,"3ColGlobalForce.txt")),'-time','-dt',recorderDeltaT,'-ele',*[3031, 3132, 3233],'globalForce')
    ops.recorder('Element','-file',(os.path.join(os.getcwd(),RecorderFolder,"4ColGlobalForce.txt")),'-time','-dt',recorderDeltaT,'-ele',*[4041, 4142, 4243],'globalForce')
    ops.recorder('Element','-file',(os.path.join(os.getcwd(),RecorderFolder,"5ColGlobalForce.txt")),'-time','-dt',recorderDeltaT,'-ele',*[5041, 5142, 5243],'globalForce')

    