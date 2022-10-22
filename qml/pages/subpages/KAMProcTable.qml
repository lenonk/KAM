import QtQuick 2.15
import CustomControls 1.0
import QtQuick.Layouts 1.4
import QtQuick.Controls 2.15
import org.kde.plasma.core 2.0 as PlasmaCore

import Qt.labs.qmlmodels 1.0

import org.kde.kcoreaddons 1.0 as KCoreAddons
import org.kde.kitemmodels 1.0 as KItemModels
import org.kde.quickcharts 1.0 as Charts

import org.kde.ksysguard.formatter 1.0 as Formatter
import org.kde.ksysguard.process 1.0 as Process
import org.kde.ksysguard.table 1.0 as Table

Table.BaseTableView {
    id: view

    anchors.fill: parent
    anchors.leftMargin: 10
    anchors.rightMargin: 10
    anchors.topMargin: 10
    anchors.bottomMargin: 10

    property var enabledColumns: [
        "appName",
        "usage",
        "vmPSS",
        "nvidia_usage",
        "nvidia_memory",
        "netInbound",
        "netOutbound",
        //"IconName"
    ]
    property alias columnDisplay: displayModel.columnDisplay
    property alias sourceModel: appModel

    property alias filterString: sortColumnFilter.filterString

    idRole: "Attribute"

    columnWidths: [0.318, 0.1, 0.12, 0.12, 0.13, 0.12, 0.1]

    /*PropertyAnimation {
        id: animationView
        target: view
        property: "columnWidths"
        to: {
            if (view.columnWidths[0] == 0.318) {
                console.log("Here 1: " + view.columnWidths[0])
                return view.width
            }
            else {
                console.log("Here 2: " + view.columnWidths[0])
                return view.width
            }
        }

        duration: 500
        easing.type: Easing.InOutCirc
    }*/

    Item {
        id: itemMenuSignal
        Connections {
            target: btnMenu
            function onMenuExpanded(menuIsExpanded) {
                if (menuIsExpanded)
                    view.columnWidths = [0.318, 0.1, 0.12, 0.12, 0.13, 0.12, 0.1]
                else
                    view.columnWidths = [0.28, 0.1, 0.12, 0.12, 0.13, 0.12, 0.1]
            }
        }
    }

    onSort: {
        sortColumnFilter.sortColumn = column
        sortColumnFilter.sortOrder = order
    }

    headerModel: sortColumnFilter

    // @disable-check M300
    model: KItemModels.KSortFilterProxyModel {
        id: sortColumnFilter

        sourceModel: cacheModel
        filterKeyColumn: appModel.nameColumn
        filterCaseSensitivity: Qt.CaseInsensitive
        filterColumnCallback: function(column, parent) {
            // Note: This assumes displayModel column == appModel column
            // This may not always hold, but we get incorrect results if we try to
            // map to source indices when the model is empty.
            var sensorId = appModel.enabledAttributes[column]
            if (appModel.hiddenAttributes.indexOf(sensorId) != -1) {
                return false
            }
            return true
        }
        filterRowCallback: function(row, parent) {
            // @disable-check M126
            if (filterString.length == 0) {
                return true
            }
            const name = sourceModel.data(sourceModel.index(row, filterKeyColumn, parent), filterRole).toLowerCase()
            const parts = filterString.toLowerCase().split(",").map(s => s.trim()).filter(s => s.length > 0)
            return parts.some(part => name.includes(part))
        }

        sortRole: "Value"
    }

    // @disable-check M300
    Table.ComponentCacheProxyModel {
        id: cacheModel
        sourceModel: displayModel

        // @disable-check M300
        component: Charts.HistoryProxySource {
            id: history
            // @disable-check M300
            source: Charts.ModelSource {
                model: history.Table.ComponentCacheProxyModel.model
                column: history.Table.ComponentCacheProxyModel.column
                roleName: "Value"
            }
            item: Table.ComponentCacheProxyModel.row
            maximumHistory: 10
            interval: 2000
            fillMode: Charts.HistoryProxySource.FillFromEnd
        }
    }

    // @disable-check M300
    Table.ColumnDisplayModel {
        id: displayModel
        sourceModel: appModel
        idRole: "Attribute"
    }

    // @disable-check M300
    Process.ApplicationDataModel {
        id: appModel

        property int nameColumn: enabledAttributes.indexOf("appName")
        property int iconColumn: enabledAttributes.indexOf("iconName")

        property var requiredAttributes: [
            "iconName",
            "appName",
            "usage",
            "vmPSS",
            "nvidia_usage",
            "nvidia_memory",
        ]
        property var hiddenAttributes: []

        enabled: view.visible

        enabledAttributes: {
            var result = []
            for (var i of view.enabledColumns) {
                if (appModel.availableAttributes.includes(i)) {
                    result.push(i)
                }
            }

            var hidden = []
            for (let i of requiredAttributes) {
                if (result.indexOf(i) == -1) {
                    result.push(i)
                    hidden.push(i)
                }
            }

            hiddenAttributes = hidden
            return result;
        }
    }

    delegate: DelegateChooser {
        role: "displayStyle"
        DelegateChoice {
            column: view.LayoutMirroring.enabled ? view.model.columnCount() - 1 : 0
            Table.FirstCellDelegate {
                iconName: {
                    var index = sortColumnFilter.mapToSource(sortColumnFilter.index(model.row, 0));
                    index = appModel.index(index.row, appModel.iconColumn)
                    return appModel.data(index)
                }
            }
        }
        DelegateChoice {
            roleValue: "line"
            Table.LineChartCellDelegate {
                // @disable-check M126
                valueSources: model.cachedComponent != undefined ? model.cachedComponent : []
                maximum: sortColumnFilter.data(sortColumnFilter.index(model.row, model.column), Process.ProcessDataModel.Maximum)
            }
        }
        DelegateChoice {
            roleValue: "lineScaled"
            Table.LineChartCellDelegate {
                // @disable-check M126
                valueSources: model.cachedComponent != undefined ? model.cachedComponent : []
                maximum: sortColumnFilter.data(sortColumnFilter.index(model.row, model.column), Process.ProcessDataModel.Maximum)
                text: Formatter.Formatter.formatValue(parseInt(model.Value) / model.Maximum * 100, model.Unit)
            }

        }
        DelegateChoice {
            roleValue: "textScaled"
            Table.TextCellDelegate {
                text: Formatter.Formatter.formatValue(parseInt(model.Value) / model.Maximum * 100, model.Unit)
            }
        }
        DelegateChoice { Table.TextCellDelegate { } }
    }
}
