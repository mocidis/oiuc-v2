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
                model: _ROOT.radios
                delegate: RadioView {
                    btnSize: Global.btnSize
                    oModelItem: _ROOT.radios.get(index)
                }
            }
            Repeater {
                id: repeater_oiu
                model: _ROOT.oius
                delegate: OIUView {
                    btnSize: Global.btnSize
                    oModelItem: _ROOT.oius.get(index)
                }
            }
        }
        contentHeight: (Global.entryHeight + 25) * Math.floor((repeater.count + repeater_oiu.count + 1) / numCol)
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
