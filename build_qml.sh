#!/bin/bash
QT_VERSION=$1
QML_GEN_DIR=$2
rm -rf $QML_GEN_DIR
mkdir $QML_GEN_DIR
if [ $QT_VERSION == "5" ]; then
	for f in `ls -1 qml/*.qml`;
	do
		sed -e 's/@QtQuick/import QtQuick 2.3/g' -e 's/@QtWindow/import QtQuick.Window 2.2/g' <$f >$QML_GEN_DIR/${f##*/}
	done;
	sed -i '' 's/@Window/Window/g' $QML_GEN_DIR/Application.qml
	sed 's/@QML_GEN_DIR/'"$QML_GEN_DIR"'/g' <qml.qrc.template >qml.qrc
else
	for f in `ls -1 qml/*.qml`;
	do
		sed -e 's/@QtQuick/import QtQuick 1.1/g' -e 's/@QtWindow//g' <$f >$QML_GEN_DIR/${f##*/}
	done;
	sed -i '' 's/@Window/Rectangle/g' $QML_GEN_DIR/Application.qml
	sed 's/@QML_GEN_DIR/'"$QML_GEN_DIR"'/g' <qml.qrc.template >qml.qrc
fi
