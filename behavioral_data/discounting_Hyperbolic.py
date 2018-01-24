##Hyperbolic Discounting (Time, Effort, Prob) Computational Model
##Handpicked by Marissa Gorlick 1/13/15 updated KLS 9.29.15
##edited by Jaime Castrellon - 12/2017

#/usr/bin/env python
import scipy.stats, os, itertools
from numpy import *
from random import uniform, normalvariate
from scipy.optimize import fmin, brute
import numpy as np
import glob
import csv
import datetime

#Open a file for processing
def openfile(filename):
#Tab delimited
#	myfile = open(filename)
#	allData = myfile.readlines()
#	for i in range(len(allData)):
#		allData[i]=allData[i].split()
#		#print(allData[i])
#Tab delimited
	with open(filename, 'rb') as f:
		allData = list(csv.reader(f))
		#print(allData)
    	#allData = list(reader)
	return allData

#Computes the Softmax probability of selecting a given option amongst 2+ options
def getActionProbability(subjectiveValues, m):
	numerator = exp( subjectiveValues[0] * m) # action_values chosen
	denominator = sum( exp( subjectiveValues * m) ) #action_values sum
	probability = (numerator/denominator)
	return probability

#Computes the Bayes Information Criteria
def getBIC(LL, num_params, num_trials):
    return -2*-LL + num_params*log(num_trials)

#Fit with current params and generate LL for optimization
def get_likelihood(params, data, r1, r2, d1, d2, response, file):
	k = params[0]
	m = params[1]
	
	if k < 0: return inf
	if m < 0: return inf

	#Set Log likelihood to 0 to start fit.
	totalLLH = 0
	
	#remove header
	data = data[1:len(data)]
	for testLine in data: #for each trial
		#print(len(testLine))
		#print(testLine)
		#print(response)
		res = testLine[response] #Response. #Smaller/Sooner choice = 1, Larger/Later choice = 2

		#Compute subjective values of each option given k
		SV1 = float(testLine[r1])/(1 + k*float(testLine[d1]))
		SV2 = float(testLine[r2])/(1 + k*float(testLine[d2]))
		
		#compute probability of selecting each option using SOFTMAX function and subjective values for each option
		P1 = getActionProbability(array( [SV1, SV2]), m)
		P2 = getActionProbability(array( [SV2, SV1]), m)
		probs = array([P1, P2])
		
		#Use the selected option to update total log liklihood
		#print(testLine)
		#print(res)
		if res != '': 
			prob = probs[int(res)-7] #only add probability of the chosen response; note that I subtract 7 here
			totalLLH += -log(prob) #add to cumulative log likelihood

		#print "probability: ", testLine[r1], testLine[r2], SV1, SV2, probs, prob, totalLLH
	#with open('output/Var_discounting_Hyperbolic.txt', "a") as dataFile:
	#	dataFile.write(file + "\t" + str(k) + "\t" + str(totalLLH)  + '\n')
	return totalLLH

def do_fit(data, r1, r2, d1, d2, response, file):

	tries = 100 #number of attempts to find best fit params
	lowestLLH = inf #anything else will be better fit. This is updated and compared to all new fits to find best parameters
	bestFit = 'NA' #best fitting will be set aside; initialized to NA
	
	#minimizes -LLH
	for i in range(tries):
	
		#sets the starting parameters by picking them randomly from uniform distributions
		k = [uniform(0, 1)] #discounting; tends to be small for time so we initialize between 0-1 here
		m = [uniform(0, 1)] #1 #Softmax "temperature" parameter.  Characterizes how deterministic/stochastic nature of behavior
		iparams = k + m
		#print iparams

		results = fmin(get_likelihood, iparams, args=(data, r1, r2, d1, d2, response, file), full_output=1, maxiter = 10000, maxfun = 10000, disp=False)
		#print("current lowestLLH", lowestLLH)
		#print("new lowestLLH?", results[1])
		#print(results[0])
		#print("complete", results[4])
		#print("will we update LLH?", lowestLLH>results[1])
		if (lowestLLH>results[1] and results[4] == 0):
			#print results
			test = results[1]
			lowestLLH = test
			#print 'update', results[1], test, lowestLLH
			bestFit = results

	return bestFit

#dataFolders = ["data_effortScaled/*"]
#dataFolders = ['../allData/parse/*']
dataFolders = ['data/*']
dataColumns = [[3, 4, 5, 6, 8]]#[r1, r2, d1, d2, response]
	
for set in xrange(0,len(dataFolders)):
	#Find the best parameters
	Fits = []
	#files = os.listdir("data/")
	#print(dataFolders)
	files = glob.glob(dataFolders[set]) #list of file names to be fit.  DS_Store ignored.

	print(files)
	for file in files:
		print file
		r1, r2, d1, d2, response = dataColumns[set]
		data = openfile(file)
		best_likelihood = float("-inf")
		results = do_fit(data, r1, r2, d1, d2, response, file);
		bestParams = results[0]
		k = bestParams[0]
		m = bestParams[1]
		LLH = results[1]
		complete = results[4]
		BIC = getBIC(LLH, 2, 42)#Two free parameters, k and m
	
		#print((file, k, m, LLH, BIC, complete))
		fitLine = list([k, m, LLH, BIC, complete])
		fitLine = [(str(i)) for i in fitLine]
		fitLine = tuple(fitLine)
		fitLine = "\t".join(fitLine)
		fitLine = file + "\t" + str(fitLine)
		#Fits = file + "\t" + str(results[0]) +"\t" + str(results[1])
		#print(fitLine)
		#print(date.today())
		with open('output/Fits_discounting_Hyperbolic.txt', "a") as dataFile:
		   dataFile.write(fitLine + '\n')
	