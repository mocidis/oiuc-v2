@QtQuick

Rectangle {
    property int btnSize: 50
    property int itemGap: btnSize * 0.2
    property variant oModelItem: null

    id: root
	//color: "#fff0f0"
    //color: "#cef8b9"
	color: "#f0f0f0"
    width: btnArray.width + 2 * itemGap
    height: txtLabel.height + btnArray.height + 2 * itemGap
    border {
        width: 2; 
        color: "transparent"
    }
    MouseArea {
        id: mouseArea
        anchors { fill: parent }
		onClicked: {
			oModelItem.isPTT = !oModelItem.isPTT
			if (oModelItem.isPTT == true) {
				oiuc.sendInvite(oModelItem.name);
			} else {
				oiuc.repulse(oModelItem.name);
			}
		}
    }
    Text {
        id: txtLabel
        //text: "ID: " + oModelItem.port + "\n" + oModelItem.description
        text: oModelItem.location + "\n" + oModelItem.description
        anchors {
            left: parent.left
            top: parent.top
            margins: itemGap
        }
        font {
            pixelSize: 14
            bold: true
        }
        color: "lightgray"
    }
    Flow {
        id: btnArray
        height: btnSize
        spacing: itemGap
        anchors {
            left: parent.left
            top: txtLabel.bottom
            margins: itemGap
            topMargin: 2
        }
        ToggleTextButton {
            id: txBtn
            color: "#990000"
            onColor: "darkgray"
            label: "Tx"
            labelColor: "white"
            font {
                pixelSize: 24
                bold: true
            }
            width: height
            height: parent.height
            clickable: false
        }
        PushTextButton {
            id: rxBtn
            color: "#990000"
            onColor: "darkgray"
            label: "Rx"
            labelColor: "white"
            font {
                pixelSize: 24
                bold: true
            }
            width: height
            height: parent.height
            onClicked: oModelItem.isRxBlocked = !oModelItem.isRxBlocked
        }
        ToggleTextButton {
            id: sqBtn
            color: "#990000"
            onColor: "darkgray"
            label: "SQ"
            labelColor: "white"
            font {
                pixelSize: 24
                bold: true
            }
            width: height
            height: parent.height
            clickable: false
        }
    }
    VolumeControl {
        id: volume
        height: txtLabel.height
        width: height
        //iconOpacity: value ? 1 : 0.5
		onColor: "grey"
		icon.font.pixelSize: 24
		icon.color: "#990000"
        anchors {
            right: parent.right
            top: parent.top
            margins: itemGap
        }
        oItem: oModelItem
    }
    MySlider {
        width: 200
        height: 50
        fontSize: 16
        anchors {
            top: volume.bottom
            right: volume.right
        }
        object: volume
        visible: volume.value
    }
    StateGroup {
        states: [
            State {
                name: "online"
                when: oModelItem.isOnline
                PropertyChanges { target: txBtn; labelColor: "white" }
                PropertyChanges { target: rxBtn; labelColor: "white"; clickable: true }
                PropertyChanges { target: sqBtn; labelColor: "white" }
                PropertyChanges { target: mouseArea; enabled: true }
                PropertyChanges { target: txtLabel; color: "#990000" }
            },
            State {
                name: "offline"
                when: !oModelItem.isOnline
                PropertyChanges { target: txBtn; labelColor: "darkgray"; clickable: false }
                PropertyChanges { target: rxBtn; labelColor: "darkgray"; clickable: false }
                PropertyChanges { target: sqBtn; labelColor: "darkgray"; clickable: false }
                PropertyChanges { target: mouseArea; enabled: false }
            }
        ]
    }
    StateGroup {
        states: [
            State {
                name: "pttSelected"
                when: oModelItem.isPTT
                PropertyChanges { target: root; border.color:"#990000" }
            }
        ]
    }
    StateGroup {
        states: [
            State {
                name: "tx"
                when: oModelItem.isTx
                PropertyChanges { target: txBtn; color:"#00b300"; labelColor: "white" }
            }
        ]
    }
    StateGroup {
        states: [
            State {
                name: "rx"
                when: oModelItem.isRx
                PropertyChanges { target: rxBtn; color:"#00b300"; labelColor: "white" }
            }
        ]
    }
    StateGroup {
        states: [
            State {
                name: "sq"
                when: oModelItem.isSQ
                PropertyChanges { target: sqBtn; color:"#00b300"; labelColor: "white" }
            }
        ]
    }
    StateGroup {
        states: [
            State {
                name: "rxBlocked"
                when: oModelItem.isRxBlocked
                PropertyChanges { target: rxBtn; labelColor: "darkgray" }
            }
        ]
    }
}
