@QtQuick
import QtQuick.Controls 1.4
import QtQuick.Window 2.2

PanelCommon {
    property int itemWidth: 120
    id: root
    height: 50
    color: "#F0F0F0"
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
			color: "transparent"
			onColor: "navy"
			width: labelWidth + 60
			height: root.height
			label: "About"
			labelColor: isPressed?"white":"black"
			onClicked: {
				_ABOUTDIALOG.visible = true;
			}
		}
        PushTextButton {
            color: "transparent"
            onColor: "navy"
            width: labelWidth + 60
            height: root.height
            label: "Telephone"
            labelColor: isPressed?"white":"black"
            onClicked: { 
                _TELKB.visible = _ROOT.appState.login?(!_TELKB.visible):false;
            }
        }
		PushTextButton {
			property bool flag:	false 
			id: settings
			color: "transparent"
			onColor: "navy"
			width: labelWidth + 60
			height: root.height
			label: "Settings"
			labelColor: isPressed?"white":"black"
			onClicked: {
				console.log("Settings");
				if (flag == false) {
					_MENU_SETTINGS.object=settings;
					_MENU_SETTINGS.visible=true;
					settings.color="grey";
					settings.border.width = 2
					settings.border.color = "lightgrey"
					settings.flag = true
				} else {
					_MENU_SETTINGS.object=settings;
					_MENU_SETTINGS.visible=false;
					settings.color="transparent";
					settings.border.width = 0
					settings.border.color = "transparent"
					settings.flag = false
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
			width: labelWidth + 60
			height: root.height
			//label: oiuc.getUserName() 
			//label: "Sỹ quan Liên lạc 3"
			//label: "Sỹ quan Dẫn đường 5"
			//label: "Sỹ quan Thông tin 1"
			label: "Administrator"
			//textBold: false
			labelColor: isPressed?"white":"black"
			onClicked: {
				console.log("User Information");
			}
		}
		ToggleTextButton {
			color: "transparent"
			onColor: "gray"
			width: root.height + 30
			height: root.height
			label: "f"
			txtLabel.font.family: iconFont.name
			txtLabel.font.pixelSize: 28
			//labelColor: isClicked?"white":"black"
			onClicked: {
				console.log("Toggle Log Panel");
				if (_RIGHT.state == "viewLogPanel") {
					_RIGHT.state="dontViewLogPanel";
					console.log("not");
				} else {
					_RIGHT.state="viewLogPanel";
					console.log("yes");
				}
			}
		}
		VolumeControl {
			id: speaker
			onColor: "gray"
			width: root.height + 30
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
			width: root.height + 30
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
			width: labelWidth + 60
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
			width: labelWidth + 60
			height: root.height
			txtLabel.font.family: iconFont.name
			txtLabel.font.pixelSize: 32
			label: _ROOT.appState.login?"i":"Login"
			labelColor: isPressed?"white":"#CC0000"
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
                when: _TELKB.visible || _LOGINDIALOG.visible
                PropertyChanges { target: menu; enabled: false }
            },
            State {
                name: "login"
                when: !_TELKB.visible && !_LOGINDIALOG.visible
                PropertyChanges { target: menu; enabled: true }
            }
        ]
    }
}
