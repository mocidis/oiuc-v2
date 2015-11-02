import QtQuick 1.0

Rectangle {
    property alias captionText: captiontxt.text
    property alias caption: captiontxt
    id: root
    signal close
    border {
        width: 2
        color: "gray"
    }
    Rectangle {
        color: "black"
        height: 30
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        Text {
            id: captiontxt
            color: "white"
            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: parent.verticalCenter
                leftMargin: 5
            }
            text: "Caption"
        }
        PushButton {
            color: "black"
            width: 30
            height: 30
            anchors {
                top: parent.top
                right: parent.right
            }
            Text {
                anchors { centerIn: parent }
                text: "X"
                color: "white"
            }
            onClicked: close();
        }
    }
}
