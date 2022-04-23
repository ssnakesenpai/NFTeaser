# this script will listen for the events and then push the notifcation to EPNS

from brownie import *
import requests
import json

NFLaddress = ''
NFLabi = ""

def runFilter():
    filter = web3.eth.contract(address=NFLaddress, abi=NFLabi).events.Sync.createFilter(fromBlock='latest')
    data = filter.get_new_entries()
    return data

def sendToNPM(data):
    url = "http://localhost:3000"
    headers = {'Content-type': 'application/json', 'Accept': 'text/plain'}
    r = requests.post(url, data=json.dumps(data), headers=headers)
    return True

data = runFilter()

sendToNPM(data)




