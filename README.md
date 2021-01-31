robotframework-gorest
# How to setup & run code automation robot-framework

        ##Tools Needed:

        -Python 2.7x
        -WxPython for Python 2.8
        -ChromeDriver (for connecting robotframework with your browser)
        -RobotFramework, RIDE, and its supporting libraries

        ##Instalation:

        ##Python 2.7x
        Installing python
        Note: Currently robot framework works with python 2.7.x (even though Python 3.x already available).
        Go to https://www.python.org/downloads
    

        ##Adding Python to Environment Variable
        -After installing python (the default directory on windows is C:\Python27), you have to add it to environment variables
        -Click start, and type “environment”
        -Choose “Edit the system environment variable”
        -Click “Environment Variables”
        -On System Variable, choose “Path”, and click Edit
        -Add C:\Python27, C:\Python27\Scripts, and C:\Python27\Tools\Scripts). After that, click OK

        To see if it’s working, open command prompt, and type “python --version”, and then type “pip”

        ##WxPython for 2.8.x
        Wxpython is required by RIDE in order to show the GUI
        Go to https://sourceforge.net/projects/wxpython/files/wxPython/2.8.12.1/

        ##Chrome Driver:
        -ChromeDriver is required in order to connect robotframework with your browser (web testing)
        -Open environment variable setting (refer to “Adding Python to Environment Variable”
        -Open command prompt, and type “chromedriver --version” to verify


        ##RobotFrameWork, VSCODE, and it’s supporting libraries
        ##Installing RobotFramework
        ##RobotFramework the automation scripting language that we will use here:
        -Open command prompt
        -Type “pip install robotframework”


        ##Installing VSCODE and extension for robot framewok
        ##Extension:
        -Robot framework Intellisense
        -RobotF Extension
        -Robot Framework languange
        -Robot Framework helper


        ##Checking pip packages installed
        -Open command prompt
        -Type “pip freeze”. It should show list of packages that installed in your system. It should look like this

        ##Installing RobotFramework supporting libraries
        ##Install these packages below to install supporting libraries :
            -open comand prompt
            -Pip install robotframework-selenium2library
            -Pip install robotframework faker
            -Pip install robotframework-appiumlibrary
            -Pip install robotframework-requests
            -Pip install robotframework-httplibrary
    

    ###HOw to run test suites Gorest_api_testing.robot
    -open terminal
    -type: robot Gorest_api_testing.robot



