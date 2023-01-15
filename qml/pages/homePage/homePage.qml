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
                           rectCPU.borderColor = Qt.lighter(PlasmaCore.Theme.highlightColor, 1.5) // Use interpolation see taffic monitor
                       else
                           rectCPU.borderColor = PlasmaCore.Theme.highlightColor // Use interpolation see taffic monitor
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
                           rectGPU.borderColor = Qt.lighter(PlasmaCore.Theme.highlightColor, 1.5)
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

            property bool expanded: false
            property int oldHeight: 0

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

                PropertyAnimation {
                    id: animationProcTable
                    target: rowBottom
                    property: "height"
                    to: rowBottom.expanded === true ? rowBottom.oldHeight : homePage.height
                    duration: 500
                    easing.type: Easing.InOutCirc

                    onStarted: {
                        if (rowBottom.expanded === false)
                            rowBottom.oldHeight = rowBottom.height
                            rowBottom.anchors.top = undefined
                    }

                    onFinished: {
                        if (rowBottom.expanded === false)
                            rowBottom.anchors.top = rowMiddle.bottom
                    }
                }

                MouseArea {
                    id: procTableMouseArea

                    anchors {
                        top: rectProcesses.top
                        left: rectProcesses.left
                        right: rectProcesses.right
                        bottom: rectProcesses.bottom

                        topMargin: 40
                    }

                    acceptedButtons: Qt.LeftButton
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true

                    onClicked: (mouse)=> {
                        animationProcTable.running = true;
                        rowBottom.expanded = !rowBottom.expanded
                    }

                    onContainsMouseChanged: {
                       if (procTableMouseArea.containsMouse)
                           rectProcesses.border.color = Qt.lighter(PlasmaCore.Theme.highlightColor, 1.5) // Use interpolation see taffic monitor
                       else
                           rectProcesses.border.color = PlasmaCore.Theme.highlightColor // Use interpolation see taffic monitor
                    }
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
