ALTER DATABASE [$(DatabaseName)]
    ADD FILE (NAME = [cpr_attachments], FILENAME = '$(DefaultDataPath)\$(DatabaseName)_1.ndf', SIZE = 46592 KB, FILEGROWTH = 10 %) TO FILEGROUP [ATTACHMENTS];



