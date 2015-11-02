import QtQuick 1.0

//Rectangle {
DialogCommon {
    property alias text: label.text
    //property alias captionText: caption.text

    // 0: Error/undefined; 
    // 1: Outgoing call ...;
    // 2: Incoming call ...
    // 3: Connected call ...
    property int dialogState: 0

    id: root    
    onClose: root.visible = (dialogState == 0) ? false : true
    Text {
        id: label
        anchors {
            centerIn: parent
        }
        text: "Message goes here ..."
    }
    Item {
        height: 30
        width: 200
        anchors {
            bottom: parent.bottom
            right: parent.right
            bottomMargin: 10
            rightMargin: 10
        }
        PushButton {
            property alias text: leftLabel.text
            id: leftBtn
            width: 80
            height: parent.height
            anchors {
                right: rightBtn.left
                top: parent.top
                rightMargin: 10
            }
            border { width: 1; color: "black" }
            Text {
                id:leftLabel
                anchors { centerIn:parent }
                text: "Answer"
            }
            onClicked: pstn.pstnAnswerCall();
        }
        PushButton {
            property alias text: rightLabel.text
            id: rightBtn
            width: 80
            height: parent.height
            anchors {
                right: parent.right
                top: parent.top
            }
            border { width: 1; color: "black" }
            Text {
                id: rightLabel
                anchors { centerIn:parent }
                text: "Reject"
            }
            onClicked: pstn.pstnHangupCall()
        }
    }
    StateGroup {
        states: [
            State {
                name: "undefined"
                when: dialogState == 0
                PropertyChanges { target: root; visible: false }
            },
            State {
                name: "outgoing"
                when: dialogState == 1
                PropertyChanges { target: caption; text: "Outgoing call ..." }
                PropertyChanges { target: leftBtn; visible: false }
                PropertyChanges { target: rightBtn; visible: true; text: "Cancel"; onClicked: pstn.pstnHangupCall() }
            },
            State {
                name: "incoming"
                when: dialogState == 2
                PropertyChanges { target: caption; text: "Incoming call ..." }
                PropertyChanges { target: leftBtn; visible: true; text: "Answer"; onClicked: pstn.pstnAnswerCall() }
                PropertyChanges { target: rightBtn; visible: true; text: "Reject"; onClicked: pstn.pstnHangupCall() }
            },
            State {
                name: "connected"
                when: dialogState == 3
                PropertyChanges { target: caption; text: "In conversation" }
                PropertyChanges { target: leftBtn; visible: true; text: "Hold"; onClicked: pstn.pstnHoldCall() }
                PropertyChanges { target: rightBtn; visible: true; text: "Disconnect"; onClicked: pstn.pstnHangupCall() }
            }
        ]
    }
}
