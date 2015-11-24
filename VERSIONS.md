### PSLogging module detailed version history - the module version 3.0.0
## The last update: 24/11/2015

The Module v. 3.0.0 
Date: 24/11/2015
Content
Send-Log - v. 1.3
Start-Log - v. 1.5
Stop-Log - v. 1.7
Write-LogEntry - v. 1.2
Write-LogInfo - v. 2.1
Write-LogError - v.2.1
Write-LogWarning - v. 2.1

##Function: Start-Log

Version: 1.0
Author: Luca Sturlese
Creation Date:  10/05/12
Purpose/Change: Initial function development.

Version: 1.1
Author: Luca Sturlese
Creation Date:  19/05/12
Purpose/Change: Added debug mode support.

Version: 1.2
Author: Luca Sturlese
Creation Date:  02/09/15
Purpose/Change: Changed function name to use approved PowerShell Verbs. Improved help documentation.

Version: 1.3
Author: Luca Sturlese
Creation Date:  07/09/15
Purpose/Change: Resolved issue with New-Item cmdlet. No longer creates error. Tested - all ok.

Version: 1.4
Author: Luca Sturlese
Creation Date:  12/09/15
Purpose/Change: Added -ToScreen parameter which will display content to screen as well as write to the log file.

Version: 1.5
Author: Wojciech Sciesinski, wojciech[at]sciesinski[dot]net
Purpose/Change: 
Creation Date:  24/11/2015

##Function: Write-LogEntry

Version: 1.0.0
Author: Wojciech Sciesinski, wojciech[at]sciesinski[dot]net
Purpose/Change: Initial function development.
Creation Date:  25/10/2015

Version 1.1.0
Author: Wojciech Sciesinski, wojciech[at]sciesinski[dot]net
Purpose/Change: A date for a message can be declared as parameter, version number corrected 2.0.0 > 1.0.0 corrected
Creation Date:  26/10/2015

Version 1.2.0
Author: Wojciech Sciesinski, wojciech[at]sciesinski[dot]net
Purpose/Change: 
Creation Date:  24/11/2015

##Function: Write-LogInfo

Version: 1.0
Author: Luca Sturlese
Creation Date:  10/05/12
Purpose/Change: Initial function development.

Version: 1.1
Author: Luca Sturlese
Creation Date:  19/05/12
Purpose/Change: Added debug mode support.

Version: 1.2
Author: Luca Sturlese
Creation Date:  02/09/15
Purpose/Change: Changed function name to use approved PowerShell Verbs. Improved help documentation.

Version: 1.3
Author: Luca Sturlese
Creation Date:  02/09/15
Purpose/Change: Changed parameter name from LineValue to Message to improve consistency across functions.

Version: 1.4
Author: Luca Sturlese
Creation Date:  12/09/15
Purpose/Change: Added -TimeStamp parameter which append a timestamp to the end of the line. Useful for knowing when a task started and stopped.

Version: 1.5
Author: Luca Sturlese
Creation Date:  12/09/15
Purpose/Change: Added -ToScreen parameter which will display content to screen as well as write to the log file.

Version:2.0
Author: Wojciech Sciesinski, wojciech[at]sciesinski[dot]net
Purpose/Change: Changed format of logs displayed and saved to file, function changed to be wrapper for Write-LogEntry
Creation Date:  25/10/2015

Version: 2.1
Author: Wojciech Sciesinski, wojciech[at]sciesinski[dot]net
Creation Date: 24/11/2015
Purpose/Change:Version history moved to the VERSION file

##Function: Write-LogWarning

Version:1.0
Author: Luca Sturlese
Creation Date:  02/09/15
Purpose/Change: Initial function development.

Version:1.1
Author: Luca Sturlese
Creation Date:  12/09/15
Purpose/Change: Added -TimeStamp parameter which append a timestamp to the end of the line. Useful for knowing when a task started and stopped.

Version:1.2
Author: Luca Sturlese
Creation Date:  12/09/15
Purpose/Change: Added -ToScreen parameter which will display content to screen as well as write to the log file.

Version:2.0
Author: Wojciech Sciesinski, wojciech[at]sciesinski[dot]net
Purpose/Change: Changed format of logs displayed and saved to file, function changed to be wrapper for Write-LogEntry
Creation Date:  25/10/2015

