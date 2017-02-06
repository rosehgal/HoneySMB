from libs.smbserver import SMBSERVER
from binascii import unhexlify
import ConfigParser
import sys

class SimpleSMBServer:
    def __init__(self, listenAddress='0.0.0.0', listenPort=4445, configFile=None):
        if configFile == None:
            print "[*] Config File Required"
            sys.exit(0)
        self.__smbConfig = configFile
        self.__server = SMBSERVER((listenAddress, listenPort), config_parser=self.__smbConfig)
        self.__server.processConfigFile()

        # Now we have to register the MS-SRVS server. This specially important for
        # Windows 7+ and Mavericks clients since they WONT (specially OSX)
        # ask for shares using MS-RAP.

        # self.__srvsServer = SRVSServer()
        # self.__srvsServer.daemon = True
        # self.__wkstServer = WKSTServer()
        # self.__wkstServer.daemon = True
        # self.__server.registerNamedPipe('srvsvc', ('127.0.0.1', self.__srvsServer.getListenPort()))
        # self.__server.registerNamedPipe('wkssvc', ('127.0.0.1', self.__wkstServer.getListenPort()))

    def start(self):
        # self.__srvsServer.start()
        # self.__wkstServer.start()
        self.__server.serve_forever()

    def registerNamedPipe(self, pipeName, address):
        return self.__server.registerNamedPipe(pipeName, address)

    def unregisterNamedPipe(self, pipeName):
        return self.__server.unregisterNamedPipe(pipeName)

    def getRegisteredNamedPipes(self):
        return self.__server.getRegisteredNamedPipes()

    def addShare(self, shareName, sharePath, shareComment='', shareType=0, readOnly='no'):
        self.__smbConfig.add_section(shareName)
        self.__smbConfig.set(shareName, 'comment', shareComment)
        self.__smbConfig.set(shareName, 'read only', readOnly)
        self.__smbConfig.set(shareName, 'share type', shareType)
        self.__smbConfig.set(shareName, 'path', sharePath)
        self.__server.setServerConfig(self.__smbConfig)
        #self.__srvsServer.setServerConfig(self.__smbConfig)
        self.__server.processConfigFile()
        #self.__srvsServer.processConfigFile()

    def removeShare(self, shareName):
        self.__smbConfig.remove_section(shareName)
        self.__server.setServerConfig(self.__smbConfig)
        #self.__srvsServer.setServerConfig(self.__smbConfig)
        self.__server.processConfigFile()
        #self.__srvsServer.processConfigFile()

    def setSMBChallenge(self, challenge):
        if challenge != '':
            self.__smbConfig.set('global', 'challenge', unhexlify(challenge))
            self.__server.setServerConfig(self.__smbConfig)
            self.__server.processConfigFile()

    def setLogFile(self, logFile):
        self.__smbConfig.set('global', 'log_file', logFile)
        self.__server.setServerConfig(self.__smbConfig)
        self.__server.processConfigFile()

    def setCredentialsFile(self, credFile):
        self.__smbConfig.set('global', 'credentials_file', credFile)
        self.__server.setServerConfig(self.__smbConfig)
        self.__server.processConfigFile()

    def setSMB2Support(self, value):
        if value is True:
            self.__smbConfig.set("global", "SMB2Support", "True")
        else:
            self.__smbConfig.set("global", "SMB2Support", "False")
        self.__server.setServerConfig(self.__smbConfig)
        self.__server.processConfigFile()


def main():
    smbConfig = ConfigParser.RawConfigParser()
    smbConfig.read('smb.conf')
    smbServer = SimpleSMBServer(configFile=smbConfig)

    shareConfig = ConfigParser.RawConfigParser()
    shareConfig.read("shares.conf")

    shareNames = [i.strip() for i in shareConfig.get('shareNames','share_names').split(',')]
    for shareName in shareNames:
        comment = shareConfig.get(shareName,'comment')
        readOnly = shareConfig.get(shareName,'read_only')
        shareType = shareConfig.get(shareName,'share_type')
        path = shareConfig.get(shareName,'path')
        smbServer.addShare(shareName=shareName,sharePath=path,shareComment=comment,shareType=shareType,readOnly=readOnly)
        smbServer.setSMBChallenge('12345678abcdef00')

    smbServer.start()

if __name__ == "__main__":
    main()




# import sys
# import argparse
# import logging
#
# from libs import logger
# from libs import smbserver, version
#
# if __name__ == '__main__':
#
#     # # Init the example's logger theme
#     # logger.init()
#     # print version.BANNER
#     #
#     # parser = argparse.ArgumentParser(add_help = True, description = "This script will launch a SMB Server and add a "
#     #                                  "share specified as an argument. You need to be root in order to bind to port 445. "
#     #                                  "No authentication will be enforced. Example: smbserver.py -comment 'My share' TMP "
#     #                                  "/tmp")
#     #
#     # parser.add_argument('shareName', action='store', help='name of the share to add')
#     # parser.add_argument('sharePath', action='store', help='path of the share to add')
#     # parser.add_argument('-comment', action='store', help='share\'s comment to display when asked for shares')
#     # parser.add_argument('-debug', action='store_true', help='Turn DEBUG output ON')
#     # parser.add_argument('-smb2support', action='store_true', default=False, help='SMB2 Support (experimental!)')
#     #
#     # if len(sys.argv)==1:
#     #     parser.print_help()
#     #     sys.exit(1)
#     #
#     # try:
#     #    options = parser.parse_args()
#     # except Exception, e:
#     #    logging.critical(str(e))
#     #    sys.exit(1)
#     #
#     # if options.debug is True:
#     #     logging.getLogger().setLevel(logging.DEBUG)
#     # else:
#     #     logging.getLogger().setLevel(logging.INFO)
#     #
#     # if options.comment is None:
#     #     comment = ''
#     # else:
#     #     comment = options.comment
#     #
#     # server = smbserver.SimpleSMBServer()
#     #
#     # server.addShare(options.shareName.upper(), options.sharePath, comment)
#     # server.setSMB2Support(options.smb2support)
#     #
#     # # Here you can set a custom SMB challenge in hex format
#     # # If empty defaults to '4141414141414141'
#     # # (remember: must be 16 hex bytes long)
#     # # e.g. server.setSMBChallenge('12345678abcdef00')
#     # server.setSMBChallenge('')
#     #
#     # # If you don't want log to stdout, comment the following line
#     # # If you want log dumped to a file, enter the filename
#     # #server.setLogFile('')
#     #
#     # # Rock and roll
#     # server.start()
#
