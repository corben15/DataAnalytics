'''
Nicholas Corbett
Data Analytics

'''

import csv
import pprint
from random import randint
pp = pprint.PrettyPrinter(indent=4)

def interactionCount(file):
    drugInteractionCountDict = {}
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


    with open('interactionCount.csv', 'w') as f:
        for key in drugInteractionCountDict.keys():
            f.write("%s,%s\n"%(key,len(drugInteractionCountDict[key])))

def interactionMatrixCSV(file):
    drugInteractionDict = {}
    for line in file:
        line = line.strip().split()
        if(drugInteractionDict.has_key(line[0])):
            drugInteractionDict[line[0]].add(line[1])
        else:
            drugInteractionDict[line[0]] = set()
            drugInteractionDict[line[0]].add(line[1])
        if(drugInteractionDict.has_key(line[1])):
            drugInteractionDict[line[1]].add(line[0])
        else:
            drugInteractionDict[line[1]] = set()
            drugInteractionDict[line[1]].add(line[0])

    with open('interactionMatrix.csv', 'w') as f:
        # Write the top/header row
        f.write("DRUG,")
        for drug in drugInteractionDict:
            if drug == "DB03880":
                f.write("%s\n"%drug)
            else:
                f.write("%s,"%drug)
        # File in the link matrix
        for drug1 in drugInteractionDict:
            f.write("%s,"%drug1)
            for drug2 in drugInteractionDict:
                if drug2 in drugInteractionDict[drug1]:
                    cell = "1"
                else:
                    cell = "0"
                if drug2 == "DB03880":
                    f.write("%s\n"%cell)
                else:
                    f.write("%s,"%cell)


    for drug in drugInteractionDict:
        print(drug)

def sideEffectCount(file):
    file = file.read()
    file = file.split("\n")

    sideEffectCountDict = {}
    for i in range(len(file)):
        file[i] = file[i].split(",")
        sideEffect = file[i][len(file[i])-1]

        if(len(file[i])<4):
            continue

        if(sideEffect in sideEffectCountDict):
            sideEffectCountDict[sideEffect]+=1
        else:
            sideEffectCountDict[sideEffect]=1

    with open('sideEffectCount.csv', 'w') as f:
        f.write("sideEffect,count\n")

        for sideEffect in sideEffectCountDict:
            f.write("%s,%d\n"%(sideEffect,sideEffectCountDict[sideEffect]))

def sideEffectMatrix(file):
    file = file.read()
    file = file.split("\n")

    drugSideEffectDict = {}
    drugSet = set()
    sideEffectIdDict = {}
    countID = 1

    for i in range(len(file)):
        file[i] = file[i].split(",")
        if(len(file[i])<4):
            continue
        if(file[i][0] == "STITCH 1"):
            continue

        sideEffect = file[i][3]
        drug1 = file[i][0]
        drug2 = file[i][1]

        if(sideEffect not in sideEffectIdDict):
            sideEffectIdDict[sideEffect] = countID
            countID += 1

        if(drug1 not in drugSet):
            drugSet.add(drug1)

        if(drug1 not in drugSideEffectDict):
            drugSideEffectDict[drug1] = {}
        if(drug2 not in drugSideEffectDict[drug1]):
            drugSideEffectDict[drug1][drug2] = []


        if(drug2 not in drugSideEffectDict):
            drugSideEffectDict[drug2] = {}
        if(drug1 not in drugSideEffectDict[drug2]):
            drugSideEffectDict[drug2][drug1] = []

        # Add the side effects to the matrix
        drugSideEffectDict[drug1][drug2].append(sideEffectIdDict[sideEffect])
        drugSideEffectDict[drug2][drug1].append(sideEffectIdDict[sideEffect])

    #pp.pprint(drugSideEffectDict)

    # Write a random sample csv of interactions
    with open('sideEffectMatrix.csv', 'w') as f:
        f.write("Drug,")
        for drug in drugSet:
            f.write(drug)
            if(drug != "CID000004536"):
                f.write(",")
            else:
                f.write("\n")

        for drug1 in drugSet:
            f.write(drug1)
            f.write(",")
            for drug2 in drugSet:
                if(drug1 == drug2):
                    f.write("0")
                else:
                    if(drug2 in drugSideEffectDict[drug1]):
                        f.write("%d" %(drugSideEffectDict[drug1][drug2][randint(0,len(drugSideEffectDict[drug1][drug2])-1)]))
                    else:
                        f.write("0")
                if(drug2 != "CID000004536"):
                    f.write(",")
                else:
                    f.write("\n")





if __name__ == '__main__':

    #file = open("ChCh-Miner_durgbank-chem-chem.tsv")

    sideEffectFile = open("/Users/nicholascorbett/Documents/Classes/DataAnalytics/homework/finalProject/datasets/ChChSe-Decagon_polypharmacy.csv")


    #interactionCount(file)
    #interactionMatrixCSV(file)
    #sideEffectCount(sideEffectFile)
    sideEffectMatrix(sideEffectFile)
