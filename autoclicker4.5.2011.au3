#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <ComboConstants.au3>
#include <Misc.au3>
#Include <GuiListView.au3>

Opt('MustDeclareVars', 1)

HotKeySet("^r", "record")
HotKeySet("^p", "playback")

Global $listview, $button1, $button2, $button3, $button4, $msg
	Global $input1, $input2, $input3, $input4, $input5
	Global $str, $tmp, $i
	Global $record, $playback
	Global $button5, $button6, $dll, $PARENT
	Global $timerinit, $timerdiff
	Global $child, $label, $label2
	
global $startvalue = 22

Example()

Func swap(ByRef $a, ByRef $b)  ;swap the contents of two variables
    Local $t
    $t = $a
    $a = $b
    $b = $t
EndFunc

Func record()
	$dll = DllOpen("user32.dll")
	GUISetState(@SW_DISABLE, $PARENT)
	GUISetState(@SW_HIDE, $PARENT)
	GUISetState(@SW_SHOW, $child)
	GUICtrlSetData($label2,"Press the 'esc' key to stop recording")
				
				$timerinit = TimerInit()
				
				while 1
					Sleep(10)
					If _IsPressed("1B", $dll) Then
						ExitLoop
					ElseIf _IsPressed("01", $dll) Then ; left click
						
						$tmp = MouseGetPos()
						$timerdiff = TimerDiff($timerinit)
						$timerdiff = Round($timerdiff)
						$str = 'LD' & Opt("GUIDataSeparatorChar") & $tmp[0]
						$str = $str & Opt("GUIDataSeparatorChar") & $tmp[1]
						$str = $str & Opt("GUIDataSeparatorChar") & $timerdiff
						$timerinit = TimerInit()
						GUICtrlCreateListViewItem($str, $listview)
						$str = 'LD' & " " & $tmp[0]
						$str = $str & " " & $tmp[1]
						$str = $str & " " & $timerdiff
						GUICtrlSetData($label, $str)
						;_GUICtrlListView_Scroll($listview, 0, 16)
						
						While _IsPressed("01", $dll)
							sleep(10)
						WEnd
						
						$tmp = MouseGetPos()
						$timerdiff = TimerDiff($timerinit)
						$timerdiff = Round($timerdiff)
						$str = 'LU' & Opt("GUIDataSeparatorChar") & $tmp[0]
						$str = $str & Opt("GUIDataSeparatorChar") & $tmp[1]
						$str = $str & Opt("GUIDataSeparatorChar") & $timerdiff
						$timerinit = TimerInit()
						GUICtrlCreateListViewItem($str, $listview)
						$str = 'LU' & " " & $tmp[0]
						$str = $str & " " & $tmp[1]
						$str = $str & " " & $timerdiff
						GUICtrlSetData($label, $str)
						;_GUICtrlListView_Scroll($listview, 0, 16)
						
					ElseIf _IsPressed("02", $dll) Then ; right click
						
						$tmp = MouseGetPos()
						$timerdiff = TimerDiff($timerinit)
						$timerdiff = Round($timerdiff)
						$str = 'RD' & Opt("GUIDataSeparatorChar") & $tmp[0]
						$str = $str & Opt("GUIDataSeparatorChar") & $tmp[1]
						$str = $str & Opt("GUIDataSeparatorChar") & $timerdiff
						$timerinit = TimerInit()
						GUICtrlCreateListViewItem($str, $listview)
						$str = 'RD' & " " & $tmp[0]
						$str = $str & " " & $tmp[1]
						$str = $str & " " & $timerdiff
						GUICtrlSetData($label, $str)
						;_GUICtrlListView_Scroll($listview, 0, 16)
						
						While _IsPressed("02", $dll)
							sleep(10)
						WEnd
						
						$tmp = MouseGetPos()
						$timerdiff = TimerDiff($timerinit)
						$timerdiff = Round($timerdiff)
						$str = 'RU' & Opt("GUIDataSeparatorChar") & $tmp[0]
						$str = $str & Opt("GUIDataSeparatorChar") & $tmp[1]
						$str = $str & Opt("GUIDataSeparatorChar") & $timerdiff
						$timerinit = TimerInit()
						GUICtrlCreateListViewItem($str, $listview)
						$str = 'RU' & " " & $tmp[0]
						$str = $str & " " & $tmp[1]
						$str = $str & " " & $timerdiff
						GUICtrlSetData($label, $str)
						;_GUICtrlListView_Scroll($listview, 0, 16)
					EndIf
				WEnd
				GUISetState(@SW_HIDE, $child)
				GUISetState(@SW_SHOW, $PARENT)
				GUISetState(@SW_ENABLE, $PARENT)
	DllClose($dll)
