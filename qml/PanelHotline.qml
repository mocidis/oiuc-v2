
@QtQuick
@QtWindow
import "QmlConfig.js" as Global

PanelCommon {
	property int numCol: 4 //number of column is displayed on the screen
    width: _ROOT.sWIDTH
    clip: true
    Flickable {
        id: flickable
        anchors { fill: parent }
        Flow {
            anchors { 
                fill: parent
                margins: 20
            }
            spacing: 25
            Repeater {
                id: repeater
                model: _ROOT.hotline
                delegate: HotlineView {
                    btnSize: Global.btnSize
                    oModelItem: _ROOT.hotline.get(index)
                }
            }
        }
        contentHeight: 174 * Math.floor((repeater.count + 1) / numCol)
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
