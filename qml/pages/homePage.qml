import QtQuick 2.15
import CustomControls 1.0
import QtQuick.Controls 2.2
import org.kde.plasma.core 2.0 as PlasmaCore

import "../controls"

Item {
    Rectangle {
        id: homePage
        color: PlasmaCore.Theme.headerBackgroundColor
        anchors.fill: parent

        Row {
            id: rowTop
            height: parent.height * 0.40
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top

            Rectangle {
                id: rectCPU
                height: parent.height
                width: parent.width / 2
                color: PlasmaCore.Theme.headerBackgroundColor

                Rectangle {
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

                        value: backend.cpuFreq
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
            Rectangle {
                id: rectGPU
                height: parent.height
                width: parent.width / 2
                color: PlasmaCore.Theme.headerBackgroundColor

                Rectangle {
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
                        value: backend.gpuFan
                    }
                }
            }
        }

        Row {
            id: rowMiddle
            height: (parent.height - rowTop.height) * 0.50
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: rowTop.bottom

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

                    KAMRadialBar {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.margins: 10

                        width: parent.width / 2.5
                        height: width

                        label: qsTr("Load")
                    }
                }
            }

            Rectangle {
                id: rectNetwork
                height: parent.height
                width: parent.width / 3
                color: PlasmaCore.Theme.headerBackgroundColor

                Rectangle {
                    anchors.fill: parent
                    anchors.leftMargin: 5
                    anchors.rightMargin: 5
                    anchors.topMargin: 10
                    color: PlasmaCore.Theme.headerBackgroundColor
                    border.color: PlasmaCore.Theme.highlightColor
                    border.width: 1
                    radius: 5
                }
            }

            Rectangle {
                id: rectStorage
                height: parent.height
                width: parent.width / 3
                color: PlasmaCore.Theme.headerBackgroundColor

                Rectangle {
                    anchors.fill: parent
                    anchors.leftMargin: 5
                    anchors.topMargin: 10
                    color: PlasmaCore.Theme.headerBackgroundColor
                    border.color: PlasmaCore.Theme.highlightColor
                    border.width: 1
                    radius: 5

                    KAMRadialBar {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.margins: 10

                        width: parent.width / 2.5
                        height: width

                        label: qsTr("Load")
                    }
                }
            }
        }

        Row {
            id: rowBottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: rowMiddle.bottom
            anchors.bottom: parent.bottom

            Rectangle {
                id: rectProcesses
                anchors.fill: parent
                anchors.topMargin: 10
                color: PlasmaCore.Theme.headerBackgroundColor
                border.color: PlasmaCore.Theme.highlightColor
                border.width: 1
                radius: 5

                KAMProcTable {
                    id: kAMProcTable
                    anchors.fill: parent

                    //model: backend.model
                }

            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
