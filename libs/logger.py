#!/usr/bin/env python
import sys,logging

class SMBFormatter(logging.Formatter):

  def __init__(self):
      logging.Formatter.__init__(self,'%(bullet)s %(message)s', None)

  def format(self, record):
    if record.levelno == logging.INFO:
      record.bullet = '[*]'
    elif record.levelno == logging.DEBUG:
      record.bullet = '[+]'
    elif record.levelno == logging.WARNING:
      record.bullet = '[!]'
    else:
      record.bullet = '[-]'

    return logging.Formatter.format(self, record)

def init():
    handler = logging.StreamHandler(sys.stdout)
    handler.setFormatter(SMBFormatter())
    logging.getLogger().addHandler(handler)
    logging.getLogger().setLevel(logging.INFO)