Version: 2.1
Author: Wojciech Sciesinski, wojciech[at]sciesinski[dot]net
Creation Date: 24/11/2015
Purpose/Change:Version history moved to the VERSION file

Function: Write-LogError

Version:1.0
Author: Luca Sturlese
Creation Date:  10/05/12
Purpose/Change: Initial function development.

Version:1.1
Author: Luca Sturlese
Creation Date:  19/05/12
Purpose/Change: Added debug mode support. Added -ExitGracefully parameter functionality.

Version:1.2
Author: Luca Sturlese
Creation Date:  02/09/15
Purpose/Change: Changed function name to use approved PowerShell Verbs. Improved help documentation.

Version:1.3
Author: Luca Sturlese
Creation Date:  02/09/15
Purpose/Change: Changed parameter name from ErrorDesc to Message to improve consistency across functions.

Version:1.4
Author: Luca Sturlese
Creation Date:  03/09/15
Purpose/Change: Improved readability and cleaniness of error writing.

Version:1.5
Author: Luca Sturlese
Creation Date:  12/09/15
Purpose/Change: Changed -ExitGracefully parameter to switch type so no longer need to specify $True or $False (see example for info).

Version:1.6
Author: Luca Sturlese
Creation Date:  12/09/15
Purpose/Change: Added -TimeStamp parameter which append a timestamp to the end of the line. Useful for knowing when a task started and stopped.

Version:1.7
Author: Luca Sturlese
Creation Date:  12/09/15
Purpose/Change: Added -ToScreen parameter which will display content to screen as well as write to the log file.

Version:2.0
Author: Wojciech Sciesinski, wojciech[at]sciesinski[dot]net
Purpose/Change: Changed format of logs displayed and saved to file, function changed to be wrapper for Write-LogEntry
Creation Date:  25/10/2015

Version: 2.1
Author: Wojciech Sciesinski, wojciech[at]sciesinski[dot]net
Creation Date: 24/11/2015
Purpose/Change:Version history moved to the VERSION file


##Function Stop-Log
Version:1.0
Author: Luca Sturlese
Creation Date:  10/05/12
Purpose/Change: Initial function development.

Version:1.1
Author: Luca Sturlese
Creation Date:  19/05/12
Purpose/Change: Added debug mode support.

Version:1.2
Author: Luca Sturlese
Creation Date:  01/08/12
Purpose/Change: Added option to not exit calling script if required (via optional parameter).

Version:1.3
Author: Luca Sturlese
Creation Date:  02/09/15
Purpose/Change: Changed function name to use approved PowerShell Verbs. Improved help documentation.

Version:1.4
Author: Luca Sturlese
Creation Date:  12/09/15
Purpose/Change: Changed -NoExit parameter to switch type so no longer need to specify $True or $False (see example for info).

Version:1.5
Author: Luca Sturlese
Creation Date:  12/09/15
Purpose/Change: Added -ToScreen parameter which will display content to screen as well as write to the log file.

Version:1.6
Author: Wojciech Sciesinski, wojciech[at]sciesinski[dot]net
Purpose/Change: Changed format of logs displayed and saved to file, function changed to be wrapper for Write-LogEntry
Creation Date:  25/10/2015

Version: 1.7
Author: Wojciech Sciesinski, wojciech[at]sciesinski[dot]net
Creation Date: 24/11/2015
Purpose/Change:Version history moved to the VERSION file


##Function Send-Log
Version:1.0
Author: Luca Sturlese
Creation Date:  05.10.12
Purpose/Change: Initial function development.

Version:1.1
Author: Luca Sturlese
Creation Date:  02/09/15
Purpose/Change: Changed function name to use approved PowerShell Verbs. Improved help documentation.

Version:1.2
Author: Luca Sturlese
Creation Date:  02/09/15
Purpose/Change: Added SMTPServer parameter to pass SMTP server as oppposed to having to set it in the function manually.

Version: 1.3
Author: Wojciech Sciesinski, wojciech[at]sciesinski[dot]net
Creation Date: 24/11/2015
Purpose/Change:Version history moved to the VERSION file