@QtQuick
@QtControls
@QtWindow
import "QmlConfig.js" as Global
PanelCommon {
    property int itemWidth: 120
    id: root
    height: 50
    color: "#F0F0F0"
	Component.onCompleted: {
		_SLIDER.masterVolume = true
	}
    Flow {
        id: menu
        anchors {
            left: parent.left
            top: parent.top
            right: parent.right
            //margins: 15
        }
        spacing: 5
		PushTextButton {
			id: aboutbtn
			color: "transparent"
			onColor: "navy"
			width: labelWidth + Global.topPanelEntrySpacing
			height: root.height
			label: "About"
			labelColor: isPressed?"white":"black"
			onClicked: {
				_ABOUTDIALOG.visible = true;
			}
		}
		/*
        PushTextButton {
			id: telephonebtn
            color: "transparent"
            onColor: "navy"
            width: labelWidth + Global.topPanelEntrySpacing
            height: root.height
            label: "Telephone"
            labelColor: isPressed?"white":"black"
            onClicked: { 
                _TELKB.visible = _ROOT.appState.login?(!_TELKB.visible):false;
            }
        }
		*/
        PushTextButton {
			id: splitbtn
            color: "transparent"
            onColor: "navy"
            width: labelWidth + Global.topPanelEntrySpacing
            height: root.height
            label: "Split"
            labelColor: isPressed?"white":"black"
            onClicked: { 
				if (_MAIN.state=="halfOfMain") {
					_MAIN.state="fullOfMain"
				} else if (_MAIN.state=="fullOfMain") {
					_MAIN.state="halfOfMain"
				}
            }
        }
		PushTextButton {
			property bool flag:	false 
			id: settingbtn
			color: "transparent"
			onColor: "navy"
			width: labelWidth + Global.topPanelEntrySpacing
			height: root.height
			label: "Settings"
			labelColor: isPressed?"white":"black"
			onClicked: {
				console.log("Settings");
				if (flag == false) {
					_MENU_SETTINGS.object=settingbtn;
					_MENU_SETTINGS.visible=true;
					settingbtn.color="grey";
					settingbtn.border.width = 2
					settingbtn.border.color = "lightgrey"
					settingbtn.flag = true
				} else {
					_MENU_SETTINGS.object=settingbtn;
					_MENU_SETTINGS.visible=false;
					settingbtn.color="transparent";
					settingbtn.border.width = 0
					settingbtn.border.color = "transparent"
					settingbtn.flag = false
				}
			}
		}
    }
   	Flow { 
		id: flow
	   	anchors {
			right: parent.right
			top: parent.top
	   	}
		PushIconTextButton {
			color: "transparent"
			onColor: "navy"
			width: labelWidth>250?250:labelWidth+Global.topPanelEntrySpacing
			height: root.height
			label: oiuc.getUserName() 
			iconSide: "right"
			labelColor: isPressed?"white":"black"
			onClicked: {
				console.log("User Information");
			}
			clickable: false
		}
		ToggleTextButton {
			id: logbtn
			color: "transparent"
			onColor: "gray"
			width: root.height + Global.topPanelEntrySpacing
			height: root.height
			label: "f"
			txtLabel.font.family: iconFont.name
			txtLabel.font.pixelSize: 28
			//labelColor: isClicked?"white":"black"
			onClicked: {
				console.log("Toggle Log Panel");
				if (_RIGHT.state == "viewLogPanel") {
					_RIGHT.state="dontViewLogPanel";
				} else {
					_RIGHT.state="viewLogPanel";
				}
			}
		}
		VolumeControl {
			id: speaker
			onColor: "gray"
			width: root.height + Global.topPanelEntrySpacing
			height: root.height
			muteText: "d"
			unMuteText: "e"
			onClicked: {
				microphone.value = false;
				_SLIDER.object = value?speaker:null
				_SLIDER.flowWidth = flow.width
			}
			oItem: QtObject {
				property double volume: 0.5
			}
		}
		VolumeControl {
			id: microphone
			onColor: "gray"
			width: root.height + Global.topPanelEntrySpacing
			height: root.height
			muteText: "h"
			unMuteText: "g"
			onClicked: {
				speaker.value = false;
				_SLIDER.object = value?microphone:null
				_SLIDER.flowWidth = flow.width
			}
			oItem: QtObject {
				property double volume: 0.5
			}
		}
		PushTextButton {
			id: time
			width: labelWidth + Global.topPanelEntrySpacing
			height: root.height
			color: "transparent"
			onColor: "transparent"
			label: "--/--/--"
			font {
				family: lcdFont.name
				pixelSize: 16 
				letterSpacing: 3
			}
			Timer {
				interval: 500; running: true; repeat: true
				onTriggered: parent.label = Qt.formatDateTime(new Date(), "hh:mm:ss -- dd/MM/yyyy")
			}
			onClicked: {
				
			}
		}
		PushTextButton {
			id: logoutBtn
			color: "transparent"
			onColor: "navy"
			width: labelWidth + Global.topPanelEntrySpacing
			height: root.height
			txtLabel.font.family: iconFont.name
			txtLabel.font.pixelSize: 32
			label: "i"
			labelColor: _ROOT.appState.login?"#CC0000":"green"
			onClicked: {
				if(_ROOT.appState.login) {
					oiuc.stop();
				}
				else {
					_LOGINDIALOG.visible = true;
				}
			}
		}
   	}
    Rectangle {
        height: 1
        color: "black"
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
    }
    StateGroup {
        states: [
            State {
                name: "logout"
                //when: _TELKB.visible || _LOGINDIALOG.visible
				when: _ROOT.appState.login==false
                //PropertyChanges { target: menu; enabled: false }
				PropertyChanges {target: aboutbtn; clickable: false}
				PropertyChanges {target: splitbtn; clickable: false}
				PropertyChanges {target: settingbtn; clickable: false}
				PropertyChanges {target: logbtn; clickable: false}
				PropertyChanges {target: speaker; clickable: false}
				PropertyChanges {target: microphone; clickable: false}
            },
            State {
                name: "login"
                //when: !_TELKB.visible && !_LOGINDIALOG.visible
				when: _ROOT.appState.login==true
                //PropertyChanges { target: menu; enabled: true }
				PropertyChanges {target: aboutbtn; clickable: true}
				PropertyChanges {target: splitbtn; clickable: true}
				PropertyChanges {target: settingbtn; clickable: true}
				PropertyChanges {target: logbtn; clickable: true}
				PropertyChanges {target: speaker; clickable: true}
				PropertyChanges {target: microphone; clickable: true}
            }
        ]
    }
}
