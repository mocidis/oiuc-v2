import QtQuick 1.0

Rectangle {
    property alias text: intext.text
    property alias align: intext.horizontalAlignment
    property alias font: intext.font
    property alias textColor: intext.color
    property bool textAbove: true
    width: parent.width
    height: 20
    color: "transparent"
    Text {
        id: intext
        text: "Radios"
        width: parent.width
        horizontalAlignment: Text.AlignRight
        anchors {
            top: textAbove?parent.top:separator.bottom
            left: parent.left
        }
        font {
            italic: true
        }
    }
    Rectangle {
        id: separator
        height: 1
        color: "#B0B0B0"
        anchors {
            bottom: textAbove?parent.bottom:intext.top
            left: parent.left
            right: parent.right
        }
    }
}
