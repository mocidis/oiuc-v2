import QtQuick 1.0

Rectangle {
    property int btnSize: 50
    property int itemGap: btnSize * 0.2
    property variant oModelItem: null

    id: root
    color: "#F0F0F0"
    width: btnArray.width + 2 * itemGap
    height: txtLabel.height + btnArray.height + 2 * itemGap
    border {
        width: 2; 
        color: "transparent"
    }
    MouseArea {
        id: mouseArea
        anchors { fill: parent }
        onClicked: oModelItem.isPTT = !oModelItem.isPTT
    }
    Text {
        id: txtLabel
        text: "#port:" + oModelItem.port + "\n" + oModelItem.description
        anchors {
            left: parent.left
            top: parent.top
            margins: itemGap
        }
        font {
            pixelSize: 16
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
            color: "lightgray"
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
            color: "lightgray"
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
            color: "lightgray"
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
        iconOpacity: value?1:0.5
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
                PropertyChanges { target: txBtn; labelColor: "black" }
                PropertyChanges { target: rxBtn; labelColor: "black"; clickable: true }
                PropertyChanges { target: sqBtn; labelColor: "black" }
                PropertyChanges { target: mouseArea; enabled: true }
                PropertyChanges { target: txtLabel; color: "blue" }
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
                PropertyChanges { target: root; border.color:"blue" }
            }
        ]
    }
    StateGroup {
        states: [
            State {
                name: "tx"
                when: oModelItem.isTx
                PropertyChanges { target: txBtn; color:"green"; labelColor: "white" }
            }
        ]
    }
    StateGroup {
        states: [
            State {
                name: "rx"
                when: oModelItem.isRx
                PropertyChanges { target: rxBtn; color:"green"; labelColor: "white" }
            }
        ]
    }
    StateGroup {
        states: [
            State {
                name: "sq"
                when: oModelItem.isRx
                PropertyChanges { target: sqBtn; color:"green" }
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
