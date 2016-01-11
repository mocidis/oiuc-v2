@QtQuick

DialogCommon {
    id: root
	captionText: "Manage Roles and Permissions"
	caption.font.pixelSize: 14
	Rectangle {
		height: 35; width: parent.width*0.3	
		radius: 8
		anchors {
			top: parent.top
			left: parent.left
			topMargin: 50
			leftMargin: 50
			rightMargin: 10
		}
		color: "grey"
		Text {
			text: "Users"
			anchors.centerIn: parent
		}
	}
	Rectangle {
		height: 35; width: parent.width*0.3	
		radius: 8
		color: "grey"
		anchors {
			top: parent.top
			left: parent.left
			topMargin: 50
			leftMargin: parent.width*0.3 + 60
		}
		Text {
			text: "Radios"	
			anchors.centerIn: parent
		}
	}
	Rectangle {
		height: 35; width: parent.width*0.3	
		radius: 8
		color: "grey"
		anchors {
			top: parent.top
			left: parent.left
			topMargin: 50
			leftMargin: parent.width*0.6 + 70
		}
		Text {
			text: "Operators console"	
			anchors.centerIn: parent
		}
	}
	Component {
		id: userComponent
		Item {
            width: parent.width
            height: 30
			Text {
				anchors.centerIn: parent
				text: description
				elide: Text.ElideRight
				font.family: appFont.name
				font.pixelSize: 14
			}
			MouseArea {
				anchors.fill: parent
				onClicked: userView.currentIndex = index
			}
		}
	}
	ListView {
		id: userView
		width: parent.width*0.3
		height: parent.height-30
		spacing: 2
		highlightMoveDuration: 250
		anchors {
			top: parent.top
			left: parent.left
			bottom: parent.bottom
			topMargin: 95
			leftMargin: 50
			bottomMargin: 80
		}
		model: _ROOT.oius
		delegate: userComponent
		clip: true
		focus: true
		highlight: Rectangle { color: "lightsteelblue"; radius: 8}
	}
	ScrollBar {
		scrollArea: userView
		anchors { 
            top: userView.top
            right: userView.right
            bottom: userView.bottom
        }
	}

	PanelCommon {
		id: radioView
		width: parent.width*0.3
		clip: true
		anchors {
			top: parent.top
			left: parent.left
			bottom: parent.bottom
			leftMargin: parent.width*0.3 + 60
			topMargin: 95
			bottomMargin: 70
		}
		Flickable {
			id: radioFlick
			anchors { fill: parent }
			Flow {
				anchors { 
					fill: parent
				}
				spacing: 2
				Repeater {
					id: radioRepeater
					model: _ROOT.radios
					delegate: Rectangle {
						width: radioView.width
						height: 30
						color: "transparent"
						radius: 8
						Text {
							width: parent.width
							anchors.centerIn: parent
							elide: Text.ElideMiddle
							text: "   " + _ROOT.radios.get(index).description + " #" + _ROOT.radios.get(index).port + " "
							font.pixelSize: 14
						}
						MouseArea {
							anchors.fill: parent
							onClicked: {
								parent.color="lightsteelblue"	
							}
							onDoubleClicked: {
								parent.color="transparent"		
						    }
						}
					}
				}
			}
			contentHeight: 35 * (radioRepeater.count + 1) 
		}
		ScrollBar {
			scrollArea: radioFlick
			anchors { 
				right: radioFlick.right
				bottom: radioFlick.bottom
				top: radioFlick.top
			}
		}
	}
	PanelCommon {
		id: oiuView
		width: parent.width*0.3
		clip: true
		anchors {
			top: parent.top
			left: parent.left
			bottom: parent.bottom
			leftMargin: parent.width*0.6 + 70
			topMargin: 95
			bottomMargin: 70
		}
		Flickable {
			id: oiuFlick
			anchors { fill: parent }
			Flow {
				anchors { 
					fill: parent
				}
				spacing: 2
				Repeater {
					id: oiuRepeater
					model: _ROOT.oius
					delegate: Rectangle {
						width: oiuView.width
						height: 30
						color: "transparent"
						radius: 8
						Text {
							width: parent.width
							anchors.centerIn: parent
							elide: Text.ElideMiddle
							text: "   " + _ROOT.oius.get(index).description + " "
							font.pixelSize: 14
						}
						MouseArea {
							anchors.fill: parent
							onClicked: {
								parent.color="lightsteelblue"	
							}
							onDoubleClicked: {
								parent.color="transparent"		
						    }
						}
					}
				}
			}
			contentHeight: 35 * (oiuRepeater.count + 1) 
		}
		ScrollBar {
			scrollArea: oiuFlick
			anchors { 
				right: oiuFlick.right
				bottom: oiuFlick.bottom
				top: oiuFlick.top
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
			//border.width: 2
			color: "lightgray"
			onColor: "navy"
			width: labelWidth + 60
			height: 60
			label: "Reset User\nPermission"
			textBold: true
			labelColor: isPressed?"white":"black"
			onClicked: {
				console.log("Reset User Permission");
			}
		}
		PushTextButton {
			//border.width: 2
			color: "lightgray"
			onColor: "navy"
			width: labelWidth + 60
			height: 60
			label: "Apply User\nPermission"
			textBold: true
			labelColor: isPressed?"white":"black"
			onClicked: {
				console.log("Apply User Permission");
			}
		}
		PushTextButton {
			//border.width: 2
			color: "lightgray"
			onColor: "navy"
			width: labelWidth + 60
			height: 60
			label: "Apply All"
			textBold: true
			labelColor: isPressed?"white":"black"
			onClicked: {
				console.log("Apply All");
			}
		}
		PushTextButton {
			//border.width: 2
			color: "lightgray"
			onColor: "navy"
			width: labelWidth + 60
			height: 60
			label: "Cancel"
			textBold: true
			labelColor: isPressed?"white":"black"
			onClicked: {
				console.log("Cancel");
			}
		}
	}
}
