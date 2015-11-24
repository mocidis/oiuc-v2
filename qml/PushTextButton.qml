import QtQuick 2.3

PushButton {
    property alias label: txtLabel.text
    property alias labelColor: txtLabel.color
    property alias font: txtLabel.font
    property alias labelWidth: txtLabel.width
    Text {
        id: txtLabel
        anchors {
            centerIn: parent
        }
        text: "Ok"
    }
}
