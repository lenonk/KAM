import QtQuick 2.15
import CustomControls 1.0
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.15
import org.kde.plasma.core 2.0 as PlasmaCore

import "../../controls"

Rectangle {
    id: rectNetwork
    height: parent.height
    width: parent.width / 3
    color: PlasmaCore.Theme.headerBackgroundColor

    property int iconWidth: 18
    property int iconHeight: 18

    Rectangle {
        id: rectangle
        anchors.fill: parent
        anchors.rightMargin: 5
        anchors.leftMargin: 5
        anchors.topMargin: 10
        color: PlasmaCore.Theme.headerBackgroundColor
        border.color: PlasmaCore.Theme.highlightColor
        border.width: 1
        radius: 5

        Label {
            id: lblNetwork
            text: qsTr("Network")
            font.bold: true
            font.pointSize: 14
            color: PlasmaCore.Theme.textColor
            anchors {
                top: parent.top
                left: parent.left
                margins: 10
            }
        }

        Image {
            id: imgUpload
            sourceSize.width: 15
            sourceSize.height: 30
            anchors.right: parent.right
            anchors.top: lblNetwork.bottom
            anchors.topMargin: 12
            anchors.rightMargin: 20
            source: "../../images/svg_icons/arrow-upiconImage24px.svg"
            fillMode: Image.Stretch
        }

        Label {
            id: lblUploadSpeedUnits
            anchors {
                right: imgUpload.left
                bottom: imgUpload.bottom
                rightMargin: 5
            }
            text: "KiB/s"
            font.pointSize: 14
            color: PlasmaCore.Theme.textColor
        }

        Label {
            id: lblUploadSpeed
            anchors {
                right: lblUploadSpeedUnits.left
                bottom: lblUploadSpeedUnits.bottom
                bottomMargin: -3
            }
            text: "0"
            font.pointSize: 24
            color: PlasmaCore.Theme.textColor
        }

        Image {
            id: imgDownload
            sourceSize.width: 15
            sourceSize.height: 30
            anchors.right: parent.right
            anchors.top: imgUpload.bottom
            source: "../../images/svg_icons/arrow-downiconImage24px.svg"
            anchors.rightMargin: 20
            fillMode: Image.Stretch
        }

        Label {
            id: lblDownloadSpeedUnits
            anchors {
                right: imgDownload.left
                bottom: imgDownload.bottom
                rightMargin: 5
            }
            text: "KiB/s"
            font.pointSize: 14
            color: PlasmaCore.Theme.textColor
        }

        Label {
            id: lblDownloadSpeed
            anchors {
                right: lblDownloadSpeedUnits.left
                bottom: lblDownloadSpeedUnits.bottom
                bottomMargin: -3
            }
            text: "0"
            font.pointSize: 24
            color: PlasmaCore.Theme.textColor
        }

        ColorOverlay {
            source: imgUpload
            anchors.fill: imgUpload
            color: PlasmaCore.Theme.disabledTextColor
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: false
            width: iconWidth
            height: iconHeight
        }

        ColorOverlay {
            source: imgDownload
            anchors.fill: imgDownload
            color: PlasmaCore.Theme.disabledTextColor
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: false
            width: iconWidth
            height: iconHeight
        }
    }
}

/*##^##
Designer {
    D{i:0;height:163;width:250}
}
##^##*/
