/*
	Corona quick interactive buttons
	MastaMan
	v.1.0.4
	
	Press shift and click to Viewport Interactive for reset layout!
	
	Changelog:
	
	1.0.0 
		* Initial release
	1.0.1
		- BugFix: Interactive Viewport render only locked view
		* Now Interactive Viewport  restore original layout
	1.0.2
		- BugFix: Unstoppable Viewport Interactive render
		* Now  Interactive Viewport  restore user layout
		+ Added: Interactive Viewport render from active view
	1.0.3
		+ Added: Button for open VFB
	1.0.4
		- BugFix: 3Ds Max hanging
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
	r = renderers.current
	if(classOf r == CoronaRenderer) then (CoronaRenderer.CoronaFp.startInteractive()) else (messageBox "Please assign Corona Renderer" title: "Warning!")
)

macroScript mcrShowVFB
category:"[3DDD]" 
toolTip:"VFB" 
buttontext:"VFB"
(	
	r = renderers.current
	if(classOf r == CoronaRenderer) then (CoronaRenderer.CoronaFp.showVfb(true)) else (messageBox "Please assign Corona Renderer" title: "Warning!")
)


macroScript mcrStartInteractiveDocked
category:"[3DDD]" 
toolTip:"Viewport Interactive / Press Shift for reset layout" 
buttontext:"Viewport Interactive / Press Shift for reset layout"
Icon:#("Render", 8)
(	
	r = renderers.current
	if(classOf r != CoronaRenderer) do return (messageBox "Please assign Corona Renderer" title: "Warning!")
	
	iniSetting = getThisScriptFileName() + ".ini"
	
	fn saveVpt id =
	(
		viewport.activeViewport = id
		
		id = (viewport.GetID id) as string
		setIniSetting iniSetting id "TYPE"  (viewport.getType() as string)
		setIniSetting iniSetting id "TM"  (viewport.getTM() as string)
		setIniSetting iniSetting id "FOV"  (viewport.getFOV() as string)			
		vs = nitrousgraphicsmanager.GetActiveViewportSetting()
		setIniSetting iniSetting id "SHADING"  (vs.visualstylemode as string)
		setIniSetting iniSetting id "CAM" (viewport.getCamera() as string)
		setIniSetting iniSetting id "SAFEFRAME" (displaySafeFrames as string)
	)
	
	fn saveViewports =
	(
		if(viewport.getLayout() == #layout_2v) do return false
		
		setIniSetting iniSetting "VIEWPORT" "LAYOUT" (viewport.getLayout() as string)		
		
		a = viewport.activeViewport
		setIniSetting iniSetting "VIEWPORT" "ACTIVE" (a as string)
		
		n = viewport.numViews	

		setIniSetting iniSetting "VIEWPORT" "NUM" (n as string) 
			
		for id in 1 to n do saveVpt id			
	)
	
	fn restoreVpt id toID: undefined =
	(
		viewport.activeViewport = id
				
		id =  if(toID == undefined) then  (viewport.GetID id) as string else toID as string
				
		s = getIniSetting iniSetting id "TYPE" 
		if(s != "") do execute("viewport.setType #" + s)
		s = getIniSetting iniSetting id "TM" 
		if(s != "") do execute("viewport.setTm" + s)
		s = getIniSetting iniSetting id "FOV"
		if(s != "") do viewport.setFov (s as float)
			
		vs = nitrousgraphicsmanager.GetActiveViewportSetting()
		s = getIniSetting iniSetting id "SHADING"
		if(s != "") do vs.visualstylemode = execute("#" + s)
		
		s = getIniSetting iniSetting id "CAM"
		if(s != "" and s != "undefined") do try(viewport.setCamera (execute(s)))catch()
			
		s = getIniSetting iniSetting id "SAFEFRAME"
		if(s != "" and s != "false") do displaySafeFrames = true
	)
	
	fn restoreViewports =
	(		
		s = getIniSetting iniSetting "VIEWPORT" "LAYOUT" 
		if(s != "") do 
		(
			viewport.ResetAllViews()
			execute("viewport.setLayout #" + s)
		)
				
		s = getIniSetting iniSetting "VIEWPORT" "NUM" 
		if(s != "") do 
		(
			for id in 1 to (s as integer) do restoreVpt id
		)
		
		s = getIniSetting iniSetting "VIEWPORT" "ACTIVE" 
		if(s != "") do viewport.activeViewport = s as integer				
	)
	
	
	try
	(
		if(keyboard.shiftPressed) then
		(			
			restoreViewports()
		)
		else
		(				
			rendUseActiveView = true	
						
			bInteractive = (viewport.getLayout() != #layout_2v) or (viewport.getLayout() == #layout_2v and viewport.numViews == 2)
						
			if(bInteractive) then 
			(
				currentId = viewport.GetID (viewport.activeViewport)
				saveViewports()							
						
				viewport.ResetAllViews()
				viewport.setLayout #layout_2v
			
				viewport.activeViewport = 2
				actionMan.executeAction 0 "40406" 
											
				restoreVpt 1 toID: currentId
				
				forceCompleteRedraw()	
				CoronaRenderer.CoronaFp.startInteractiveDocked() 				
			)
				
			CoronaRenderer.CoronaFp.startInteractiveDocked() 
		)
	)catch(messageBox "Please assign Corona Renderer" title: "Warning!")
)


