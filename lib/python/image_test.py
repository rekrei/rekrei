import numpy as np
import cv2
from matplotlib import pyplot as plt
import scipy as sp
import time
import random
import sys
import requests 
import json

debug = False

def exceptionHandler(exception_type, exception, traceback, debug_hook=sys.excepthook):
    if debug == True:
        debug_hook(exception_type, exception, traceback)
    else:
        print json.dumps({'matches': 0, 'error': True, 'time': 0.0})

sys.tracebacklimit=0
sys.excepthook = exceptionHandler

# cv2.redirectError exceptionHandler

img1 = cv2.imread(sys.argv[1],0)
img2 = cv2.imread(sys.argv[2],0) 
t0 = time.clock()
try:
  # 1 / (1/0)
  surf = cv2.SURF(800)
  freakExtractor = cv2.DescriptorExtractor_create('FREAK')
  kp1 = surf.detect(img1,None)
  kp1,des1 = freakExtractor.compute(img1,kp1)
  kp2 = surf.detect(img2,None)
  kp2,des2 = freakExtractor.compute(img2,kp2)

  t1=time.clock() - t0 #time for Descriptors

  # create BFMatcher object
  bf = cv2.BFMatcher(cv2.NORM_HAMMING, crossCheck=True)

  # print "Brute-force Matcher...."
  t2 = time.clock() #initiate matcher
  # Match descriptors.
  matches = bf.match(des1,des2)

  t3=time.clock() - t2 # time for matcher

  # Sort them in the order of their distance.
  matches = sorted(matches, key = lambda x:x.distance)
  print json.dumps({'matches': len(matches), 'time': t3, 'error': False})
except:
  raise