EndFunc
			
			
Func playback()
	local $t = GUICtrlRead($input5)
	
	if $t == 0 Then
		$t = -1
	EndIf
	
	$dll = DllOpen("user32.dll")
	GUISetState(@SW_DISABLE, $PARENT)
	GUISetState(@SW_HIDE, $PARENT)
	GUISetState(@SW_SHOW, $child)
	GUICtrlSetData($label2,"Press the 'esc' key to stop playback")
	
	While $t <> 0
	
		$i = $startvalue
		$tmp = guictrlread($i)
	
		While $tmp <> Opt("GUIDataSeparatorChar")
			$str = StringSplit($tmp, Opt("GUIDataSeparatorChar"))
			if ( ($str[0] == "LU") or ($str[0] == "RU") or ($str[0] == "LD") or ($str[0] == "RD") ) Then
				$tmp = $str[0] & " " & $str[1]
				$tmp = $tmp & " " & $str[2] & " " & $str[3]
			Else
				$tmp = $str[1] & " " & $str[2]
				$tmp = $tmp & " " & $str[3] & " " & $str[4]
			EndIf
			GUICtrlSetData($label, $tmp)
			$str[4] = $str[4] - 10
			While $str[4] > 0
				sleep(10)
				If _IsPressed("1B", $dll) Then
					GUIDelete($child)
					GUISetState(@SW_SHOW, $PARENT)
					GUISetState(@SW_ENABLE, $PARENT)
					DllClose($dll)
					
					If $str[1] == 'LU' Then
						MouseUp("left")
					ElseIf $str[1] == 'RU' Then
						MouseUp("right")
					EndIf
					
					Return
				EndIf
				$str[4] = $str[4] - 10
			WEnd
			if $str[1] == 'LD' Then
				MouseMove($str[2], $str[3], 10)
				MouseDown("left")
			ElseIf $str[1] == 'RD' Then
				MouseMove($str[2], $str[3], 10)
				MouseDown("right")
			ElseIf $str[1] == 'LU' Then
				MouseMove($str[2], $str[3], 10)
				MouseUp("left")
			ElseIf $str[1] == 'RU' Then
				MouseMove($str[2], $str[3], 10)
				MouseUp("right")
			EndIf
			$i = $i + 1
			$tmp = guictrlread($i)
		WEnd
		
		if $t > 0 Then
			$t = $t - 1
		EndIf
	WEnd
	
	GUISetState(@SW_HIDE, $child)
	GUISetState(@SW_SHOW, $PARENT)
	GUISetState(@SW_ENABLE, $PARENT)
	DllClose($dll)
EndFunc

