@QtQuick

ToggleButton {
    property alias label: txtLabel.text
    property alias font: txtLabel.font
    property alias labelColor: txtLabel.color
	property alias txtLabel: txtLabel
    Text {
        id: txtLabel
        anchors {
            centerIn: parent
        }
        text: "Ok"
    }
}
