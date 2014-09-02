#Log Sbwriel by SBBS and the Snowdonia Society

##Introduction

Log Sbwriel (Welsh for Litter Log) is a simple GPS mobile litter survey app built using Processing for Android by SBBS (www.sbbs.org.uk) and the Snowdonia Society (www.snowdonia-society.org.uk). It uses the GPS in your Android phone or tablet to locate the positions at which you record finding different types of litter using graphical icons on the main app screen. And, being produced in Wales, Log Sbwriel is fully bi-lingual allowing use by Welsh and English speakers (and it’s easily changed if you prefer a different language).

Littering is a problem we all see every day and it reduces the quality of our lives and the places around us. It’s also something that’s difficult and costly to address, as well as having many damaging environmental effects. That’s why we developed this app: to help empower Welsh Citizen Scientists to create open data relating to littering problems, hot-spots and behaviour, including using open-source methods so they can easily improve it for their own needs. So hopefully, like us, you’ll find Log Sbwriel useful for generating geo-referenced litter data, in which case you can find out more about our data at http://figshare.com/authors/OpenData_SBBSBangor/574716.

You’ll find the code, icons and images needed to build this project in the source code folder here, as well as some screen shots of Log Sbwriel running on a real Android device, in the screenshots folder, if you just want an idea of how nice it looks.

To read more information about the Snowdonia Society’s Snowdon Tidy initiative please visit this page: http://www.snowdonia-society.org.uk/news.php?n_id=443. And to get our companion litter web-mapping code, to display Log Sbwriel logs on your website, please visit this page: https://github.com/sbbsbangor/Log-Sbwriel-Digital-Map.

**Please note:** To get correct pronunciation of Welsh on your Android device you need to use a text-to-speech library that understands the language. The standard Android speech engine will get it wrong, but using a Welsh-specific one from the Google Play Store (e.g. Ivona HQ and Welsh pack) provides very nice Welsh voice output with good pronunciation.

##Litter log files

Log Sbwriel saves logs in CSV (comma-separated values) format that you can easily open in spreadsheets such as within Open Office or Microsoft Office. With little work you should also be able to use them in Google Docs to create a fusion table that will generate a Google Map with markers (and which can also be used to produce a stunning heat map so people can visualise your data).

Log files are stored in the ‘Log sbwriel’ folder on your device (created the first time you run the app) so you can transfer them to another device the same way you would for any other file (e.g. USB cable, email, dropbox, or even upload straight to your website). On this SBBS GitHub repository you’ll also find our basic framework for sharing your litter logs on your own website (see link above), with selectable map markers for each litter type and automatically generated results tables. We’ve tried to make that simple and friendly to use, basing it around Processing.js, so we hope you have a look at it too.

For more advanced users, the files should be easily used with most GIS (Geographical Information System) software packages. For reference, the columns in the log files are: latitude, longitude, litter type value, date/time, litter type description, milliseconds since last GPS fix, GPS altitude and GPS accuracy. Latitude and longitude will be WGS-84 as you’d expect from Android GPS data. Of course, if you’d like to save different data, or in a format different to CSV, you can change it in the source code.

##Running and using Log Sbwriel

Log Sbwriel has been written using the Processing programming language to make it easy and friendly to use. To compile it you will need to download Processing (www.processing.org) and follow their instructions to use it and install the Android mode if you haven’t done that before. A full description of using Processing, and creating Android apps, would be impossible here, but being a free and open-source project too, processing.org has plenty of resources to get you going quickly. And more advanced users can use the Processing program to export Log Sbwriel for use in other programming environments (e.g. Eclipse).

When you’ve compiled Log Sbwriel and installed it on your Android device, simply tap the icon and you’ll see the splash screen appear. After a few seconds it should disappear and be replaced by a GPS status screen that will either tell you it’s waiting for a fix or remind you to turn on GPS location and try again. When a fix is obtained the app switches to the main logging screen, with tiles that can be tapped whenever you want to log an item of litter (at which time it’ll show a confirmation screen, with the litter type, for a second or two, as well as speaking it). Using Log Sbwriel is really as simple as that: just tap the litter tiles when you want to log and the details and location will be saved for you.

Those tiles are intended to cover the main categories of litter we’ve found in Snowdonia and North Wales. Mostly that’s drink containers (i.e. cans and bottles), fruit peel, smoking items, fast food containers and dog poo (in and out of bags). By logging those items you can even deduce quite a bit about human-behaviour at litter hotspots, and the types of people likely to be involved, so we’ve also included separate alcohol-drink container tiles (the red ones with the red X’s) to add to those behavioural insights. And, of course, the litter log you create can also be used to calculate the environmental emissions and embodied energy of waste lying around our countryside. The ‘Arall’/‘Other’ tile covers anything else you think important to log, which we’ve found mostly covers little items like crisp/sweet packets, paper, lolly sticks, and suchlike.

The app defaults to using Welsh for all text and speech. To use English you only need to change the value of the ‘language’ variable near the top of the code, as compatible Welsh/English texts are already included. If you prefer to use different litter types, different descriptions, different images, or even a different language, the advantage of Log Sbwriel being open source is that it provides a framework for you to do so easily. And there’s no reason why you shouldn’t even adapt LogSbwriel for GPS logging other environmental features and impacts too.

We hope you have fun logging litter with Log Sbwriel :-)

##Credits

Log Sbwriel was created as an R&D collaboration between the Snowdonia Society and SBBS, Bangor University, through the WISE Network project (http://www.wisenetwork.org). Development, programming and graphics by Dr Andrew Thomas. Copyright 2014 Snowdonia Society, SBBSBangor and Andrew Thomas.


