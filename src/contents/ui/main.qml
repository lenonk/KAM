import QtQuick 2.12
import CustomControls 1.0
import QtQuick.Layouts 1.4
import org.kde.kirigami 2.4 as Kirigami

Kirigami.ApplicationWindow {
    id: root
    title: "Fan and Lighting control"
    height: 625
    width: 650

    maximumHeight: height
    maximumWidth: width
    minimumHeight: height
    minimumWidth: width

    property int isMinimized: 3

    Backend {
        id: backend
    }

    onVisibilityChanged: {
        if (visibility === isMinimized)
            hide()
    }

    function showApp() {
        applicationWindow().show()
        applicationWindow().raise()
        applicationWindow().requestActivate()
    }

    globalDrawer: Kirigami.GlobalDrawer {
        title: "KDE KAM"
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
        id: lightingPageComponent
        
        Kirigami.Page {
            title: i18n("LIGHTING")
            
            KAMPageHeader { }
        }
    }
    Component {
        id: mainPageComponent
        
        Kirigami.Page {
            title: i18n("MY PC")
               
            KAMPageHeader {}
     
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
