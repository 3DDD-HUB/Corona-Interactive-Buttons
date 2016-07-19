/*
	Corona quick interactive buttons
	MastaMan
	v.1.0.0
	
	Press shift and click to Viewport Interactive for reset layout!
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
	try
	(
		if(keyboard.shiftPressed) then
		(
			viewport.ResetAllViews()
		)
		else
		(
			viewport.ResetAllViews()
			viewport.setLayout #layout_2v
			viewport.activeViewport = 2
			actionMan.executeAction 0 "40406" 
			CoronaRenderer.CoronaFp.startInteractiveDocked()
		)
	)catch(messageBox "Please assign Corona Renderer" title: "Warning!")
)


