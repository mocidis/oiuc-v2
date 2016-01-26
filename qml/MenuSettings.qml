@QtQuick
Rectangle {
	property int menuWidth: 180
	property int menuHeight: 35
	property variant object: null
	color: "red"
	Component {
		id: com1
		PushTextButton {
			id: roleBtn
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
	}
	Component {
		id: com2
		Rectangle {
			id: separator	
			width: menuWidth
			height:1
			color: "lightgrey"
		}
	}
	Loader {
		id: loader1
		anchors {
			top: parent.top
			left: parent.left
		}
		//sourceComponent: com1
	}
	Loader {
		id: loader2
		anchors {
			top: loader1.bottom
			left: loader1.left
			right: loader1.right
			leftMargin: 2
			rightMargin: 2
		}
	}
	Component.onCompleted: {
		console.log("hehe");
		if (oiuc.isAdministrator() == true) {
			loader1.sourceComponent=com1
			loader2.sourceComponent=com2
		} else {
		}
	}
	PushTextButton {
		id: soundBtn
		anchors {
			top: loader1.bottom
			left: loader1.left
		}
		color: "transparent"
		onColor: "navy"
		width: menuWidth
		height: menuHeight
		label: "Sound Devices"
		labelColor: isPressed?"white":"black"
		onClicked: {
			console.log("Sound Devices");
			_ROOT.devices.clear();
			soundDeviceList.getSoundDeviceInfo();
			_MENU_SETTINGS.visible=false
			object.flag=!object.flag
			object.color="transparent";
			object.border.width = 0
			object.border.color = "transparent"
			_SOUND_DEVICE.visible=true
		}
	}
}
