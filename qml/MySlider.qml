import QtQuick 1.0
Rectangle {
    property variant object: null
    property color buttonColor: "transparent"
    property int fontSize: 9
    border {
        width: 1
        color: "navy"
    }
    PushButton {
        id: leftBtn
        color: buttonColor
        anchors { 
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }
        width: label1.width + parent.height/2
        Text {
            id: label1
            anchors { centerIn: parent }
            text: "-"
            font {
                pixelSize: fontSize
            }
        }
        onClicked: {
            object.oItem.volume = (object.oItem.volume < 0.1)?0:(object.oItem.volume - 0.1);
        }
    }
    PushButton {
        id: rightBtn
        color: buttonColor
        anchors { 
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
        width: label2.width + parent.height/2
        Text {
            id: label2
            anchors { centerIn: parent }
            text: "+"
            font {
                pixelSize: fontSize
            }
        }
        onClicked: object.oItem.volume = (object.oItem.volume > 0.9)?1:(object.oItem.volume + 0.1);
    }
    Item {
        anchors {
            left: leftBtn.right
            right: rightBtn.left
            top: parent.top
            bottom: parent.bottom
        }
        Rectangle {
            anchors { 
                verticalCenter: parent.verticalCenter
                left: parent.left
                right: parent.right
            }
            height:2
            color: "black"
        }
        Rectangle {
            id: cue
            anchors {
                verticalCenter: parent.verticalCenter
            }
            x: (object == null)?(0-width/2):(object.oItem.volume > 1) ? (parent.width - width/2) : ((object.oItem.volume < 0) ? (0 - width/2):(parent.width * object.oItem.volume - width/2) )
            height: parent.height/4
            width: height
            radius: height/2
            border {
                width: 1
                color: "black"
            }
        }
    }
}
