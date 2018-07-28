ALTER DATABASE [$(DatabaseName)]
    ADD FILE (NAME = [cpr_Data], FILENAME = '$(DefaultDataPath)\$(DatabaseName).mdf', SIZE = 1426304 KB, FILEGROWTH = 10 %) TO FILEGROUP [PRIMARY];



