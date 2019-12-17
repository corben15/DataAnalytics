'''
Nicholas Corbett
Data Analytics Final Project: Drug Interactions
Preliminary Calculations
'''

import math
import pprint
pp = pprint.PrettyPrinter(indent=4, depth=4)





if __name__ == '__main__':

    file = open("/Users/nicholascorbett/Documents/Classes/DataAnalytics/homework/finalProject/datasets/ChChSe-Decagon_polypharmacy.csv")

    file = file.read()
    file = file.split("\n")
    sideEffectSet = set()
    drugsSet = set()
    sideEffectCount = {}
    for i in range(len(file)):
        file[i] = file[i].split(",")

        sideEffect = file[i][len(file[i])-1]

        sideEffectSet.add(file[i][len(file[i])-1])
        if(len(file[i])<4):
            continue
        if(sideEffect in sideEffectCount):
            sideEffectCount[sideEffect]+=1
        else:
            sideEffectCount[sideEffect]=1

        drugsSet.add(file[i][0])
        drugsSet.add(file[i][1])


    print("There are %d interactions in the dataset" %(len(file)))
    print("There are %d side effects" %(len(sideEffectSet)))
    print("There are %d drugs" %(len(drugsSet)))
    print(sideEffectCount)
