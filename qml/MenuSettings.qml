@QtQuick
Rectangle {
	property int menuWidth: 180
	property int menuHeight: 35
	property variant object: null
	color: "red"
	PushTextButton {
		id: roleBtn
		anchors {
			top: parent.top
			left: parent.left
		}
		color: "transparent"
		onColor: "navy"
		width: menuWidth
		height: menuHeight
		label: "Roles & Permissions"
		labelColor: isPressed?"white":"black"
		onClicked: {
			console.log("Roles & Permissions");
			_MENU_SETTINGS.visible=false
			object.flag=!object.flag
			object.color="transparent";
			object.border.width = 0
			object.border.color = "transparent"
			_MANAGE_USER_DIALOG.visible=true
		}
	}
	Rectangle {
		id: separator	
		width: menuWidth
		height:1
		color: "lightgrey"
		anchors {
			top: roleBtn.bottom
			left: roleBtn.left
			right: roleBtn.right
			leftMargin: 2
			rightMargin: 2
		}
	}
	PushTextButton {
		id: soundBtn
		anchors {
			top: separator.bottom
			left: separator.left
		}
		color: "transparent"
		onColor: "navy"
		width: menuWidth
		height: menuHeight
		label: "Sound Devices"
		labelColor: isPressed?"white":"black"
		onClicked: {
			console.log("Sound Devices");
			_MENU_SETTINGS.visible=false
			object.flag=!object.flag
			object.color="transparent";
			object.border.width = 0
			object.border.color = "transparent"
			_SOUND_DEVICE.visible=true
		}
	}
}
