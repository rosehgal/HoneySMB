from libs.smbserver import SMBSERVER
from binascii import unhexlify
import ConfigParser
import sys


class SimpleSMBServer:
    def __init__(self, listenAddress='0.0.0.0', listenPort=445, configFile=None):
        if configFile == None:
            print "[*] Config File Required"
            sys.exit(0)
        self.__smbConfig = configFile
        self.__server = SMBSERVER((listenAddress, listenPort), config_parser=self.__smbConfig)
        self.__server.processConfigFile()

    def start(self):
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
        self.__server.processConfigFile()

    def removeShare(self, shareName):
        self.__smbConfig.remove_section(shareName)
        self.__server.setServerConfig(self.__smbConfig)
        self.__server.processConfigFile()

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
    smbConfig.read('/home/smb/smb.conf')
    smbServer = SimpleSMBServer(configFile=smbConfig)

    shareConfig = ConfigParser.RawConfigParser()
    shareConfig.read("/home/smb/shares.conf")

    shareNames = [i.strip() for i in shareConfig.get('shareNames', 'share_names').split(',')]
    for shareName in shareNames:
        comment = shareConfig.get(shareName, 'comment')
        readOnly = shareConfig.get(shareName, 'read_only')
        shareType = shareConfig.get(shareName, 'share_type')
        path = shareConfig.get(shareName, 'path')
        smbServer.addShare(shareName=shareName, sharePath=path, shareComment=comment, shareType=shareType,
                           readOnly=readOnly)
        smbServer.setSMB2Support(True);

    smbServer.start()


if __name__ == "__main__":
    main()
