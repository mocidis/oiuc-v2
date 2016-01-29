@QtQuick
import QtQuick.Controls 1.4
DialogCommon {
    id: root
	captionText: "Select sound device"
	caption.font.pixelSize: 14
	width: 300; height: 300
	property string deviceIdx: ""
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
				checked: _ROOT.devices.get(index).select
				onClicked: {
					_ROOT.devices.get(index).select = checked
				}
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
			color: "lightgray"
			onColor: "navy"
			width: 120
			height: 60
			label: "Apply"
			textBold: true
			labelColor: isPressed?"white":"black"
			onClicked: {
				console.log("Apply");
				for (var i=0; i<_ROOT.devices.count; i++) {
					if (_ROOT.devices.get(i).select == true) {
						deviceIdx += _ROOT.devices.get(i).idx + ";";	
					}
				}
				//todo: call to cpp from target object: soundDeviceList
				soundDeviceList.applySoundDevice2(deviceIdx);
				deviceIdx="";
				_SOUND_DEVICE.visible = false;
			}
		}
		PushTextButton {
			color: "lightgray"
			onColor: "navy"
			width: 120
			height: 60
			label: "Cancel"
			textBold: true
			labelColor: isPressed?"white":"black"
			onClicked: {
				console.log("Cancel");
				deviceIdx="";
				_SOUND_DEVICE.visible = false;
			}
		}
	}
}
