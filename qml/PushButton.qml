@QtQuick

Rectangle {
    signal pressed()
    signal clicked()
    signal longClicked()
	signal released();
    property bool _pressed: false
    property color onColor: "lightgray"
    property color offColor: "white"
    //property alias isPressed: mouseArea.pressed
    property alias isPressed: root._pressed
    property alias clickable: mouseArea.enabled
    
    id: root

    MouseArea {
        id: mouseArea
        width: parent.width
        height: parent.height
        onPressed: {
            root._pressed = true;
            parent.pressed();
        }
        onClicked: {
            root._pressed = true;
            parent.clicked();
        }
        onPressAndHold: {
            root._pressed = true;
            parent.longClicked();
        }
		onReleased: {
            root._pressed = false;
            console.log("*********************uuuuuuu**************");
			parent.released();
		}
    }
    state: "NORMAL"

    states: [
        State {
            name: "NORMAL"
            //when: mouseArea.pressed == false
            when: root._pressed == false
            PropertyChanges {target: root; color: offColor}
        },
        State {
            name: "PRESSED"
            //when: mouseArea.pressed == true
            when: root._pressed == true
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