Func Example()
    
    $PARENT = GUICreate("4/5/2011", 220, 340, @DesktopWidth-270, 100, -1, $WS_EX_TOPMOST)
    GUISetBkColor(0x00E0FFFF)  ; will change background color
	
	
	GUICtrlCreateGroup("", 5, 160, 210, 80)
	
	$input1 = GUICtrlCreateCombo("LU", 10, 215, 40, 20,$CBS_DROPDOWNLIST)
	GUICtrlSetData($input1, "LD")
	GUICtrlSetData($input1, "RU")
	GUICtrlSetData($input1, "RD")
	
	$input2 = GUICtrlCreateInput("0", 60, 215, 45, 20, $ES_NUMBER)
	$input3 = GUICtrlCreateInput("0", 110, 215, 45, 20, $ES_NUMBER)
	$input4 = GUICtrlCreateInput("0", 160, 215, 45, 20, $ES_NUMBER)
	
	$button1 = GUICtrlCreateButton("Add", 10, 170, 66, 20)
	$button2 = GUICtrlCreateButton("Delete", 76, 170, 66, 20)
	$button3 = GUICtrlCreateButton("Replace", 142, 170, 66, 20)
	
	$button4 = GUICtrlCreateButton("Insert", 10, 190, 66, 20)
	$button5 = GUICtrlCreateButton("Del All", 76, 190, 66, 20)
	$button6 = GUICtrlCreateButton("Test", 142, 190, 66, 20)
	
	$record = GUICtrlCreateButton("Ctrl+r - Record", 10, 245, 100, 50)
	$playback = GUICtrlCreateButton("Ctrl+p - Playback", 110, 245, 100, 50)
	
	GUICtrlCreateLabel("Repeat playback", 50, 300)
	$input5 = GUICtrlCreateInput("1", 135, 300, 20, 20, $ES_NUMBER)
	GUICtrlCreateLabel("('0' to repeat indefinitely)", 50, 320)
	
    $listview = GUICtrlCreateListView("key|x |y |ms ", 10, 10, 200, 150)
	
	$child = GUICreate("Recording mouse clicks", 200, 90, -1, -1, 0, BitOR($WS_EX_MDICHILD, $WS_EX_TOOLWINDOW), $PARENT)
	$label = GUICtrlCreateLabel("", 10, 15, 140, 40)
	$label2 = GUICtrlCreateLabel("Press the 'esc' key to stop recording", 10, 45)
	
	GUISetState(@SW_HIDE, $child)
	GUISetState(@SW_SHOW, $PARENT)
	GUISetState(@SW_ENABLE, $PARENT)
	
    GUISetState()

    Do
        $msg = GUIGetMsg()
        
        Select
		Case $msg = $button1 ; ADD
				$str = GUICtrlRead($input1) & Opt("GUIDataSeparatorChar") & GUICtrlRead($input2)
				if (GUICtrlRead($input4)<10) Then
					$str = $str & Opt("GUIDataSeparatorChar") & GUICtrlRead($input3) & Opt("GUIDataSeparatorChar") & "10"
				else
					$str = $str & Opt("GUIDataSeparatorChar") & GUICtrlRead($input3) & Opt("GUIDataSeparatorChar") & GUICtrlRead($input4)
				EndIf
				GUICtrlCreateListViewItem($str, $listview)
				_GUICtrlListView_Scroll($PARENT, 0, 16)
			Case $msg = $button2 ; DELETE
				;GUICtrlDelete(GUICtrlRead($listview))
				$i = GUICtrlRead($listview) ; current item
				$tmp = GUICtrlRead($i+1) ; content of next item
				while $tmp <> Opt("GUIDataSeparatorChar")
					GUICtrlSetData($i, $tmp)
					$i = $i+1
					$tmp = GUICtrlRead($i+1) ; content of next item
				WEnd
				GUICtrlDelete($i)
			Case $msg = $button3 ; REPLACE SELECTED ITEM
				$str = GUICtrlRead($input1) & Opt("GUIDataSeparatorChar") & GUICtrlRead($input2)
				$str = $str & Opt("GUIDataSeparatorChar") & GUICtrlRead($input3) & Opt("GUIDataSeparatorChar") & GUICtrlRead($input4)
				$tmp = GUICtrlRead($listview)
				if $tmp <> 0 Then
					GUICtrlSetData($tmp, $str)
				EndIf
			Case $msg = $button4 ; INSERT BEFORE SELECTED ITEM
				If GUICtrlRead($listview) <> Opt("GUIDataSeparatorChar") Then
					$str = GUICtrlRead($input1) & Opt("GUIDataSeparatorChar") & GUICtrlRead($input2)
					$str = $str & Opt("GUIDataSeparatorChar") & GUICtrlRead($input3) & Opt("GUIDataSeparatorChar") & GUICtrlRead($input4)
					$i = GUICtrlRead($listview) ; index
					$tmp = GUICtrlRead($i) ; content
					While $tmp <> Opt("GUIDataSeparatorChar")
						swap($tmp,$str)
						GUICtrlSetData($i, $tmp)
						$i = $i + 1
						$tmp = GUICtrlRead($i) 
					WEnd
					GUICtrlCreateListViewItem($str, $listview)
				EndIf
			Case $msg = $button5
				$i = $startvalue
				$tmp = GUICtrlRead($i)
				while $tmp <> Opt("GUIDataSeparatorChar")
					GUICtrlDelete($i)
					$i = $i + 1
					$tmp = GUICtrlRead($i)
				WEnd
			Case $msg = $button6 ; TEST SELECTED ITEM
				$tmp = guictrlread(guictrlread($listview))
				;MsgBox(0,0,$tmp);
				
					$str = StringSplit($tmp, Opt("GUIDataSeparatorChar"))
					
					if @error Then
					MsgBox(0,"error","Please select an item in the list")
				Else
					GUICtrlSetData($input1, $str[1])
					GUICtrlSetData($input2, $str[2])
					GUICtrlSetData($input3, $str[3])
					GUICtrlSetData($input4, $str[4])
					Sleep(10)
					MouseMove($str[2], $str[3], 10)
				EndIf
			Case $msg = $record
				record()
			case $msg = $playback
				playback()
            Case $msg = $listview
                MsgBox(0, "value", GUICtrlRead($listview), 2)
        EndSelect
    Until $msg = $GUI_EVENT_CLOSE
EndFunc   ;==>Example