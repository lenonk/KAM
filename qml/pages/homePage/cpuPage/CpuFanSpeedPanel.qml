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

        minValue: 0 // TODO: Get CPU min fan speed
        maxValue: 2800 // TODO: Get CPU max fan speed

        textFont.pointSize: Math.max(PlasmaCore.Theme.smallestFont.pointSize, Math.round(width / 8))
        suffixText: " RPM"
        value: Number(backend.cpuFanText)
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
            value: Number(backend.cpuFanText)
            minValue: 0
            maxValue: 2800 // Get Max CPU fan speed
            axisSuffix: " RPM"
        }
    }
}
