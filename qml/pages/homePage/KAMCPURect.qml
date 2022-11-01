import QtQuick 2.15
import CustomControls 1.0
import QtQuick.Controls 2.2
import org.kde.plasma.core 2.0 as PlasmaCore

import "../../controls"

Rectangle {
    id: rectCPU
    height: parent.height
    width: parent.width / 2
    color: PlasmaCore.Theme.headerBackgroundColor

    property alias borderColor: innerRect.border.color

    Rectangle {
        id: innerRect
        anchors.fill: parent
        anchors.rightMargin: 5
        color: PlasmaCore.Theme.headerBackgroundColor
        border.color: PlasmaCore.Theme.highlightColor
        border.width: 1
        radius: 5

        Label {
            text: qsTr("CPU")
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
            id: cpuRadialBar
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.margins: 10

            width: parent.width / 2.5
            height: width

            label: qsTr("Load")

            value: backend.cpuUsage
        }

        KAMProgressBar {
            id: pbCPUTemp
            anchors {
                top: parent.top
                left: cpuRadialBar.right
                right: parent.right
                leftMargin: 15
                rightMargin: 10
                topMargin: (parent.height * 0.33) - height
            }

            leftText: qsTr("Temperature")
            rightText: qsTr(Number(backend.cpuTemp).toString() + "\u2103")
            value: backend.cpuTemp / 100
        }

        KAMProgressBar {
            id: pbCPUClock
            anchors {
                top: pbCPUTemp.bottom
                left: cpuRadialBar.right
                right: parent.right
                leftMargin: 15
                rightMargin: 10
                topMargin: 30
            }

            leftText: qsTr("Clock")
            rightText: qsTr(backend.cpuFreqText + "MHz")

            value: backend.cpuFreq / backend.cpuMaxFreq
        }

        KAMProgressBar {
            id: pbCPUFan
            anchors {
                top: pbCPUClock.bottom
                left: cpuRadialBar.right
                right: parent.right
                leftMargin: 15
                rightMargin: 10
                topMargin: 30
            }

            leftText: qsTr("Fan")
            rightText: qsTr(backend.cpuFanText + "RPM")
            value: backend.cpuFan
        }
    }
}
