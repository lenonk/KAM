import QtQuick 2.15
import CustomControls 1.0
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.15
import QtQuick.Layouts 1.15

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.networkmanagement 0.2 as PlasmaNM
import org.kde.kcoreaddons 1.0 as KCoreAddons

import "../../controls"

// TODO: Only scan network when visible

Rectangle {
    id: rectNetwork
    height: parent.height
    width: parent.width / 3
    color: PlasmaCore.Theme.headerBackgroundColor

    property int iconWidth: 18
    property int iconHeight: 18

    property PlasmaNM.NetworkModel connectionModel: null

    Component {
        id: networkModelComponent
        PlasmaNM.NetworkModel {}
    }

    connectionModel: networkModelComponent.createObject(rectNetwork)

    PlasmaNM.AppletProxyModel {
        id: appletProxyModel

        sourceModel: rectNetwork.connectionModel
    }

    QtObject {
        id: internal

        property real upLastTime: 0
        property real downLastTime: 0

        property real prevTxBytes: 0
        property real prevRxBytes: 0

        function getTxBytes(TxBytes) {
            let txBytes = 0;
            let upElapsedTime = 0;

            if (TxBytes === 0)
                return [0, "0 B"];

            if (upLastTime == 0) upLastTime = new Date().getTime();

            upElapsedTime = new Date().getTime() - upLastTime;

            if (upElapsedTime == 0) {
                prevTxBytes = TxBytes;
                return [0, "0 B"];
            }

            txBytes = prevTxBytes == 0 ? 0 : (TxBytes - prevTxBytes) * 1000 / upElapsedTime;
            prevTxBytes = TxBytes;
            upLastTime = new Date().getTime()

            return [txBytes, KCoreAddons.Format.formatByteSize(txBytes)];
        }

        function getRxBytes(RxBytes) {
            let rxBytes = 0;
            let downElapsedTime = 0;

            if (RxBytes === 0)
                return [0, "0 B"];

            if (downLastTime == 0) downLastTime = new Date().getTime();

            downElapsedTime = new Date().getTime() - downLastTime;

            if (downElapsedTime == 0) {
                prevRxBytes = RxBytes;
                return [0, "0 B"];
            }

            rxBytes = prevRxBytes == 0 ? 0 : (RxBytes - prevRxBytes) * 1000 / downElapsedTime;
            //console.info("rxBytes: "  + rxBytes)
            //console.info("prevRxBytes: "  + prevRxBytes)
            //console.info("RxBytes: "  + RxBytes)
            //console.info("downElapsedTime: "  + downElapsedTime)
            //console.info("downLastTime: "  + downLastTime)
            prevRxBytes = RxBytes;
            downLastTime = new Date().getTime()

            return [rxBytes, KCoreAddons.Format.formatByteSize(rxBytes)];
        }
    }

    Rectangle {
        id: rectNet
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

        ListView {
            id: theList
            model: appletProxyModel
            currentIndex: -1
            boundsBehavior: Flickable.StopAtBounds

            anchors {
                top: lblNetwork.bottom
                left: rectNet.left
                right: rectNet.right
            }

            delegate: Item {
                visible: model.ConnectionState == PlasmaNM.Enums.Activated

                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }

                TrafficMonitor {
                    id: monitor
                    anchors {
                        bottom: parent.bottom
                        left: parent.left
                        leftMargin: 10
                        bottomMargin: 5
                    }
                    visible: true
                    width: 100
                }

                Rectangle {
                    id: upLayout

                    anchors.top: parent.bottom
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.topMargin: 15

                    property var upBytes: internal.getTxBytes(model.TxBytes)

                    Image {
                        id: imgUpload

                        anchors.top: upLayout.top
                        anchors.right: upLayout.right

                        sourceSize.width: 15
                        sourceSize.height: 30
                        source: "../../images/svg_icons/arrow-upiconImage24px.svg"
                        fillMode: Image.Stretch
                    }

                    Label {
                        id: lblUploadSpeedUnits

                        anchors.bottom: imgUpload.bottom
                        anchors.right: imgUpload.left
                        anchors.rightMargin: 5

                        text: parent.upBytes[1].split(" ")[1] + "/s"
                        font.pointSize: 10
                        color: PlasmaCore.Theme.textColor
                    }

                    Label {
                        id: lblUploadSpeed

                        anchors.bottom: lblUploadSpeedUnits.bottom
                        anchors.right: lblUploadSpeedUnits.left
                        anchors.bottomMargin: -2

                        text: parent.upBytes[1].split(" ")[0]
                        font.pointSize: 16
                        color: PlasmaCore.Theme.textColor

                        onTextChanged: {
                            if (parent.upBytes[0] === 0)
                                overlayUp.color = "Black"
                            else
                                overlayUp.color = PlasmaCore.Theme.textColor

                            monitor.uploadSpeed = parent.upBytes[0]
                        }
                    }

                    ColorOverlay {
                        id: overlayUp
                        source: imgUpload
                        anchors.fill: imgUpload
                        color: "Black"
                        visible: true
                        anchors.verticalCenter: parent.verticalCenter
                        antialiasing: false
                        width: iconWidth
                        height: iconHeight
                        cached: false
                    }
                }

                Rectangle {
                    id: downLayout

                    anchors.top: upLayout.bottom
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.topMargin: 30

                    property var downBytes: internal.getRxBytes(model.RxBytes)

                    Image {
                        id: imgDownload

                        anchors.top: downLayout.top
                        anchors.right: downLayout.right

                        sourceSize.width: 15
                        sourceSize.height: 30
                        source: "../../images/svg_icons/arrow-downiconImage24px.svg"
                        fillMode: Image.Stretch
                    }

                    Label {
                        id: lblDownloadSpeedUnits

                        anchors.bottom: imgDownload.bottom
                        anchors.right: imgDownload.left
                        anchors.rightMargin: 5

                        text: parent.downBytes[1].split(" ")[1] + "/s"
                        font.pointSize: 10
                        color: PlasmaCore.Theme.textColor
                    }

                    Label {
                        id: lblDownloadSpeed

                        anchors.bottom: lblDownloadSpeedUnits.bottom
                        anchors.right: lblDownloadSpeedUnits.left
                        anchors.bottomMargin: -2

                        text: parent.downBytes[1].split(" ")[0]
                        font.pointSize: 16
                        color: PlasmaCore.Theme.textColor

                        onTextChanged: {
                            if (parent.downBytes[0] === 0)
                                overlayDown.color = "Black"
                            else
                                overlayDown.color = PlasmaCore.Theme.textColor

                            monitor.downloadSpeed = parent.downBytes[0]
                        }
                    }

                    ColorOverlay {
                        id: overlayDown

                        source: imgDownload
                        anchors.fill: imgDownload
                        color: "Black"
                        anchors.verticalCenter: parent.verticalCenter
                        antialiasing: false
                        width: iconWidth
                        height: iconHeight
                        cached: false
                    }
                }
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;height:163;width:250}
}
##^##*/
