
@QtQuick
@QtWindow

PanelCommon {
	property int numCol: 4 //number of column is displayed on the screen
    width: Screen.width
    clip: true
    Flickable {
        id: flickable
        anchors { fill: parent }
        Flow {
            anchors { 
                fill: parent
                margins: 20
            }
            spacing: 30
            Repeater {
                id: repeater
                model: _ROOT.pstn
                delegate: PSTNView {
                    btnSize: 80
                    oModelItem: _ROOT.pstn.get(index)
                }
            }
        }
        contentHeight: 160 * (repeater.count + 1) / numCol
    }
    ScrollBar {
        scrollArea: flickable
		anchors { 
            right: flickable.right
            bottom: flickable.bottom
            top: flickable.top
        }
    }
}
