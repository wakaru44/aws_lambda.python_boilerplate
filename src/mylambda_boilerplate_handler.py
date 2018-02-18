#!/usr/bin/python
# -*- utf-8 -*-


import datetime
import logging
import json

class Message(object):
    def __init__(self, verbose=False):
        self.verbose = verbose


log = logging.getLogger()
log.setLevel(logging.INFO)

def handler(event, context):
    """
    minimal AWS lambda handler
    """
    log.info("Yay!")
    variables=os.environ.get('LAMBDA_VARS')
    log.info(repr(variables))
    msg={}
    msg["event"]=repr(event)
    msg["context"]=repr(context)
    msg["timestamp"]=datetime.datetime.now().strftime("%F - %H:%M")
    return { "message":json.dumps(msg) }

if __name__=="__main__":
    print "TODO: put some local testing in here"
    print lambda_handler("evento","contexto")
