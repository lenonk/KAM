import QtQuick 2.15
import QtQuick.Controls 2.15
import org.kde.plasma.core 2.0 as PlasmaCore
import CustomControls 1.0
import QtGraphicalEffects 1.0

import "../../../controls"

Rectangle {
    id: rectTemp

    Label {
        id: lblTemp
        text: qsTr("Temperature")
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
        id: radialTemp
        anchors {
            top: lblTemp.bottom
            left: parent.left
            margins: 10
        }

        width: parent.width * 0.3
        height: width

        suffixText: "\u00b0"
        value: backend.gpuTemp
    }

    Rectangle {
        anchors {
            top: radialTemp.top
            left: radialTemp.right
            right: rectTemp.right
            bottom: radialTemp.bottom
            rightMargin: 10
        }

        color: PlasmaCore.Theme.headerBackgroundColor

        KAMLineChart {
            name: "GPU Temp"
            value: backend.gpuTemp
            minValue: 0
            maxValue: 100
            axisSuffix: "\u00b0"
        }
    }
}
