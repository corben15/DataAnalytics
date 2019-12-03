'''
Nicholas Corbett
Data Analytics

'''

import csv

if __name__ == '__main__':

    file = open("ChCh-Miner_durgbank-chem-chem.tsv")

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


    with open('test.csv', 'w') as f:
        for key in drugInteractionCountDict.keys():
            f.write("%s,%s\n"%(key,len(drugInteractionCountDict[key])))
