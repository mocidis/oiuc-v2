import QtQuick 1.0

Rectangle {
    signal pressed()
    signal clicked()
    signal longClicked()
	signal released();
    property color onColor: "lightgray"
    property alias isPressed: mouseArea.pressed
    property alias clickable: mouseArea.enabled
    
    id: root

    MouseArea {
        id: mouseArea
        width: parent.width
        height: parent.height
        onPressed: {
            parent.pressed();
        }
        onClicked: {
            parent.clicked();
        }
        onPressAndHold: {
            parent.longClicked();
        }
		onReleased: {
			parent.released();
		}
    }
    state: "NORMAL"

    states: [
        State {
            name: "NORMAL"
            when: mouseArea.pressed == false
        },
        State {
            name: "PRESSED"
            when: mouseArea.pressed == true
            PropertyChanges {target: root; color: onColor}
        }
    ]

/*    transitions: [
        Transition {
            from: "PRESSED"
            to: "NORMAL"
            ColorAnimation {duration: 200}
        }
    ] */
}
