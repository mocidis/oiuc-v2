import QtQuick 1.0
Rectangle {
    id: _ROOT
	width: 1280
    height: 680
    
	property ListModel radios : ModelRadios{}
	property ListModel oius : ModelOIUs{}
    
    function hasControlledRadio() {
        var ret = false;
        var i;
        for(i = 0; i < radios.count; i++) {
            ret |= radios.get(i).isPTT;
        }
        return ret;
    }

    CppLinkage { }
    property QtObject appState: QtObject {
        property bool loginInProgress: false
        property bool login: pstn.isLoggedIn()
    }
	FontLoader {id: lcdFont; source: "../static/fonts/digital-7 (mono).ttf"}
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
	}
    Rectangle {
        color: "black"
        width: 1
        anchors {
            top: _TOP.bottom
            left: _MAIN.right
            right: _RIGHT.left
            bottom: parent.bottom
        }
    }
    PanelRight {
        id: _RIGHT
        anchors {
            top: _TOP.bottom
            right: parent.right
            left: _MAIN.right
            bottom: parent.bottom
            leftMargin: 1
        }
    }
    Item {
        height: 80
        visible: appState.login && hasControlledRadio()
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: _MAIN.right
        }
        Rectangle {
            height: 1
            color: "black"
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
            onPressed: { 
                var radio;
                for (var i = 0; i < radios.count; i++) {
                    radio = radios.get(i);
                    radio.isTx = radio.isPTT;
                }
            }
            onReleased: {
                var radio;
                for (var i = 0; i < radios.count; i++) {
                    radio = radios.get(i);
                    radio.isTx = false;
                }
            }
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
            rightMargin: (object == null) ? 0:object.anchors.rightMargin
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
                PropertyChanges { target: _RIGHT; visible: true }
                PropertyChanges { target: _MAIN; visible: true }
            }
        ]
    }
}
