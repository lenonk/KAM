import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import Qt.labs.platform 1.1 as Labs

import Backend 1.0

import org.kde.plasma.core 2.0 as PlasmaCore

import "controls"

Window {
    id: mainWindow
    width: 850
    height: 600
    visible: true
    minimumWidth: 850
    minimumHeight: 600
    color: "#00000000"

    flags: Qt.Window | Qt.FramelessWindowHint

    property int windowStatus: 0
    property int windowMargin: 10
    property int isMinimized: 3
    property bool menuIsExpanded: false

    property LeftMenuButton curActiveMenu: btnHome

    Backend {
        id: backend
    }

    Rectangle {
        id: rectAppContainer
        color: PlasmaCore.Theme.headerBackgroundColor
        anchors.fill: parent
        anchors.rightMargin: windowMargin
        anchors.leftMargin: windowMargin
        anchors.bottomMargin: windowMargin
        anchors.topMargin: windowMargin
        border.width: 1
        border.color: mainWindow.active ? PlasmaCore.Theme.highlightColor : PlasmaCore.Theme.headerBackgroundColor

        Rectangle {
            id: rectTitleBar
            height: 35
            color: PlasmaCore.Theme.headerBackgroundColor
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 1
            anchors.leftMargin: 1
            anchors.topMargin: 1
            anchors.bottomMargin: 1

            DragHandler {
                onActiveChanged: if (active) {
                                     mainWindow.startSystemMove()
                                     //internal.ifMaximizedWindowRestore()
                                 }
            }

            ToggleButton {
                id: btnMenu
                width: 40
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                btnIconSource: "images/svg_icons/menu_icon.svg"
                btnColorDefault: PlasmaCore.Theme.headerBackgroundColor
                btnColorMouseOver: PlasmaCore.Theme.buttonHoverColor
                btnColorClicked: PlasmaCore.Theme.buttonFocusColor

                signal menuExpanded(bool expanded)

                onClicked: {
                    animationMenu.running = true
                    menuExpanded(menuIsExpanded)
                    menuIsExpanded = !menuIsExpanded
                }

            }

            Label {
                id: lblKDE
                text: qsTr("KDE")
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: btnMenu.right
                anchors.leftMargin: 5
                font.bold: true
                font.pointSize: 20
                font.family: PlasmaCore.Theme.defaultFont
                color: PlasmaCore.Theme.headerTextColor
            }

            Label {
                id: lblKam
                text: qsTr("kam")
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: lblKDE.right
                font.bold: false
                font.family: PlasmaCore.Theme.defaultFont
                anchors.leftMargin: 0
                font.pointSize: 18
                color: PlasmaCore.Theme.headerTextColor
            }

            TopBarButton {
                id: btnClose
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                btnColorDefault: PlasmaCore.Theme.headerBackgroundColor
                btnColorMouseOver: PlasmaCore.Theme.buttonHoverColor
                btnColorClicked: "#ff007f"
                btnIconSource: "images/svg_icons/close_icon.svg"

                onClicked: function() { mainWindow.close() }
            }

            TopBarButton {
                id: btnMinimize
                anchors.right: btnClose.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                btnIconSource: "images/svg_icons/minimize_icon.svg"
                btnColorDefault: PlasmaCore.Theme.headerBackgroundColor
                btnColorMouseOver: PlasmaCore.Theme.buttonHoverColor
                btnColorClicked: PlasmaCore.Theme.buttonFocusColor

                onClicked: {
                    //if (SystemTrayIsEnabled)
                        mainWindow.hide()
                    //else
                    //mainWindow.showMinimized()
                    //internal.resetNormalWindow()

                }
            }
        }

        Rectangle {
            id: rectMenu
            width: 70
            anchors.left: parent.left
            anchors.top: rectTitleBar.bottom
            anchors.bottom: parent.bottom
            anchors.leftMargin: 1
            anchors.bottomMargin: 1
            color: PlasmaCore.Theme.backgroundColor
            border.width: 1
            border.color: PlasmaCore.Theme.backgroundColor
            radius: 10
            clip: true

            PropertyAnimation {
                id: animationMenu
                target: rectMenu
                property: "width"
                to: if (rectMenu.width == 70) return 175; else return 70
                duration: 500
                easing.type: Easing.InOutCirc
            }

            LeftMenuButton {
                id: btnHome
                width: parent.width
                height: 60
                text: qsTr("Home")
                anchors.left: parent.left
                anchors.top: parent.top
                isActiveMenu: true
                btnIconSource: "images/svg_icons/home_icon.svg"
                btnColorDefault: PlasmaCore.Theme.backgroundColor
                btnColorMouseOver: PlasmaCore.Theme.buttonHoverColor
                btnColorClicked: PlasmaCore.Theme.buttonFocusColor
                activeMenuColor: PlasmaCore.Theme.highlightColor
                clip: true

                hoverEnabled: true
                ToolTip.delay:500
                ToolTip.timeout: 5000
                ToolTip.visible: hovered
                ToolTip.text: qsTr("Home")

                onClicked: {
                    curActiveMenu.isActiveMenu = false
                    btnHome.isActiveMenu = true
                    curActiveMenu = btnHome
                    stackView.push(Qt.resolvedUrl("pages/homePage/homePage.qml"))
                }
            }

            LeftMenuButton {
                id: btnSysInfo
                width: parent.width
                height: 60
                text: qsTr("System Info")
                anchors.left: parent.left
                anchors.top: btnHome.bottom
                isActiveMenu: false
                btnIconSource: "images/svg_icons/sysinfo_icon.svg"
                btnColorDefault: PlasmaCore.Theme.backgroundColor
                btnColorMouseOver: PlasmaCore.Theme.buttonHoverColor
                btnColorClicked: PlasmaCore.Theme.buttonFocusColor
                activeMenuColor: PlasmaCore.Theme.highlightColor
                clip: true

                hoverEnabled: true
                ToolTip.delay:500
                ToolTip.timeout: 5000
                ToolTip.visible: hovered
                ToolTip.text: qsTr("System Info")

                onClicked: {
                    curActiveMenu.isActiveMenu = false
                    btnSysInfo.isActiveMenu = true
                    curActiveMenu = btnSysInfo
                    stackView.push(Qt.resolvedUrl("pages/sysInfoPage/sysInfoPage.qml"))
                }
            }

            LeftMenuButton {
                id: btnLighting
                width: parent.width
                height: 60
                text: qsTr("Lighting")
                anchors.left: parent.left
                anchors.top: btnSysInfo.bottom
                isActiveMenu: false
                btnIconSource: "images/svg_icons/lighting_icon.svg"
                btnColorDefault: PlasmaCore.Theme.backgroundColor
                btnColorMouseOver: PlasmaCore.Theme.buttonHoverColor
                btnColorClicked: PlasmaCore.Theme.buttonFocusColor
                activeMenuColor: PlasmaCore.Theme.highlightColor
                clip: true

                hoverEnabled: true
                ToolTip.delay:500
                ToolTip.timeout: 5000
                ToolTip.visible: hovered
                ToolTip.text: qsTr("Lighting")

                onClicked: {
                    curActiveMenu.isActiveMenu = false
                    btnLighting.isActiveMenu = true
                    curActiveMenu = btnLighting
                    stackView.push(Qt.resolvedUrl("pages/lightingPage/lightingPage.qml"))
                }
            }

            LeftMenuButton {
                id: btnCooling
                width: parent.width
                height: 60
                text: qsTr("Cooling")
                anchors.left: parent.left
                anchors.top: btnLighting.bottom
                isActiveMenu: false
                btnIconSource: "images/svg_icons/cooling_icon.svg"
                btnColorDefault: PlasmaCore.Theme.backgroundColor
                btnColorMouseOver: PlasmaCore.Theme.buttonHoverColor
                btnColorClicked: PlasmaCore.Theme.buttonFocusColor
                activeMenuColor: PlasmaCore.Theme.highlightColor
                clip: true

                hoverEnabled: true
                ToolTip.delay:500
                ToolTip.timeout: 5000
                ToolTip.visible: hovered
                ToolTip.text: qsTr("Cooling")

                onClicked: {
                    curActiveMenu.isActiveMenu = false
                    btnCooling.isActiveMenu = true
                    curActiveMenu = btnCooling
                    stackView.push(Qt.resolvedUrl("pages/coolingPage/coolingPage.qml"))
                }
            }

            LeftMenuButton {
                id: btnSettings
                width: parent.width
                height: 60
                text: qsTr("Settings")
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                isActiveMenu: false
                btnIconSource: "images/svg_icons/settings_icon.svg"
                btnColorDefault: PlasmaCore.Theme.backgroundColor
                btnColorMouseOver: PlasmaCore.Theme.buttonHoverColor
                btnColorClicked: PlasmaCore.Theme.buttonFocusColor
                activeMenuColor: PlasmaCore.Theme.highlightColor
                clip: true

                hoverEnabled: true
                ToolTip.delay:500
                ToolTip.timeout: 5000
                ToolTip.visible: hovered
                ToolTip.text: qsTr("Settings")

                onClicked: {
                    curActiveMenu.isActiveMenu = false
                    btnSettings.isActiveMenu = true
                    curActiveMenu = btnSettings
                    stackView.push(Qt.resolvedUrl("pages/settingsPage/settingsPage.qml"))
                }
            }
        }

        Rectangle {
            id: rectAppContent
            color: PlasmaCore.Theme.headerBackgroundColor
            anchors.left: rectMenu.right
            anchors.right: parent.right
            anchors.top: rectTitleBar.bottom
            anchors.bottom: parent.bottom
            anchors.rightMargin: 10
            anchors.bottomMargin: 10
            anchors.leftMargin: 10
            radius: 5

            StackView {
                id: stackView
                anchors.fill: parent
                clip: true
                initialItem: Qt.resolvedUrl("pages/homePage/homePage.qml")
                visible:true
            }
        }
    }

    DropShadow {
        anchors.fill: rectAppContainer
        horizontalOffset: 5
        verticalOffset: 5
        radius: 10
        samples: 16
        color: "#60000000"
        source:rectAppContainer
        z: -1
    }

    /*Labs.SystemTrayIcon {
        id: sysTrayIcon

        icon.source: "images/png_icons/kam.png"
        visible: true
        onActivated: {
            if (reason === Labs.SystemTrayIcon.Trigger) {
                if (mainWindow.visible === false) {
                    mainWindow.showNormal()
                    mainWindow.raise()
                    mainWindow.requestActivate()
                }
                else {
                    mainWindow.hide()
                }
            }
        }

        menu: Labs.Menu {
            id: trayMenu
            Labs.MenuItem {
                id: showItem
                text: qsTr("Show")
                onTriggered: {
                    mainWindow.showNormal()
                    mainWindow.raise()
                    mainWindow.requestActivate()
                }
            }
            Labs.MenuItem {
                id: hideItem
                text: qsTr("Hide")
                onTriggered: mainWindow.hide()
            }
            Labs.MenuSeparator {}
            Labs.MenuItem {
                id: quitItem
                text: qsTr("Quit")
                onTriggered: Qt.quit()
            }
        }
    }*/
}

/*##^##
Designer {
    D{i:0;height:600;width:850}
}
##^##*/
