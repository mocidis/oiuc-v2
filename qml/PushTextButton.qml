@QtQuick

PushButton {
    property alias label: txtLabel.text
    property alias labelColor: txtLabel.color
    property alias font: txtLabel.font
    property alias labelWidth: txtLabel.width
	property alias textBold: txtLabel.font.bold
	property alias txtLabel: txtLabel
    Text {
        id: txtLabel
		elide: Text.ElideRight
        anchors {
            centerIn: parent
        }
        text: "Ok"
    }
}
