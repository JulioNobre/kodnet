
* KODNET (contacto@kodhe.com)
* Download File asynchronous example

do fullpath("kodnet.prg")

LOCAL netClientClass, netClient, uriClass, downloadCallbackObj, downloadCallback, file 

* select a file
file= GETFILE()
IF EMPTY(m.file)
	RETURN MESSAGEBOX("Please select a file",64,"")
ENDIF 

uriClass= _screen.kodnet.getStaticWrapper("System.Uri")
netClientClass= _screen.kodnet.getStaticWrapper("System.Net.WebClient")
m.netClient= m.netClientClass.construct()





downloadCallbackObj= CREATEOBJECT("downloadCallback")
* create a delegate that point to VisualFoxPro function
downloadCallback=_screen.kodnetManager.createeventhandler(m.downloadCallbackObj, "finished", "System.ComponentModel.AsyncCompletedEventHandler")
* add the event handler 
m.netClient.add_DownloadFileCompleted(m.downloadCallback)

* this method is a .NET async method, this call will complete without finish the download
m.netClient.DownloadFileAsync(uriClass.construct("http://storage-ns01.d0stream.com/.drive/Projects/ffmpeg.tar.gz"), m.file)

* this executes before finish for demostrate that method is called async
? "Download has started. Running in background"
return 

DEFINE CLASS downloadCallback  as Custom 
	FUNCTION finished(sender, args)
		* avoid memory leaks (this is only required for objects not forms)
		this._event.destroy()
		IF !ISNULL(args.Error)
			MESSAGEBOX("Failed download: " + args.Error.Message, 48, "")
		ELSE 
			? "download finished"
			MESSAGEBOX("Finished download.", 64, "")
		ENDIF 
	ENDFUNC 
ENDDEFINE 
