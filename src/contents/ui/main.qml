import QtQuick 2.12
import CustomControls 1.0
import QtQuick.Layouts 1.14
import org.kde.kirigami 2.4 as Kirigami
import QtQuick.Controls 2.14 as Controls
import QtQuick.Controls 1.4
import org.kde.plasma.components 2.0 as KDE

Kirigami.ApplicationWindow {
    id: root
    title: "NZXT Fan and Lighting control"
    //height: 575
    //width: 600
    height: 625
    width: 650

    maximumHeight: height
    maximumWidth: width
    minimumHeight: height
    minimumWidth: width
    
    globalDrawer: Kirigami.GlobalDrawer {
        title: i18n("KAM")
        titleIcon: "applications-graphics"
        actions: [
            Kirigami.Action {
                text: i18n("View")
                iconName: "view-list-icons"
                Kirigami.Action {
                    text: i18n("View Action 1")
                    onTriggered: showPassiveNotification(i18n("View Action 1 clicked"))
                }
                Kirigami.Action {
                    text: i18n("View Action 2")
                    onTriggered: showPassiveNotification(i18n("View Action 2 clicked"))
                }
            },
            Kirigami.Action {
                text: i18n("Action 1")
                onTriggered: showPassiveNotification(i18n("Action 1 clicked"))
            },
            Kirigami.Action {
                text: i18n("Action 2")
                onTriggered: showPassiveNotification(i18n("Action 2 clicked"))
            }
        ]
    }

    pageStack.initialPage: mainPageComponent

    Component {
        id: mainPageComponent
        
        Kirigami.Page {
            title: i18n("KDE KAM")

            actions {
                /*main: Kirigami.Action {
                    iconName: "go-home"
                    onTriggered: showPassiveNotification(i18n("Main action triggered"))
                }
                left: Kirigami.Action {
                    iconName: "go-previous"
                    onTriggered: showPassiveNotification(i18n("Left action triggered"))
                }
                right: Kirigami.Action {
                    iconName: "go-next"
                    onTriggered: showPassiveNotification(i18n("Right action triggered"))
                }*/
                contextualActions: [
                    Kirigami.Action {
                        text: i18n("MY PC")
                        iconName: "arrow-right"
                        onTriggered: showPassiveNotification(i18n("Contextual action 1 clicked"))
                        //enabled: false
                    },
                    Kirigami.Action {
                        text: i18n("LIGHTING")
                        iconName: "arrow-right"
                        onTriggered: showPassiveNotification(i18n("Contextual action 2 clicked"))
                    },
                    Kirigami.Action {
                        text: i18n("TUNING")
                        iconName: "arrow-right"
                        enabled: false
                        onTriggered: showPassiveNotification(i18n("Contextual action 3 clicked"))
                    }
                ]
            }
     
            KAMTabBar {
                id: tabBar
                width: parent.width

                KAMTabButton {
                    text: qsTr("Monitoring")
                    width: explicitWidth
                }
                KAMTabButton {
                    text: qsTr("Specs")
                    width: explicitWidth
                }
                KAMTabButton {
                    text: qsTr("Games")
                    width: explicitWidth
                }
            }

            StackLayout {
                currentIndex: tabBar.currentIndex
                anchors.top: tabBar.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                
                Item {
                    id: monitorTab
                    GridLayout {
                        id: pageLayout
                        anchors.fill: parent
                        rows: 3
                        columns: 6
                        columnSpacing: 12
                        rowSpacing: 8

                        // CPU and GPU
                        Rectangle {
                            id: cpuRect
                            Layout.row: 0
                            Layout.column: 0
                            Layout.columnSpan: 3
                            Layout.fillWidth: true
                            Layout.preferredHeight: 200
                            Layout.topMargin: 5
                            color: Kirigami.Theme.backgroundColor
                            border.color: Kirigami.Theme.alternateBackgroundColor
                            border.width: 1
                            radius: 3 
                            antialiasing: true
                            GridLayout {
                                id: cpuLayout
                                anchors.fill: parent
                                rows: 5
                                columns: 2

                                Text {
                                    id: cpuText
                                    text: qsTr("CPU")
                                    Layout.row: 0
                                    Layout.column: 0
                                    color: Kirigami.Theme.textColor
                                    Layout.leftMargin: 10
                                }
                                KAMRadialBar {
                                    x: 10
                                    id: cpuRaidialBar
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.anchors.left
                                    Layout.row: 1
                                    Layout.rowSpan: 3
                                    Layout.column: 0
                                }
                                Text {
                                    id: loadText
                                    text: qsTr("Minimal Load")
                                    Layout.row: 4
                                    Layout.column: 0
                                    color: Kirigami.Theme.textColor
                                    Layout.leftMargin: 10
                                }
                                KDE.ProgressBar {
                                    id:cpuTempProgress
                                    value: 0.2
                                    Layout.row: 1
                                    Layout.column: 1
                                    Layout.alignment: Qt.AlignRight
                                    Layout.rightMargin: 10
                                    Layout.bottomMargin: 15
                                    implicitWidth: 150
                                    implicitHeight: 10
                                    Text {
                                        anchors.top: parent.bottom
                                        anchors.left: parent.left
                                        color: Kirigami.Theme.textColor
                                        text: qsTr("Temperature")
                                    }
                                    Text {
                                        anchors.top: parent.bottom
                                        anchors.right: parent.right
                                        color: Kirigami.Theme.textColor
                                        text: qsTr("38C")
                                    }
                                }
                                KDE.ProgressBar {
                                    id:cpuClockProgress
                                    value: 0.9
                                    Layout.row: 2
                                    Layout.column: 1
                                    Layout.alignment: Qt.AlignRight
                                    Layout.rightMargin: 10
                                    Layout.bottomMargin: 15
                                    implicitWidth: 150
                                    implicitHeight: 10
                                    Text {
                                        anchors.top: parent.bottom
                                        color: Kirigami.Theme.textColor
                                        text: qsTr("Clock")
                                    }
                                    Text {
                                        anchors.top: parent.bottom
                                        anchors.right: parent.right
                                        color: Kirigami.Theme.textColor
                                        text: qsTr("4250 MHz")
                                    }
                                }
                                KDE.ProgressBar {
                                    id:cpuFanProgress
                                    value: 0.6
                                    Layout.row: 3
                                    Layout.column: 1
                                    Layout.alignment: Qt.AlignRight
                                    Layout.rightMargin: 10
                                    Layout.bottomMargin: 15
                                    implicitWidth: 150
                                    implicitHeight: 10
                                    Text {
                                        anchors.top: parent.bottom
                                        color: Kirigami.Theme.textColor
                                        text: qsTr("Fan")
                                    }
                                    Text {
                                        anchors.top: parent.bottom
                                        anchors.right: parent.right
                                        color: Kirigami.Theme.textColor
                                        text: qsTr("2051 RPM")
                                    }
                                }
                            }
                        }
                        Rectangle {
                            id: gpuRect
                            Layout.row: 0
                            Layout.column: 3
                            Layout.columnSpan: 3
                            Layout.fillWidth: true
                            Layout.preferredHeight: 200
                            Layout.topMargin: 5
                            color: Kirigami.Theme.backgroundColor
                            border.color: Kirigami.Theme.alternateBackgroundColor
                            border.width: 1
                            radius: 3 
                            antialiasing: true
                            GridLayout {
                                id: gpuLayout
                                anchors.fill: parent
                                rows: 5
                                columns: 2

                                Text {
                                    id: gpuText
                                    text: qsTr("GPU")
                                    Layout.row: 0
                                    Layout.column: 0
                                    color: Kirigami.Theme.textColor
                                    Layout.leftMargin: 10
                                }
                                KAMRadialBar {
                                    x: 10
                                    id: gpuRaidialBar
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.anchors.left
                                    Layout.row: 1
                                    Layout.rowSpan: 3
                                    Layout.column: 0
                                }
                                Text {
                                    id: obs64Text
                                    text: qsTr("obs64")
                                    Layout.row: 4
                                    Layout.column: 0
                                    color: Kirigami.Theme.textColor
                                    Layout.leftMargin: 10
                                }

                                KDE.ProgressBar {
                                    id:gpuTempProgress
                                    value: 0.2
                                    Layout.row: 1
                                    Layout.column: 1
                                    Layout.alignment: Qt.AlignRight
                                    Layout.rightMargin: 10
                                    Layout.bottomMargin: 15
                                    implicitWidth: 150
                                    implicitHeight: 10
                                    Text {
                                        anchors.top: parent.bottom
                                        anchors.left: parent.left
                                        color: Kirigami.Theme.textColor
                                        text: qsTr("Temperature")
                                    }
                                    Text {
                                        anchors.top: parent.bottom
                                        anchors.right: parent.right
                                        color: Kirigami.Theme.textColor
                                        text: qsTr("45C")
                                    }
                                }
                                KDE.ProgressBar {
                                    id:gpuClockProgress
                                    value: 0.9
                                    Layout.row: 2
                                    Layout.column: 1
                                    Layout.alignment: Qt.AlignRight
                                    Layout.rightMargin: 10
                                    Layout.bottomMargin: 15
                                    implicitWidth: 150
                                    implicitHeight: 10
                                    Text {
                                        anchors.top: parent.bottom
                                        anchors.left: parent.left
                                        color: Kirigami.Theme.textColor
                                        text: qsTr("Clock")
                                    }
                                    Text {
                                        anchors.top: parent.bottom
                                        anchors.right: parent.right
                                        color: Kirigami.Theme.textColor
                                        text: qsTr("2100 MHz")
                                    }
                                }
                                KDE.ProgressBar {
                                    id:gpuFanProgress
                                    value: 0.6
                                    Layout.row: 3
                                    Layout.column: 1
                                    Layout.alignment: Qt.AlignRight
                                    Layout.rightMargin: 10
                                    Layout.bottomMargin: 15
                                    implicitWidth: 150
                                    implicitHeight: 10
                                    Text {
                                        anchors.top: parent.bottom
                                        anchors.left: parent.left
                                        color: Kirigami.Theme.textColor
                                        text: qsTr("Fan")
                                    }
                                    Text {
                                        anchors.top: parent.bottom
                                        anchors.right: parent.right
                                        color: Kirigami.Theme.textColor
                                        text: qsTr("1458 RPM")
                                    }
                                }
                            }
                        }
                        
                        // RAM and Network and Storage
                        Rectangle {
                            id: ramRect
                            Layout.row: 1
                            Layout.column: 0
                            Layout.columnSpan: 2
                            Layout.fillWidth: true
                            //Layout.maximumWidth: 190
                            Layout.preferredHeight: 150
                            color: Kirigami.Theme.backgroundColor
                            border.color: Kirigami.Theme.alternateBackgroundColor
                            border.width: 1
                            radius: 3 
                            antialiasing: true
                            GridLayout {
                                rows: 2
                                columns: 1
                                anchors.fill: parent

                                Text {
                                    Layout.row: 0
                                    Layout.column: 0
                                    Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                                    text: qsTr("RAM")
                                    color: "white"
                                }
                                KAMRadialBar {
                                    id: ramRaidialBar
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.bottom: parent.anchors.bottom
                                    dialWidth: 5
                                    Layout.row: 1
                                    Layout.column: 0
                                    textFont {
                                        family: "MrEavesXLModOT-Book"
                                        pointSize: 18
                                    }
                                }
                            }
                        }
                        
                        Rectangle {
                            id: netRect
                            Layout.row: 1
                            Layout.column: 2
                            Layout.columnSpan: 2
                            Layout.fillWidth: true
                            //Layout.maximumWidth: 190
                            Layout.preferredHeight: 150
                            color: Kirigami.Theme.backgroundColor
                            border.color: Kirigami.Theme.alternateBackgroundColor
                            border.width: 1
                            radius: 3 
                            antialiasing: true
                            Text {
                                text: qsTr("Network")
                                color: "white"
                            }
                        }
                        
                        Rectangle {
                            id: storRect
                            Layout.row: 1
                            Layout.column: 4
                            Layout.columnSpan: 2
                            Layout.fillWidth: true
                            //Layout.maximumWidth: 190
                            Layout.preferredHeight: 150
                            color: Kirigami.Theme.backgroundColor
                            border.color: Kirigami.Theme.alternateBackgroundColor
                            border.width: 1
                            radius: 3 
                            antialiasing: true
                            GridLayout {
                                anchors.fill: parent
                                rows: 5

                                Text {
                                    font.bold: true
                                    font.pointSize: 14
                                    Layout.row: 0
                                    Layout.column: 0
                                    Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                                    Layout.leftMargin: 10
                                    Layout.topMargin: 10
                                    Layout.columnSpan: 2
                                    color: Kirigami.Theme.textColor
                                    text: qsTr("Storage")
                                }
                                Text {
                                    font.weight: Font.Light
                                    font.pointSize: 18
                                    Layout.row: 1
                                    Layout.column: 0
                                    //Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                                    Layout.alignment: Qt.AlignVCenter
                                    Layout.leftMargin: 10
                                    Layout.topMargin: 10
                                    color: Kirigami.Theme.textColor
                                    text: qsTr("/")
                                }
                                KDE.ProgressBar {
                                    Layout.row: 2
                                    Layout.column: 0
                                    //Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                                    Layout.alignment: Qt.AlignVCenter
                                    Layout.leftMargin: 10
                                }

                                Text {
                                    font.weight: Font.Light
                                    font.pointSize: 18
                                    Layout.row: 3
                                    Layout.column: 0
                                    //Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                                    Layout.alignment: Qt.AlignVCenter
                                    Layout.leftMargin: 10
                                    Layout.topMargin: 10
                                    color: Kirigami.Theme.textColor
                                    text: qsTr("/home")
                                }
                                KDE.ProgressBar {
                                    Layout.row: 4
                                    Layout.column: 0
                                    //Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                                    Layout.alignment: Qt.AlignCenter
                                    Layout.leftMargin: 10
                                }
                            }
                        }
                        
                        TableView {
                            Layout.row: 2
                            Layout.column: 0
                            Layout.columnSpan: 6
                            Layout.preferredHeight: 150
                            Layout.fillWidth: true

                            TableViewColumn {
                                title: "Top Processes"
                                role: "process"
                                width: 200
                            }
                            TableViewColumn {
                                title: "CPU"
                                role: "cpu"
                                width: 75
                            }
                            TableViewColumn {
                                title: "GPU"
                                role: "gpu"
                                width: 75
                            }
                            TableViewColumn {
                                title: "RAM"
                                role: "ram"
                                width: 75
                            }
                            TableViewColumn {
                                title: "Upload"
                                role: "upload"
                                width: 90
                            }
                            TableViewColumn {
                                title: "Download"
                                role: "download"
                                width: 90
                            }

                            model: tableModel
                        }

                        ListModel {
                            id: tableModel
                            ListElement {
                                process: "Microsoft Teams"
                                cpu: "0.0%"
                                gpu: "1%"
                                ram: "733.5MB"
                                upload: "568 b/s"
                                download: "45 kb/s"
                            }
                            ListElement {
                                process: "Deepin System Monitor"
                                cpu: "10.1%"
                                gpu: "17.4%"
                                ram: "24.7MB"
                                upload: ""
                                download: ""
                            }
                            ListElement {
                                process: "GMail/Inbox - Kontact"
                                cpu: "5.5%"
                                gpu: "1%"
                                ram: "176.3MB"
                                upload: "46 kb/s"
                                download: "4598 kb/s"
                            }
                        }
                    }
                }
                Item {
                    id: specsTab
                }
                Item {
                    id: gamesTab
                }
            }
        }
    }
}

