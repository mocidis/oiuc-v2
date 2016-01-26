@QtQuick
PushButton {
	property string label: "Ok"
	property string labelColor: "black"
	property string iconSide: "left"
	property alias labelWidth: loader.width
	clip: true
	Loader {
		id: loader
		onLoaded: {
			item.label=label
			item.labelColor=label
		}
		anchors.centerIn: parent
	}
	Component.onCompleted: {
		if (iconSide == "left") {
			loader.sourceComponent=iconOnLeft	
		} else {
			loader.sourceComponent=iconOnRight
		}
	}
	Component {
		id: iconOnLeft
		Flow {
			property alias label: txtLabel.text
			property alias labelColor: txtLabel.color
			Text {
				id: icon;
				text: "b"
				font {
					family: iconFont.name
					pixelSize: 26
				}
			}
			Text {
				id: txtLabel
				elide: Text.ElideMiddle
				text: label
			}
		}
	}
	Component {
		id: iconOnRight
		Flow {
			property alias label: txtLabel.text
			property alias labelColor: txtLabel.color
			Text {
				id: txtLabel
				elide: Text.ElideMiddle
				text: label
			}
			Text {
				id: icon;
				text: "b"
				font {
					family: iconFont.name
					pixelSize: 26
				}
			}
		}
	}
}
