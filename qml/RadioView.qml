@QtQuick

Rectangle {
    property int btnSize: 50
    property int itemGap: btnSize * 0.2
    property variant oModelItem: null

    id: root
	//color: "#e0e0ff"
	//color: "#e5e5ff"
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
        text: oModelItem.description   + " - Freq: " + oModelItem.freq + "\n" + "Channel: #" + oModelItem.port 
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
            color: "#000099"
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
            color: "#000099"
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
            color: "#000099"
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
		onColor: "grey"
        width: height
        //iconOpacity: value?1:0.5
		icon.font.pixelSize: 24
		icon.color: "#000099"
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
                PropertyChanges { target: txtLabel; color: "#000099" }
            },
            State {
                name: "offline"
                when: !oModelItem.isOnline
                PropertyChanges { target: txBtn; color: "lightgray"; labelColor: "darkgray"; clickable: false }
                PropertyChanges { target: rxBtn; color: "lightgray"; labelColor: "darkgray"; clickable: false }
                PropertyChanges { target: sqBtn; color: "lightgray"; labelColor: "darkgray"; clickable: false }
                PropertyChanges { target: volume; icon.color: "lightgray"; clickable: false }
				PropertyChanges { target: root; color: "#F0F0F0"}
                PropertyChanges { target: mouseArea; enabled: false }
            }
        ]
    }
    StateGroup {
        states: [
            State {
                name: "pttSelected"
                when: oModelItem.isPTT
                PropertyChanges { target: root; border.color:"#3333ff" }
                PropertyChanges { target: root; border.width:"2" }
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
