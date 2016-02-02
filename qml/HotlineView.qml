@QtQuick

Rectangle {
    id: root
    property int btnSize: 50
    property int itemGap: btnSize * 0.2
    property variant oModelItem: null
	property int callState: 0
	property bool isInCommingCall: false
	color: "#f0f0f0"
    width: btnCall.width + 2 * itemGap
    height: txtLabel.height + btnCall.height + 2 * itemGap
    border {
        width: 2; 
        color: "transparent"
    }
    Text {
        id: txtLabel
        text: oModelItem.name   + " - Freq: " + oModelItem.freq + "\n" + "#" + oModelItem.location
        anchors {
            left: parent.left
            top: parent.top
            margins: itemGap
        }
        font {
            pixelSize: 14
            bold: true
        }
        color: "black"
    }
	PushTextButton {
		id: btnCall
		anchors {
			left: parent.left
			top: txtLabel.bottom
			margins: itemGap
			topMargin: 2
		}
		color: "#000099"
		onColor: "darkgray"
		label: "Call"
		labelColor: "white"
		font {
			pixelSize: 16
			bold: true
		}
		width: 3 * btnSize + 2 * itemGap
		height: btnSize
		onClicked: {
			oiuc.call(oModelItem.phone);
		}
	}

	Text {
		id: iconStatus
        anchors {
            right: parent.right
            top: parent.top
            margins: itemGap
        }
		smooth: true
		font {
			family: iconFont.name
			pixelSize: 28
		}
		text: "j"
	}
	SequentialAnimation on color {
		id: establishConnection
		running: false
		loops: Animation.Infinite	
	    ColorAnimation {target: iconStatus; property: "color"; from: "gray"; to: "yellow"; duration: 200}
	    ColorAnimation {target: iconStatus; property: "color"; from: "yellow"; to: "gray"; duration: 200}
	}	
    StateGroup {
        states: [
            State {
                name: "normal"
                when: callState == 0
                PropertyChanges { target: iconStatus; color: "grey" }
            },
            State {
                name: "outgoing"
                when: callState == 1
                PropertyChanges { target: iconStatus; color: "yellow" }
            },
            State {
                name: "connected"
                when: callState == 2
                PropertyChanges { target: iconStatus; color: "green" }
            }, 
            State {
                name: "nothing"
                when: callState == 3
            } 
        ]
    }
    Connections {
        target: oiuc
        onCallingState: {
			console.log(remoteUser + "---------" + oModelItem.phone);
			if (remoteUser == oModelItem.phone) {
				if (st_code == 0 || st_code == 6) {
					establishConnection.stop();
					callState=0	
					_CALLDIALOG.dialogState = 0; 
					_CALLDIALOG.text = msg;
					btnArrayLoader.sourceComponent=btnArrayComponent1;
					isInCommingCall=false;
				} else if (st_code == 1 || st_code == 3 || st_code == 4) {
					btnArrayLoader.sourceComponent=btnArrayComponent3;
					establishConnection.start();
					callState=3
				} else if (st_code == 5) {
					establishConnection.stop();	
					if (isInCommingCall == true) {
						_CALLDIALOG.dialogState = 3; 
						_CALLDIALOG.text = msg;
					}
					callState=2
				} else if (st_code == 2) {
					isInCommingCall=true;
					establishConnection.start();	
					_CALLDIALOG.dialogState = 2; 
					_CALLDIALOG.text = msg;
					callState=3;
				}
			}
		}
    }
}
