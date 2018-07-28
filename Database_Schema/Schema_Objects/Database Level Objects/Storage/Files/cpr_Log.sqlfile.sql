ALTER DATABASE [$(DatabaseName)]
    ADD LOG FILE (NAME = [cpr_Log], FILENAME = '$(DefaultLogPath)\$(DatabaseName)_3.ldf', SIZE = 3094592 KB, FILEGROWTH = 10 %);



