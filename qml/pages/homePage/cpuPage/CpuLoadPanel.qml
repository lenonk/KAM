import QtQuick 2.15
import QtQuick.Controls 2.15
import org.kde.plasma.core 2.0 as PlasmaCore
import CustomControls 1.0
import QtGraphicalEffects 1.0

import "../../../controls"

Rectangle {
    id: rectLoad

    Label {
        id: lblLoad
        text: qsTr("Load")
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
        id: radialLoad

        anchors {
            top: lblLoad.bottom
            left: parent.left
            margins: 10
        }

        width: parent.width * 0.3
        height: width

        value: backend.cpuUsage
    }

    Rectangle {
        anchors {
            top: radialLoad.top
            left: radialLoad.right
            right: rectLoad.right
            bottom: radialLoad.bottom
            rightMargin: 10
        }

        color: PlasmaCore.Theme.headerBackgroundColor

        KAMLineChart {
            name: "CPU Load"
            value: backend.cpuUsage
            minValue: 0
            maxValue: 100
        }
    }
}
