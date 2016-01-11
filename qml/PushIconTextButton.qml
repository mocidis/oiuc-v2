@QtQuick
PushButton {
    property alias label: txtLabel.text
    property alias labelColor: txtLabel.color
    property alias font: txtLabel.font
    property alias labelWidth: txtLabel.width
	property alias textBold: txtLabel.font.bold
	property alias txtLabel: txtLabel
	Flow {
		spacing: 0
	   	anchors {
			centerIn: parent
	   	}
		Text {
			id: icon;
			text: "b"
			font {
				family: iconFont.name
				pixelSize: 28
			}
		}
    	Text {
        	id: txtLabel
			elide: Text.ElideRight
        	text: "Ok"
    	}
	}
}
