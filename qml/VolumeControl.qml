@QtQuick
ToggleButton {
    property variant oItem: null
    property string muteText: "d"
    property string unMuteText: "e"
    property alias iconOpacity: icon.opacity
	property alias icon: icon
    id: root
    onColor: "navy"
    color: "transparent"
	Text {
        id: icon
        anchors { centerIn: parent }
        smooth: true
		font {
			family: iconFont.name
			pixelSize: 28
		}
		text: unMuteText
	}
    StateGroup {
        states: [
            State {
                name: "UNMUTE"
				when: root.oItem.volume > 0
                PropertyChanges { target: icon; text:unMuteText}
            },
            State {
                name: "MUTE"
				when: root.oItem.volume <= 0
                PropertyChanges { target: icon; text:muteText}
            }
        ]
		transitions: Transition {
			NumberAnimation { property: "opacity"; duration: 300}
		}
    }
}
