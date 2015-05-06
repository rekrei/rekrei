import numpy as np
import cv2
from matplotlib import pyplot as plt
import scipy as sp
import time
import random
import sys
import requests 

print "Loading Images...."
print ""
img1 = cv2.imread(sys.argv[1],0)
image_1_id = sys.argv[2]
img2 = cv2.imread(sys.argv[3],0) 
image_2_id = sys.argv[4]

print "Freak Extractor with Surf keypoint detector"
t0 = time.clock() # initiate timer

# why 800?
surf = cv2.SURF(800)
freakExtractor = cv2.DescriptorExtractor_create('FREAK')
kp1 = surf.detect(img1,None)
kp1,des1 = freakExtractor.compute(img1,kp1)
kp2 = surf.detect(img2,None)
kp2,des2 = freakExtractor.compute(img2,kp2)

t1=time.clock() - t0 #time for Descriptors

# create BFMatcher object
bf = cv2.BFMatcher(cv2.NORM_HAMMING, crossCheck=True)

print "Brute-force Matcher...."
t2 = time.clock() #initiate matcher
# Match descriptors.
matches = bf.match(des1,des2)

t3=time.clock() - t2 # time for matcher
print t3, "seconds to find matches for two images"
print ""

# Sort them in the order of their distance.
matches = sorted(matches, key = lambda x:x.distance)

print "Number of all matches: ", len(matches)

