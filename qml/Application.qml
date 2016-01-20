@QtQuick
@QtWindow
import PTTButton 1.0
@Window {
    visible: true
    id: _ROOT
	width: Screen.width
    height: Screen.height
    property ListModel radios : ModelRadios{}
	property ListModel oius : ModelOIUs{}
	property ListModel user : ModelUser{}
	property ListModel devices: ModelSoundDevice{}
	property ListModel pstn: ModelPSTN{}

    function hasControlledRadio() {
        var ret = false;
        var i;
        for(i = 0; i < radios.count; i++) {
            ret |= radios.get(i).isPTT;
        }
        return ret;
    }
    function hasControlledOIU() {
        var ret = false;
        var i;
        for(i = 0; i < oius.count; i++) {
            ret |= oius.get(i).isPTT;
        }
        return ret;
    }
    CppLinkage { }
    property QtObject appState: QtObject {
        property bool loginInProgress: false
        //property bool login: oiuc.isLoggedIn()
        property bool login: true
    }
	FontLoader {id: lcdFont; source: "../static/fonts/digital-7 (mono).ttf"}
	FontLoader {id: appFont; source: "../static/fonts/monaco.ttf"}
	FontLoader {id: iconFont; source: "../static/fonts/icons-font.ttf"}
    PanelTop {
        id: _TOP
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
    }
	
	PanelMain {
		id: _MAIN
		anchors {
			top: _TOP.bottom
			left: parent.left
			bottom: parent.bottom
            bottomMargin: 80
		}
		state: "halfOfMain"
	}
    Rectangle {
        color: "white"
        width: 1
        anchors {
            top: _TOP.bottom
            left: _MAIN.right
            right: _RIGHT.left
            bottom: parent.bottom
        }
    }
	
	PanelPSTN {
		id: _PSTN
		anchors {
			top: _TOP.bottom
			right: parent.right
			bottom: parent.bottom
            bottomMargin: 80
		}
		//state: "halfOfMain"
		width: Screen.width/2
		numCol: 2
	}
    PanelRight {
        id: _RIGHT
		width: Screen.width*0.4
		border.width: 1
        anchors {
            top: _TOP.bottom
            right: parent.right
            //left: _MAIN.right
            bottom: parent.bottom
            leftMargin: 1
			bottomMargin: 80
        }
		state: "dontViewLogPanel"
    }
	Rectangle {
		id: _PTT_ITEM
		color: "lightgrey"
		radius: 8
		height: 80
		visible: appState.login && (hasControlledRadio() || hasControlledOIU())
		anchors {
			bottom: parent.bottom
			left: parent.left
			right: _MAIN.right
		}
		Rectangle {
			height: 1
			color: "white"
			anchors {
				top: parent.top
				left: parent.left
				right: parent.right
			}
		}
		PushTextButton {
			id: _PTTBTN
			color: "maroon"
			radius: 10
			anchors {
				fill: parent
				margins: 10
			}
			font {
				pixelSize: 32
				bold: true
			}
			label: "Push-To-Talk"
			labelColor: "white"
			onClicked: {
				console.log("++++++ clicked ++++++");
			}
			onPressed: { 
				var radio;
				console.log("++++++ pressed ++++++: ");
				for (var i = 0; i < radios.count; i++) {
					radio = radios.get(i);
					//radio.isTx = radio.isPTT;
				}
				oiuc.PTT();
			}
			onReleased: {
				var radio;
				for (var i = 0; i < radios.count; i++) {
					radio = radios.get(i);
					radio.isTx = false;
				}
				oiuc.endPTT();
			}
		}
		PTT {
			id: pttc
			pos: Qt.point(_PTTBTN.x + _PTT_ITEM.x, _PTTBTN.y + _PTT_ITEM.y)
		}
	}
    TelephoneKeyboard {
        id: _TELKB
        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }
        visible: false
    }
    CallDialog {
        id:_CALLDIALOG
        width: 450
        height: 180
        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }
        visible: true
    }
    LoginAboutDialog {
        id: _LOGINDIALOG
        width: 500
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 120
        }
        onClose: visible=false
        visible: false
    }
    AboutDialog {
        id: _ABOUTDIALOG
        width: 500
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 120
        }
        onClose: visible=false
        visible: false
    }
	ManageUserDialog {
		id: _MANAGE_USER_DIALOG
		width: Screen.width*0.8
		height: Screen.height*0.8
		anchors {
			centerIn: parent
		}
		onClose: visible=false
		visible: false
	}
	SoundDevice {
		id: _SOUND_DEVICE	
		width: Screen.width*0.2
		height: Screen.height*0.4
		visible: false
		anchors {
			centerIn: parent
		}
		onClose: visible=false
	}
	MenuSettings {
		id: _MENU_SETTINGS
		color: "grey"
		width: 180
		height: 70
		visible: false
		border.width: 2
		border.color: "lightgrey"
		anchors {
			top: _TOP.bottom
			left: _TOP.left
			topMargin: -1
			leftMargin: _MENU_SETTINGS.object==null?0:_MENU_SETTINGS.object.x
		}
		Component.onCompleted: {
			if (oiuc.isAdministrator() == true) {
				_MENU_SETTINGS.height=70
			} else {
				_MENU_SETTINGS.height=35
			}
		}
	}
    VirtualKeyboard {
        id: _KEYBOARD
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            bottomMargin: 20
        }
        visible: false
    }
    MySlider {
        id: _SLIDER
        width: 200
        height: 50
        fontSize: 16
        anchors {
            top: _TOP.bottom
            right: _TOP.right
            rightMargin: (_SLIDER.object == null) ? 0:_SLIDER.flowWidth - _SLIDER.object.x - _SLIDER.width
        }
        visible: object != null
    }
    StateGroup {
        states: [
            State {
                name: "logout"
                when: !appState.login
                PropertyChanges { target: _RIGHT; visible: false }
                PropertyChanges { target: _MAIN; visible: false }
                PropertyChanges { target: _LOGINDIALOG; visible: true }
            },
            State {
                name: "login"
                when: appState.login
                PropertyChanges { target: _RIGHT; visible: false }
                PropertyChanges { target: _MAIN; visible: true }
            }
        ]
    }
    StateGroup {
        states: [
            State {
                name: "viewLogPanel"
				when: _RIGHT.state=="viewLogPanel"
                PropertyChanges { target: _RIGHT; visible: true }
                PropertyChanges { target: _RIGHT; opacity: 1.0}
            },
            State {
                name: "dontViewLogPanel"
				when: _RIGHT.state=="dontViewLogPanel"
                PropertyChanges { target: _RIGHT; visible: false }
                PropertyChanges { target: _RIGHT; opacity: 0.0}
            }
        ]
		transitions: Transition {
			NumberAnimation { property: "opacity"; duration: 300}
		}
    }
	StateGroup {
		states: [
			State {
				name: "halfOfMain"
				when: _MAIN.state=="halfOfMain"
				PropertyChanges {target: _MAIN; width: Screen.width/2}
				PropertyChanges {target: _MAIN; numCol: 2}
				PropertyChanges {target: _MAIN; visible: true}
				PropertyChanges {target: _PSTN; width: Screen.width/2}
				PropertyChanges {target: _PSTN; numCol: 2}
				PropertyChanges {target: _PSTN; visible: true}
			},
			State {
				name: "fullOfMain"	
				when: _MAIN.state=="fullOfMain"
				PropertyChanges {target: _MAIN; width: Screen.width}
				PropertyChanges {target: _MAIN; numCol: 4}
				PropertyChanges {target: _MAIN; visible: true}
				PropertyChanges {target: _PSTN; visible: false}
			},
			State {
				name: "fullOfPSTN"
				when: _PSTN.state=="fullOfPSTN"
				PropertyChanges {target: _PSTN; width: Screen.width}
				PropertyChanges {target: _PSTN; numCol: 4}
				PropertyChanges {target: _PSTN; visible: true}
				PropertyChanges {target: _MAIN; visible: false}
			}
		]
		transitions: Transition {
			 NumberAnimation { property: "width"; duration: 100}
		}
	}
}
