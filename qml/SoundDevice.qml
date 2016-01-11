@QtQuick
import QtQuick.Controls 1.4
DialogCommon {
    id: root
	captionText: "Select sound device"
	caption.font.pixelSize: 14
	width: 300; height: 300
	Column {
		anchors {
			//centerIn: parent
			horizontalCenter: parent.horizontalCenter
			top: parent.top
			topMargin: 60
		}
		spacing: 20
		Repeater {
			model: _ROOT.devices
			delegate: CheckBox {
				text: _ROOT.devices.get(index).name	
			}
		}
	}
	Flow {
		anchors {
			right: parent.right
			bottom: parent.bottom
			rightMargin: 10
			bottomMargin: 10
		}
		spacing: 10
		PushTextButton {
			//border.width: 2
			color: "lightgray"
			onColor: "navy"
			width: 120
			height: 60
			label: "Ok"
			textBold: true
			labelColor: isPressed?"white":"black"
			onClicked: {
				console.log("Apply All");
			}
		}
		PushTextButton {
			//border.width: 2
			color: "lightgray"
			onColor: "navy"
			width: 120
			height: 60
			label: "Cancel"
			textBold: true
			labelColor: isPressed?"white":"black"
			onClicked: {
				console.log("Cancel");
			}
		}
	}
}
