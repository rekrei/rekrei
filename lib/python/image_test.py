## scikit-image for skimage.measure
import numpy as np
import cv2
import time
import random
import sys
import json

debug = False

def exceptionHandler(exception_type, exception, traceback, debug_hook=sys.excepthook):
    if debug == True:
        debug_hook(exception_type, exception, traceback)
    else:
        print json.dumps({'matches': 0, 'error': True, 'time': 0.0})

sys.tracebacklimit=0
sys.excepthook = exceptionHandler

# What should the minimum be?
MIN_MATCH_COUNT = 10

img1 = cv2.imread(sys.argv[1],0)
img2 = cv2.imread(sys.argv[2],0)
try:
  t0 = time.clock()

  # Initiate SIFT detector
  sift = cv2.SIFT()

  # find the keypoints and descriptors with SIFT
  kp1, des1 = sift.detectAndCompute(img1,None)
  kp2, des2 = sift.detectAndCompute(img2,None)

  FLANN_INDEX_KDTREE = 0
  index_params = dict(algorithm = FLANN_INDEX_KDTREE, trees = 5)
  search_params = dict(checks = 50)

  flann = cv2.FlannBasedMatcher(index_params, search_params)

  matches = flann.knnMatch(des1,des2,k=2)

  # store all the good matches as per Lowe's ratio test.
  good = []
  for m,n in matches:
      if m.distance < 0.7*n.distance:
          good.append(m)

  t1 = time.clock() - t0 # time for matcher
  print json.dumps({'matches': len(good), 'time': t1, 'error': False})
except:
  raise
