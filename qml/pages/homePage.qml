import QtQuick 2.15
import QtQuick.Controls 2.15
import org.kde.plasma.core 2.0 as PlasmaCore

import "../controls"

Item {
    Rectangle {
        id: homePage
        color: PlasmaCore.Theme.backgroundColor
        anchors.fill: parent

        Row {
            id: rowTop
            height: parent.height * 0.40
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 0

            Rectangle {
                id: rectCPU
                height: parent.height
                width: parent.width / 2
                color: PlasmaCore.Theme.backgroundColor

                Rectangle {
                    anchors.fill: parent
                    anchors.rightMargin: 5
                    color: PlasmaCore.Theme.backgroundColor
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
                    }

                    Label {
                        text: qsTr("Load")
                        color: PlasmaCore.Theme.disabledTextColor
                        font.pointSize: 12
                        anchors {
                            bottom: cpuRadialBar.bottom
                            left: cpuRadialBar.right
                            leftMargin: -50
                            bottomMargin: -5
                        }
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
                        rightText: qsTr("50\u2103")
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
                        rightText: qsTr("3000 Mhz")
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
                        rightText: qsTr("1500 RPM")
                    }
                }
            }
            Rectangle {
                id: rectGPU
                height: parent.height
                width: parent.width / 2
                color: PlasmaCore.Theme.backgroundColor

                Rectangle {
                    anchors.fill: parent
                    anchors.leftMargin: 5
                    color: PlasmaCore.Theme.backgroundColor
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
                    }

                    Label {
                        text: qsTr("Load")
                        color: PlasmaCore.Theme.disabledTextColor
                        font.pointSize: 12
                        anchors {
                            bottom: gpuRadialBar.bottom
                            left: gpuRadialBar.right
                            leftMargin: -50
                            bottomMargin: -5
                        }
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
                        rightText: qsTr("50\u2103")
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
                        rightText: qsTr("3000 Mhz")
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
                        rightText: qsTr("1500 RPM")
                    }
                }
            }
        }

        Row {
            id: rowMiddle
            height: (parent.height - rowTop.height) * 0.60
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: rowTop.bottom
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 0


            Rectangle {
                id: rectRAM
                height: parent.height
                width: parent.width / 3
                color: PlasmaCore.Theme.backgroundColor

                Rectangle {
                    anchors.fill: parent
                    anchors.rightMargin: 5
                    anchors.topMargin: 10
                    color: PlasmaCore.Theme.backgroundColor
                    border.color: PlasmaCore.Theme.highlightColor
                    border.width: 1
                    radius: 5

                    KAMRadialBar {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.margins: 10

                        width: parent.width / 2.5
                        height: width
                    }
                }
            }

            Rectangle {
                id: rectNetwork
                height: parent.height
                width: parent.width / 3
                color: PlasmaCore.Theme.backgroundColor

                Rectangle {
                    anchors.fill: parent
                    anchors.leftMargin: 5
                    anchors.rightMargin: 5
                    anchors.topMargin: 10
                    color: PlasmaCore.Theme.backgroundColor
                    border.color: PlasmaCore.Theme.highlightColor
                    border.width: 1
                    radius: 5
                }
            }

            Rectangle {
                id: rectStorage
                height: parent.height
                width: parent.width / 3
                color: PlasmaCore.Theme.backgroundColor

                Rectangle {
                    anchors.fill: parent
                    anchors.leftMargin: 5
                    anchors.topMargin: 10
                    color: PlasmaCore.Theme.backgroundColor
                    border.color: PlasmaCore.Theme.highlightColor
                    border.width: 1
                    radius: 5
                    KAMRadialBar {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.margins: 10

                        width: parent.width / 2.5
                        height: width
                    }
                }
            }
        }

        Row {
            id: row
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: rowMiddle.bottom
            anchors.bottom: parent.bottom
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.bottomMargin: 0
            anchors.topMargin: 0

            Rectangle {
                anchors.fill: parent
                anchors.topMargin: 10
                color: PlasmaCore.Theme.backgroundColor
                border.color: PlasmaCore.Theme.highlightColor
                border.width: 1
                radius: 5
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
