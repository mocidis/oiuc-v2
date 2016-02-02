@QtQuick
@QtWindow

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
                    btnSize: 70
                    oModelItem: _ROOT.radios.get(index)
                }
            }
            Repeater {
                id: repeater_oiu
                model: _ROOT.oius
                delegate: OIUView {
                    btnSize: 70
                    oModelItem: _ROOT.oius.get(index)
                }
            }
        }
        contentHeight: 174 * Math.floor((repeater.count + repeater_oiu.count + 1) / numCol)
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
