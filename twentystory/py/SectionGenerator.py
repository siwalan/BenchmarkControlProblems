try:
    import openseespy.opensees as ops
except:
    import opensees as ops
    
def Wsection(secID, matID, d, bf, tf, tw, nfdw, nftw, nfbf, nftf,  orient="Strong"):
    
    if (orient == "Weak"):
        dw = d-2*tf
        z1 = -d/2
        z2 = -dw/2
        z3 = dw/2
        z4 = d/2
        
        y1 = bf/2
        y2 = tw/2
        y3 = -tw/2
        y4 = -bf/2
    
        ops.section('Fiber',secID)
        ops.patch('quad',matID, nfbf, nftf, *[y1,z3], *[y1,z4], *[y4,z4], *[y4,z3]);
        ops.patch('quad',matID, nftw, nfdw, *[y2,z3], *[y3,z3], *[y3,z2], *[y2,z2]);
        ops.patch('quad',matID, nfbf, nftf, *[y1,z1], *[y1,z2], *[y4,z2], *[y4,z1]);
        
        
    else:
        dw = d-2*tf
        y1 = -d/2
        y2 = -dw/2
        y3 = dw/2
        y4 = d/2
        
        z1 = -bf/2
        z2 = -tw/2
        z3 = tw/2
        z4 = bf/2
        
        ops.section('Fiber',secID)
        ops.patch('quad',matID, nfbf, nftf, *[y1,z4], *[y1,z1], *[y2,z1], *[y2,z4]);
        ops.patch('quad',matID, nftw, nfdw, *[y2,z3], *[y2,z2], *[y3,z2], *[y3,z3]);
        ops.patch('quad',matID, nfbf, nftf, *[y3,z4], *[y3,z1], *[y4,z1], *[y4,z4]);

def Boxsection(secID, matID, b,h,t, nfdw, nftw, nfbf, nftf,  orient="Strong"):
    
    # Python Function to Create A Box Section Fiber
    # Written by @siwalan
    # Inspired by Wsection.tcl from Remo M. de Souza
    # Last Modified : 22 June 2022
    # input parameters
    # secID - section ID number
    # matID - material ID number 
    # b  = width of the box section - outer to outer
    # h  = depth of the box section - outer to outer
    # t  = thickness of box section

    # nfdw = number of fibers along web depth 
    # nftw = number of fibers along web thickness
    # nfbf = number of fibers along flange width
    # nftf = number of fibers along flange thickness
    
    # Test case for verification
    # https://colab.research.google.com/drive/1ON3gC6S8utZsz3_9NCWQMD3ES37c1KVI?usp=sharing
    
    if (orient == "Weak" or orient == "YY"):
        bb = (b-2*t)
        y1 = b/2
        y2 = bb/2
        y3 = -bb/2
        y4 = -b/2
    

        hh = (h-2*t)
        z1 = -h/2
        z2 = -hh/2
        z3 = hh/2
        z4 = h/2

        ops.section('Fiber',secID)
        ops.patch('quad',matID, nfdw, nftw, *[y1,z1], *[y1,z4], *[y2,z4], *[y2,z1]);
        ops.patch('quad',matID, nfbf, nftf, *[y2,z1], *[y2,z2], *[y3,z2], *[y3,z1]);
        ops.patch('quad',matID, nfbf, nftf, *[y2,z3], *[y2,z4], *[y3,z4], *[y3,z3]);
        ops.patch('quad',matID, nfdw, nftw, *[y3,z1], *[y3,z4], *[y4,z4], *[y4,z1]);
    else:
        hh = h-2*t;
        y1 = h/2;
        y2 = hh/2;
        y3 = -hh/2;
        y4 = -h/2;

        bb = b-2*t;
        z1 = -b/2;
        z2 = -bb/2;
        z3 = bb/2;
        z4 = b/2;

        ops.section('Fiber',secID)
        ops.patch('quad',matID, nfdw, nftw, *[y1,z1], *[y1,z4], *[y2,z4], *[y2,z1]);
        ops.patch('quad',matID, nfbf, nftf, *[y2,z1], *[y2,z2], *[y3,z2], *[y3,z1]);
        ops.patch('quad',matID, nfbf, nftf, *[y2,z3], *[y2,z4], *[y3,z4], *[y3,z3]);
        ops.patch('quad',matID, nfdw, nftw, *[y3,z1], *[y3,z4], *[y4,z4], *[y4,z1]);