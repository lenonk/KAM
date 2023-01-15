import QtQuick 2.15
import QtQuick.Controls 2.15
import org.kde.plasma.core 2.0 as PlasmaCore
import CustomControls 1.0
import QtGraphicalEffects 1.0

import "../../../controls"

Rectangle {
    id: rectClockSpeed

    Label {
        id: lblClockSpeed
        text: qsTr("Clock Speed")
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
        id: radialClockSpeed
        anchors.top: lblClockSpeed.bottom
        anchors.left: parent.left
        anchors.margins: 10

        width: parent.width * 0.3
        height: width

        minValue: 0
        maxValue: backend.gpuFreqMax

        textFont.pointSize: Math.max(PlasmaCore.Theme.smallestFont.pointSize, Math.round(width / 8))

        suffixText: " MHz"
        value: Number(backend.gpuFreqText)
    }

    Rectangle {
        anchors {
            top: radialClockSpeed.top
            left: radialClockSpeed.right
            right: rectClockSpeed.right
            bottom: radialClockSpeed.bottom
            rightMargin: 10
        }

        color: PlasmaCore.Theme.headerBackgroundColor

        KAMLineChart {
            name: "Clock Speed"
            value: Number(backend.gpuFreqText)
            minValue: 0
            maxValue: 0

            Binding on maxValue {
                when: maxValue == 0
                value: backend.gpuFreqMax
            }

            axisSuffix: " MHz"
        }
    }
}
