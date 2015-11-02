import QtQuick 1.0

Rectangle {
	property alias text: call_number.text
    property alias textInput: call_number
	property int fontSize: 32
    color: "#A0B46A"
    border { width: 1; color: "black" }
	TextInput {
		width: parent.width
		text: "88888888888888888"
        color: "#9DA267"
		readOnly: true
		font {
            family: lcdFont.name
		    pixelSize: fontSize
		    letterSpacing: 3
        }
		anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            margins: 10
		}
	}
	TextInput {
		id: call_number
		width: parent.width
        maximumLength: 17
		text: ""
        color: "black"
		readOnly: true
		font {
            family: lcdFont.name
		    pixelSize: fontSize
		    letterSpacing: 3
        }
		anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            margins: 10
		}
	}
}
