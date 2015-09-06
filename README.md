# PSLogging

## Introduction
This is a PowerShell module that I created to easily be able to create and manage log files (and error handling) for all of your PowerShell scripts.

Using the PSLogging module to handle all of your PowerShell Logging requirements provides you with the following functionality:

- Creates a new .log files and initialise the log with execution date, time and script version
- End the PowerShell Logging process and write ending date and time. Optionally terminates the calling script (if required)
- Send an email with the contents of the log file to a specified set of email addresses
- Writes informational, warning and error messages to the log  file (all in their own unique and easy to read formatting)

## History of Development
Sometime back in 2011 when I first started using PowerShell, I developed some standard functions to handle the creating and management of log files for my PowerShell scripts. These functions were stored in a file called Logging_Functions.ps1 and I would simply dot source them into my script to be able to use them.

I posted them on my website 9to5IT - [PowerShell: How to easily create log files for your scripts](http://9to5it.com/powershell-logging-function-library/) and since then, to my surprise, they have been well received by many people, and hence the post has become quite a popular one. Recently one of the users emailed me and made a suggestion to convert them into a PowerShell Module.

That got me thinking.... so I have made a number of improvements to the PowerShell logging functions and have now made them available as a PowerShell Logging module and called it PSLogging.

For more information on the PSLogging module and for detailed help information (and support) please see [PowerShell Logging V2 - Easily create log files](http://9to5IT.com/powershell-logging-v2-easily-create-log-files).

## Installation Instructions
Follow these steps to install and start using the my PowerShell Logging solution:

#### Any PowerShell Version
1. Download the PSLogging directory from the Modules folder in this repo
2. Copy the PSLogging directory (and its contents) to your `PSModulePath` location. This can be either of the following locations:
	1. **Install for Current User** - `$Home\Documents\WindowsPowerShell\Modules (%UserProfile%\Documents\WindowsPowerShell\Modules)`
	2. **Install for All Users** - `$Env:ProgramFiles\WindowsPowerShell\Modules (%ProgramFiles%\WindowsPowerShell\Modules)`
	3. For more information see [Microsoft TechNet - Installing PowerShell Modules](https://technet.microsoft.com/en-us/library/dd878350(v=vs.85).aspx)
3. To use PSLogging, in the script you want to use it (or in your current PowerShell environment) run `Import-Module PSLogging`.
4. You will now be able to call all of the PSLogging cmdlets just like you would any other cmdlet. In addition you can run `Get-Help <cmdlet_name> -Full` on any of the PSLogging cmdlets to get full detailed help and examples.

#### PowerShell v5 (Install PSLogging)
1. From PowerShell, run `Install-Module PSLogging -Scope CurrentUser`
2. To use PSLogging, in the script you want to use it (or in your current PowerShell environment) run `Import-Module PSLogging`.
3. You will now be able to call all of the PSLogging cmdlets just like you would any other cmdlet. In addition you can run `Get-Help <cmdlet_name> -Full` on any of the PSLogging cmdlets to get full detailed help and examples.

#### PowerShell v5 (Update PSLogging)
1. From PowerShell, run `Update-Module PSLogging -Force`
2. The latest version of PSLogging will automatically install

<u>Note 1:</u> To be able to use `Install-Module` and `Update-Module` in PowerShell 5, you need to run it on a machine that has an internet connection. If your machine cannot connect to the internet, then follow the *Any PowerShell Version* install section above.

<u>Note 2:</u> If you want to have the PSLogging module available in all of your PowerShell sessions, then once you have installed it you can add the `Import-Module PSLogging` command to your PowerShell Profile. For more information see - [Understanding and Using PowerShell Profiles](http://blogs.technet.com/b/heyscriptingguy/archive/2013/01/04/understanding-and-using-powershell-profiles.aspx).

## How To Create Log Files using PSLogging
The best and most easiest way would be to use one of my pre-developed PowerShell Script Templates which have been included in this repo under the **Script Templates** directory. In this directory you will find the following four templates:

1. PowerShell Script Template with logging
2. PowerShell Script Template with no logging
3. PowerCLI Script Template with logging
4. PowerCLI Script Template with no logging

For more information on how each of these templates work please see the following links:

- [Help - PowerShell Script Template Version 2](http://9to5IT.com/powershell-script-template-version-2)
- [Help - PowerCLI Script Template Version 2](http://9to5IT.com/powercli-script-template-version-2)

## Additional Help
If you are still not sure on how to use either the PSLogging module or any of my PowerShell Script Templates, then the best thing to do is visit me at [9to5IT](http://9to5IT.com) and either post a comment on any of the relevant articles, or click on the contact page and shoot me an email. Alternatively, you can get a hold of me on [admin@9to5IT.com](mailto:admin@9to5IT.com).

Here are some links to some helpful information:

- [Help - PowerShell Logging V2 - Easily create log files](http://9to5IT.com/powershell-logging-v2-easily-create-log-files)
- [Help - PowerShell Script Template Version 2](http://9to5IT.com/powershell-script-template-version-2)
- [Help - PowerCLI Script Template Version 2](http://9to5IT.com/powercli-script-template-version-2) 

Thanks
Luca


