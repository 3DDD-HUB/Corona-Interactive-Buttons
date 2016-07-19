/*
	Corona quick interactive buttons
	MastaMan
	v.1.0.1
	
	Press shift and click to Viewport Interactive for reset layout!
	
	Changelog:
	
	1.0.0 
		* Initial release
	1.0.1
		- BugFix: Interactive Viewport render only locked view
		* Now Interactive Viewport  restore original layout
*/

m = "Corona Interactive Buttons\n\n"
m += "How to add buttons on toolbar?\n"
m += "1. Go to dropdown menu \"Customize\"\n"
m += "2. Select item \"Customize User Interface\"\n"
m += "3. Open tab \"Toolbars\"\n"
m += "4. Select category \"[3DDD]\"\n"
m += "5. DragAndDrop \"Start Interactive\" or \"Viewport Interactive\" on toolbar\n\n\n"
m += "Note: Press Shift and click the button \"Viewport Interactive\" for reset layout!"

messageBox m title: "Installed Success!" beep: false

macroScript mcrStartInteractive
category:"[3DDD]" 
toolTip:"Start Interactive" 
buttontext:"Start Interactive"
Icon:#("Render", 1)
(	
	try(CoronaRenderer.CoronaFp.startInteractive())catch(messageBox "Please assign Corona Renderer" title: "Warning!")
)


macroScript mcrStartInteractiveDocked
category:"[3DDD]" 
toolTip:"Viewport Interactive" 
buttontext:"Viewport Interactive"
Icon:#("Render", 8)
(	
	iniSetting = getThisScriptFileName() + ".ini"
	
	fn defaultView = 
	(				
		viewport.setType #view_front
		viewport.setType #view_persp_user 		
					
		theAxis = (viewport.getTM()).row1	
		viewport.rotate (quat 20 theAxis)
	
		theAxis = (viewport.getTM()).row3
		viewport.rotate (quat 40 theAxis)
		
		max tool zoomextents all
		viewport.zoom 0.8
		
		displaySafeFrames = true				
	)
	
	try
	(
		if(keyboard.shiftPressed) then
		(
			t = getIniSetting iniSetting "VIEWPORT" "LAYOUT"
	
			if(t != "") do execute("viewport.setLayout #" + t)
		)
		else
		(
			if(viewport.getLayout() != #layout_2v) do setIniSetting iniSetting "VIEWPORT" "LAYOUT" (viewport.getLayout())
			
			viewport.ResetAllViews()
			viewport.setLayout #layout_2v
			viewport.activeViewport = 2
			actionMan.executeAction 0 "40406" 
			viewport.activeViewport = 1
			rendUseActiveView = true						
			viewport.setType #view_persp_user
			
			defaultView()
						
			CoronaRenderer.CoronaFp.startInteractiveDocked()
		)
	)catch(messageBox "Please assign Corona Renderer" title: "Warning!")
)


