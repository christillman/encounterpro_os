ALTER DATABASE [$(DatabaseName)]
    ADD FILE (NAME = [cpr_workflow], FILENAME = '$(DefaultDataPath)\$(DatabaseName)_2.ndf', SIZE = 1024000 KB, FILEGROWTH = 10 %) TO FILEGROUP [Workflow];



