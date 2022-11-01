import QtQuick 2.15
import CustomControls 1.0
import QtQuick.Controls 2.2
import org.kde.plasma.core 2.0 as PlasmaCore

import "../../controls"

Rectangle {
    id: rectGPU
    height: parent.height
    width: parent.width / 2
    color: PlasmaCore.Theme.headerBackgroundColor

    property alias borderColor: innerRect.border.color

    Rectangle {
        id: innerRect
        anchors.fill: parent
        anchors.leftMargin: 5
        color: PlasmaCore.Theme.headerBackgroundColor
        border.color: PlasmaCore.Theme.highlightColor
        border.width: 1
        radius: 5

        Label {
            text: qsTr("GPU")
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
            id: gpuRadialBar
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.margins: 10

            width: parent.width / 2.5
            height: width

            label: qsTr("Load")

            value: backend.gpuUsage
        }

        KAMProgressBar {
            id: pbGPUTemp
            anchors {
                top: parent.top
                left: gpuRadialBar.right
                right: parent.right
                leftMargin: 15
                rightMargin: 10
                topMargin: (parent.height * 0.33) - height
            }

            leftText: qsTr("Temperature")
            rightText: qsTr(Number(backend.gpuTemp).toString() + "\u2103")
            value: backend.gpuTemp / 100
        }

        KAMProgressBar {
            id: pbGPUClock
            anchors {
                top: pbGPUTemp.bottom
                left: gpuRadialBar.right
                right: parent.right
                leftMargin: 15
                rightMargin: 10
                topMargin: 30
            }

            leftText: qsTr("Clock")
            rightText: qsTr(backend.gpuFreqText + "MHz")

            value: backend.gpuFreq
        }

        KAMProgressBar {
            id: pbGPUFan
            anchors {
                top: pbGPUClock.bottom
                left: gpuRadialBar.right
                right: parent.right
                leftMargin: 15
                rightMargin: 10
                topMargin: 30
            }

            leftText: qsTr("Fan")
            rightText: qsTr(backend.gpuFanText + "RPM")
            value: (backend.gpuFan / backend.gpuFanMax)
        }
    }
}
