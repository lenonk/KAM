import QtQuick 2.12
import CustomControls 1.0
import QtQuick.Layouts 1.4
import org.kde.kirigami 2.4 as Kirigami
import QtQuick.Controls 2.13 as Controls
import QtQuick.Controls 1.4

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
                    id: monButton
                    text: qsTr("Monitoring")
                    width: undefined
                }
                KAMTabButton {
                    id: specButton
                    text: qsTr("Specs")
                    width: undefined
                }
                KAMTabButton {
                    id: gameButton
                    text: qsTr("Games")
                    width: undefined
                }
            }

            StackLayout {
                currentIndex: tabBar.currentIndex
                anchors {
                    top: tabBar.bottom
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }

                MonitorTab {
                    id: monitorTab
                }

                Item {
                    id: specsTab
                    //SpecPage {}
                }
                Item {
                    id: gamesTab
                    //GamesPage {}
                }
            }
        }
    }
}
