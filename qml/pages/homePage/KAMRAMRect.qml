import QtQuick 2.15
import CustomControls 1.0
import QtQuick.Controls 2.2
import org.kde.plasma.core 2.0 as PlasmaCore

import "../../controls"

Rectangle {
    id: rectRAM
    height: parent.height
    width: parent.width / 3
    color: PlasmaCore.Theme.headerBackgroundColor

    Rectangle {
        anchors.fill: parent
        anchors.rightMargin: 5
        anchors.topMargin: 10
        color: PlasmaCore.Theme.headerBackgroundColor
        border.color: PlasmaCore.Theme.highlightColor
        border.width: 1
        radius: 5

        Label {
            text: qsTr("Memory")
            font.bold: true
            font.pointSize: 14
            color: PlasmaCore.Theme.textColor
            anchors {
                top: parent.top
                left: parent.left
                margins: 10
            }
        }

        KAMRadialBar {
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: 10

            width: parent.width / 2.5
            height: width

            label: qsTr("Load")

            value: backend.ramUsage
        }
    }
}
