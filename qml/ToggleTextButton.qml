import QtQuick 1.0

ToggleButton {
    property alias label: txtLabel.text
    property alias font: txtLabel.font
    property alias labelColor: txtLabel.color

    Text {
        id: txtLabel
        anchors {
            centerIn: parent
        }
        text: "Ok"
    }
}
