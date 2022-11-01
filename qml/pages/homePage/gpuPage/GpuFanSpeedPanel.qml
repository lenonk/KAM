import QtQuick 2.15
import QtQuick.Controls 2.15
import org.kde.plasma.core 2.0 as PlasmaCore
import CustomControls 1.0
import QtGraphicalEffects 1.0

import "../../../controls"

Rectangle {
    id: rectFanSpeed

    Label {
        id: lblFanSpeed
        text: qsTr("Fan Speed")
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
        id: radialFanSpeed

        anchors.top: lblFanSpeed.bottom
        anchors.left: parent.left
        anchors.margins: 10

        width: parent.width * 0.3
        height: width

        minValue: 0
        maxValue: backend.gpuFanMax

        textFont.pointSize: Math.max(PlasmaCore.Theme.smallestFont.pointSize, Math.round(width / 8))
        suffixText: " RPM"
        value: Number(backend.gpuFanText)
    }

    Rectangle {
        anchors {
            top: radialFanSpeed.top
            left: radialFanSpeed.right
            right: rectFanSpeed.right
            bottom: radialFanSpeed.bottom
            rightMargin: 10
        }

        color: PlasmaCore.Theme.headerBackgroundColor

        KAMLineChart {
            name: "Fan Speed"
            value: Number(backend.gpuFanText)
            minValue: 0
            maxValue: 0

            // Work around for minValue and maxValue causing crashing when bound
            Binding on maxValue {
                when: maxValue == 0
                value: backend.gpuFanMax
            }

            axisSuffix: " RPM"
        }
    }
}
