import QtQuick 2.15
import QtQuick.Controls 2.15
import org.kde.plasma.core 2.0 as PlasmaCore
import CustomControls 1.0
import QtGraphicalEffects 1.0

import "../../../controls"

Rectangle {
    id: rectTop
    Rectangle {
        id: rectCPULeft

        anchors {
            top: parent.top
            left: parent.left
        }

        width: parent.width / 2

        Label {
            id: lblCPUModel
            anchors {
                top: parent.top
                left: parent.left
                topMargin: 10
                leftMargin: 10
            }

            text: "Model: "
            font.pointSize: 10
            font.bold: true

            Label {
                anchors.top: parent.top
                anchors.left: parent.right
                anchors.leftMargin: 5
                text: backend.cpuModel
                font.pointSize: 10
                font.bold: false
                color: PlasmaCore.Theme.disabledTextColor
            }
        }

        Label {
            id: lblCPUCodeName
            anchors {
                top: lblCPUModel.bottom
                left: parent.left
                topMargin: 15
                leftMargin: 10
            }

            text: "Code Name: "
            font.pointSize: 10
            font.bold: true

            Label {
                anchors.top: parent.top
                anchors.left: parent.right
                anchors.leftMargin: 5
                text: backend.cpuCodeName
                font.pointSize: 10
                font.bold: false
                color: PlasmaCore.Theme.disabledTextColor
            }
        }

        Label {
            id: lblCPUTDP
            anchors {
                top: lblCPUCodeName.bottom
                left: parent.left
                topMargin: 15
                leftMargin: 10
            }

            text: "TDP: "
            font.pointSize: 10
            font.bold: true

            Label {
                anchors.top: parent.top
                anchors.left: parent.right
                anchors.leftMargin: 5
                text: backend.cpuTDP
                font.pointSize: 10
                font.bold: false
                color: PlasmaCore.Theme.disabledTextColor
            }
        }
    }

    Rectangle {
        id: rectCPURight

        anchors {
            top: parent.top
            left: rectCPULeft.right
            right: parent.right
        }

        Label {
            id: lblCPUStockFrequency
            anchors {
                top: parent.top
                left: parent.left
                topMargin: 10
                leftMargin: 10
            }

            text: "Stock Frequency: "
            font.pointSize: 10
            font.bold: true

            Label {
                anchors.top: parent.top
                anchors.left: parent.right
                anchors.leftMargin: 5
                text: backend.cpuBaseFreq
                font.pointSize: 10
                font.bold: false
                color: PlasmaCore.Theme.disabledTextColor
            }
        }

        Label {
            id: lblCPUCurrentFrequency
            anchors {
                top: lblCPUStockFrequency.bottom
                left: parent.left
                topMargin: 15
                leftMargin: 10
            }
            text: "Current Frequency: "
            font.pointSize: 10
            font.bold: true

            Label {
                anchors.top: parent.top
                anchors.left: parent.right
                anchors.leftMargin: 5
                text: backend.cpuFreqText
                font.pointSize: 10
                font.bold: false
                color: PlasmaCore.Theme.disabledTextColor
            }
        }

        Label {
            id: lblCPUSocketType
            anchors {
                top: lblCPUCurrentFrequency.bottom
                left: parent.left
                topMargin: 15
                leftMargin: 10
            }
            text: "Socket Type: "
            font.pointSize: 10
            font.bold: true

            Label {
                anchors.top: parent.top
                anchors.left: parent.right
                anchors.leftMargin: 5
                text: backend.cpuSocketType
                font.pointSize: 10
                font.bold: false
                color: PlasmaCore.Theme.disabledTextColor
            }
        }
    }
}
