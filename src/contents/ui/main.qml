import QtQuick 2.12
import CustomControls 1.0
import QtQuick.Layouts 1.14
import org.kde.kirigami 2.4 as Kirigami
import QtQuick.Controls 2.14 as Controls
import org.kde.plasma.components 2.0 as KDE

Kirigami.ApplicationWindow {
    id: root
    title: "NZXT Fan and Lighting control"
    height: 565
    width: 600
    
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
                main: Kirigami.Action {
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
                }
                contextualActions: [
                    Kirigami.Action {
                        text: i18n("Contextual Action 1")
                        iconName: "bookmarks"
                        onTriggered: showPassiveNotification(i18n("Contextual action 1 clicked"))
                    },
                    Kirigami.Action {
                        text: i18n("Contextual Action 2")
                        iconName: "folder"
                        enabled: false
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

                        // CPU and GPU
                        Rectangle {
                            id: cpuRect
                            Layout.row: 0
                            Layout.column: 0
                            Layout.columnSpan: 3
                            Layout.fillWidth: true
                            Layout.preferredHeight: 175
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
                                    Layout.alignment: Qt.AlignVCenter
                                    //anchors.verticalCenter: parent.verticalCenter
                                    //anchors.left: parent.anchors.left
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
                                    Layout.rightMargin: 10
                                    Layout.leftMargin: 50
                                    implicitWidth: 125
                                }
                                KDE.ProgressBar {
                                    id:cpuClockProgress
                                    value: 0.9
                                    Layout.row: 2
                                    Layout.column: 1
                                    Layout.rightMargin: 10
                                    Layout.leftMargin: 50
                                    implicitWidth: 125
                                }
                                KDE.ProgressBar {
                                    id:cpuFanProgress
                                    value: 0.6
                                    Layout.row: 3
                                    Layout.column: 1
                                    Layout.rightMargin: 10
                                    Layout.leftMargin: 50
                                    implicitWidth: 125
                                }
                            }
                        }
                        Rectangle {
                            id: gpuRect
                            Layout.row: 0
                            Layout.column: 3
                            Layout.columnSpan: 3
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.preferredHeight: 175
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
                                    Layout.alignment: Qt.AlignVCenter
                                    //anchors.verticalCenter: parent.verticalCenter
                                    //anchors.left: parent.anchors.left
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
                                    Layout.rightMargin: 10
                                    Layout.leftMargin: 50
                                    implicitWidth: 125
                                }
                                KDE.ProgressBar {
                                    id:gpuClockProgress
                                    value: 0.9
                                    Layout.row: 2
                                    Layout.column: 1
                                    Layout.rightMargin: 10
                                    Layout.leftMargin: 50
                                    implicitWidth: 125
                                }
                                KDE.ProgressBar {
                                    id:gpuFanProgress
                                    value: 0.6
                                    Layout.row: 3
                                    Layout.column: 1
                                    Layout.rightMargin: 10
                                    Layout.leftMargin: 50
                                    implicitWidth: 125
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
                            Layout.maximumWidth: 190
                            Layout.preferredHeight: 150
                            color: Kirigami.Theme.backgroundColor
                            border.color: Kirigami.Theme.alternateBackgroundColor
                            border.width: 1
                            radius: 3 
                            antialiasing: true
                            Text {
                                text: qsTr("RAM Info")
                                color: "white"
                            }
                        }
                        
                        Rectangle {
                            id: netRect
                            Layout.row: 1
                            Layout.column: 2
                            Layout.columnSpan: 2
                            Layout.fillWidth: true
                            Layout.maximumWidth: 190
                            Layout.preferredHeight: 150
                            color: Kirigami.Theme.backgroundColor
                            border.color: Kirigami.Theme.alternateBackgroundColor
                            border.width: 1
                            radius: 3 
                            antialiasing: true
                            Text {
                                text: qsTr("Network Info")
                                color: "white"
                            }
                        }
                        
                        Rectangle {
                            id: storRect
                            Layout.row: 1
                            Layout.column: 4
                            Layout.columnSpan: 2
                            Layout.fillWidth: true
                            Layout.maximumWidth: 190
                            Layout.preferredHeight: 150
                            color: Kirigami.Theme.backgroundColor
                            border.color: Kirigami.Theme.alternateBackgroundColor
                            border.width: 1
                            radius: 3 
                            antialiasing: true
                            Text {
                                text: qsTr("Storage Info")
                                color: "white"
                            }
                        }
                        
                         Rectangle {
                            id: procRect
                            Layout.row: 2
                            Layout.column: 0
                            Layout.columnSpan: 6
                            Layout.fillWidth: true
                            Layout.preferredHeight: 125
                            color: Kirigami.Theme.backgroundColor
                            border.color: Kirigami.Theme.alternateBackgroundColor
                            border.width: 1
                            radius: 3 
                            antialiasing: true
                            Text {
                                text: qsTr("Process Info")
                                color: "white"
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

