import QtQuick 2.15
import CustomControls 1.0
import QtQuick.Controls 2.2
import org.kde.plasma.core 2.0 as PlasmaCore

import "../../controls"

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

            KAMCPURect {
                id: rectCPU

                MouseArea {
                    id: cpuMouseArea
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true

                    onClicked: (mouse)=> {
                        stackView.push(Qt.resolvedUrl("cpuPage/cpuPage.qml"))
                    }

                    onContainsMouseChanged: {
                       if (cpuMouseArea.containsMouse)
                           rectCPU.borderColor = PlasmaCore.Theme.buttonFocusColor
                       else
                           rectCPU.borderColor = PlasmaCore.Theme.highlightColor
                    }
                }
            }

            KAMGPURect {
                id: rectGPU

                MouseArea {
                    id: gpuMouseArea
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true

                    onClicked: (mouse)=> {
                        stackView.push(Qt.resolvedUrl("gpuPage/gpuPage.qml"))
                    }

                    onContainsMouseChanged: {
                       if (gpuMouseArea.containsMouse)
                           rectGPU.borderColor = PlasmaCore.Theme.buttonFocusColor
                       else
                           rectGPU.borderColor = PlasmaCore.Theme.highlightColor
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

            KAMRAMRect {
                id: rectRAM
            }

            KAMNetRect {
                id: rectNetwork
            }

            KAMStorageRect {
                id: rectStorage
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
