@QtQuick

Rectangle {
    id: root
    property int btnSize: 50
    property int itemGap: btnSize * 0.2
    property variant oModelItem: null
	property int callState: 0

	color: "#f0f0f0"
    //width: btnArrayLoader.width + 2 * itemGap
    width: 304
    height: txtLabel.height + btnArrayLoader.height + 2 * itemGap
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
	Loader {
		id: btnArrayLoader
		anchors {
			left: parent.left
			top: txtLabel.bottom
			right: parent.right
			margins: itemGap
			topMargin: 2
		}
		sourceComponent: btnArrayComponent1
	}
	Component {
		id: btnArrayComponent1
		Row { 
			height: btnSize
			spacing: itemGap
			PushTextButton {
				id: btnCall
				color: "#000099"
				onColor: "darkgray"
				label: "Call"
				labelColor: "white"
				font {
					pixelSize: 16
					bold: true
				}
				width: parent.width
				height: parent.height
				onClicked: {
					btnArrayLoader.sourceComponent=btnArrayComponent3;
					oiuc.call(oModelItem.phone);
					//callState=2
					sequential.start();
				}
			}
		}
	}
	Component {
		id: btnArrayComponent2
		Row { 
			height: btnSize
			spacing: itemGap * 2
			PushTextButton {
				color: "#000099"
				onColor: "darkgray"
				label: "Answer"
				labelColor: "white"
				font {
					pixelSize: 16
					bold: true
				}
				width: parent.width*0.4
				height: parent.height
				onClicked: {
					btnArrayLoader.sourceComponent=btnArrayComponent3;
					oiuc.answerCall();
				}
			}
			PushTextButton {
				color: "#000099"
				onColor: "darkgray"
				label: "Hangup"
				labelColor: "white"
				font {
					pixelSize: 16
					bold: true
				}
				width: parent.width * 0.4
				height: parent.height
				onClicked: {
					btnArrayLoader.sourceComponent=btnArrayComponent1;
					oiuc.hangupCall();
				}
			}
		}
	}
	Component {
		id: btnArrayComponent3
		Row { 
			height: btnSize
			spacing: itemGap
			PushTextButton {
				id: btnCall
				color: "#000099"
				onColor: "darkgray"
				label: "Hangup"
				labelColor: "white"
				font {
					pixelSize: 16
					bold: true
				}
				width: parent.width
				height: parent.height
				onClicked: {
					btnArrayLoader.sourceComponent=btnArrayComponent1;
					oiuc.hangupCall();
				}
			}
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
		id: sequential
		running: false
		loops: Animation.Infinite	
	    ColorAnimation {target: iconStatus; property: "color"; from: "gray"; to: "green"; duration: 200}
	    ColorAnimation {target: iconStatus; property: "color"; from: "green"; to: "gray"; duration: 200}
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
            }
        ]
		transitions: Transition {
			from: "normal"	
			to: "connected"
			ColorAnimation {duration: 300}
		}
    }
}
