'''
Nicholas Corbett
Data Analytics Final Project: Drug Interactions
Preliminary Calculations
'''

import math
import pprint
pp = pprint.PrettyPrinter(indent=4, depth=4)

def standDev(drugDict, avg):
    sumDifferenceInteractions = 0
    for drug in drugDict:
        sumDifferenceInteractions += (abs(len(drugDict[drug]) - avg))**2
    sumDifferenceInteractions = sumDifferenceInteractions/48514
    return math.sqrt(sumDifferenceInteractions)

if __name__ == '__main__':
    file = open("ChCh-Miner_durgbank-chem-chem.tsv")
    drugInteractionCountDict = {}
    count = 0
    #Create the Dictionary
    for line in file:
        line = line.strip().split()
        if(drugInteractionCountDict.has_key(line[0])):
            drugInteractionCountDict[line[0]].add(line[1])
        else:
            drugInteractionCountDict[line[0]] = set()
            drugInteractionCountDict[line[0]].add(line[1])
        if(drugInteractionCountDict.has_key(line[1])):
            drugInteractionCountDict[line[1]].add(line[0])
        else:
            drugInteractionCountDict[line[1]] = set()
            drugInteractionCountDict[line[1]].add(line[0])
        count +=1


    sumInteractions=0
    maxInteractions = 64
    minInteractions = 64
    for drug in drugInteractionCountDict:
        sumInteractions+=len(drugInteractionCountDict[drug])
        if(len(drugInteractionCountDict[drug])>maxInteractions):
            maxInteractions = len(drugInteractionCountDict[drug])
            maxDrug = drug
        if(len(drugInteractionCountDict[drug])<minInteractions):
            minInteractions = len(drugInteractionCountDict[drug])
    #pp.pprint(drugInteractionCountDict)
    print(sumInteractions)
    print "Number of Drugs \t\t" + str(len(drugInteractionCountDict))
    print "Number of Interactions\t\t" + str(sumInteractions/2)
    avgInteractions = float(sumInteractions)/len(drugInteractionCountDict)
    print "Average Interactions\t\t" + str(avgInteractions)
    print "Min Interactions\t\t" + str(minInteractions)
    print "Drug" + maxDrug +"has Max Interactions\t"+ str(maxInteractions)
    print "Standard Deviation\t\t" + str(standDev(drugInteractionCountDict,avgInteractions))
