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

    property alias nameFilterString: rowFilter.filterString
    property alias processModel: processModel
    property alias viewMode: rowFilter.viewMode
    property bool flatList

    readonly property bool treeModeSupported: processModel.hasOwnProperty("flatList")

    property alias columnDisplay: displayModel.columnDisplay
    property var enabledColumns
    onEnabledColumnsChanged: processModel.updateEnabledAttributes()

    readonly property var selectedProcesses: {
        var result = []
        var rows = {}

        for (var i of selection.selectedIndexes) {
            if (rows[i.row] != undefined) { continue }

            rows[i.row] = true

            var index = rowFilter.mapToSource(descendentsModel.mapToSource(i))

            var item = {}

            item.name = processModel.data(processModel.index(index.row, processModel.nameColumn, index.parent), Process.ProcessDataModel.ValueRole)
            item.pid = processModel.data(processModel.index(index.row, processModel.pidColumn, index.parent), Process.ProcessDataModel.ValueRole)
            item.username = processModel.data(processModel.index(index.row, processModel.usernameColumn, index.parent), Process.ProcessDataModel.ValueRole)

            result.push(item)
        }

        return result
    }

    idRole: "Attribute"

    onSort: rowFilter.sort(column, order)

    headerModel: rowFilter

    model: KItemModels.KDescendantsProxyModel {
        id: descendantsModel
        sourceModel: rowFilter
        expandsByDefault: true
    }

    Table.ProcessSortFilterModel {
        id: rowFilter
        sourceModel: cacheModel
        hiddenAttributes: processModel.hiddenSensors
    }

    Table.ComponentCacheProxyModel {
        id: cacheModel
        sourceModel: displayModel

        component: Charts.HistoryProxySource {
            id: history
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

    Table.ColumnDisplayModel {
        id: displayModel
        sourceModel: processModel
        idRole: "Attribute"
    }

    Process.ProcessDataModel {
        id: processModel

        property int nameColumn
        property int pidColumn
        property int uidColumn
        property int usernameColumn

        property var requiredSensors: [ "name", "usage", "vmPSS", "nvidia_usage", "nvidia_memory", "netInbound", "netOutbound" ]
        property var hiddenSensors: []

        enabledAttributes: requiredSensors
        enabled: true

        function updateEnabledAttributes() {
            var result = []

            for (var i of view.enabledColumns) {
                if (processModel.availableAttributes.includes(i)) {
                    result.push(i)
                }
            }

            var hidden = []
            for (let i of requiredSensors) {
                if (result.indexOf(i) == -1 && processModel.availableAttributes.includes(i)) {
                    result.push(i)
                    hidden.push(i)
                }
            }

            processModel.nameColumn = result.indexOf("name")
            processModel.pidColumn = result.indexOf("pid")
            processModel.uidColumn = result.indexOf("uid")
            processModel.usernameColumn = result.indexOf("username")
            processModel.hiddenSensors = hidden
            processModel.enabledAttributes = result
        }
    }

    delegate: DelegateChooser {
        role: "displayStyle"
        DelegateChoice {
            column: view.LayoutMirroring.enabled ? view.model.columnCount() - 1 : 0
            Table.FirstCellDelegate {
                id: delegate
                iconName: {
                    var index = descendantsModel.mapToSource(descendantsModel.index(model.row, 0))
                    index = rowFilter.mapToSource(index)
                    index = cacheModel.mapToSource(index)
                    index = displayModel.mapToSource(index)
                    index = processModel.index(index.row, processModel.nameColumn, index.parent)
                    return processModel.data(index)
                }
            }
        }

        DelegateChoice {
            roleValue: "line"
            Table.LineChartCellDelegate {
                valueSources: model.cachedComponent != undefined ? model.cachedComponent : []
                maximum: descendantsModel.data(descendantsModel.index(model.row, model.column), Process.ProcessDataModel.Maximum)
            }
        }

        DelegateChoice {
            roleValue: "lineScaled"
            Table.LineChartCellDelegate {
                valueSources: model.cachedComponent != undefined ? model.cachedComponent : []
                maximum: descendantsModel.data(descendantsModel.index(model.row, model.column), Process.ProcessDataModel.Maximum)
                text: Formatter.Formatter.formatValue(parseInt(model.Value) / model.Maximum * 100, model.Unit)
            }
        }
        DelegateChoice {
            roleValue: "textScaled"
            Table.TextCellDelegate {
                text: Formatter.Formatter.formatValue(parseInt(model.Value) / model.Maximum * 100, model.Unit)
            }
        }
        DelegateChoice { Table.TextCellDelegate{} }
    }

}
/*TableView {
    selectionMode: SelectionMode.NoSelection
    horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

    TableViewColumn {
        title: "Top Processes"
        width: 250
        delegate: Rectangle {
            anchors.fill: parent
            anchors.leftMargin: 10
            color: "#00000000"
            Image {
               id: icnProc
               anchors.leftMargin: 10
               verticalAlignment: Image.AlignVCenter
               source: "image://icons/" + model.process
               fillMode: Image.PreserveAspectFit
            }

            Text {
                anchors.left: icnProc.right
                verticalAlignment: Text.AlignVCenter
                anchors.leftMargin: 10
                color: PlasmaCore.Theme.textColor
                text: (model !== null) ? model.process : ""

            }
        }
    }
    TableViewColumn { 
        title: "CPU"
        delegate: Text {
            anchors.fill: parent
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter 
            anchors.rightMargin: 10
            color: PlasmaCore.Theme.textColor
            text: (model !== null) ? model.cpu : ""
        }
        width: 60 
    }
    TableViewColumn {
        title: "GPU"
        delegate: Text {
            anchors.fill: parent
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter 
            anchors.rightMargin: 10
            color: PlasmaCore.Theme.textColor
            text: (model !== null) ? model.gpu : ""
        }
        width: 60
    }
    TableViewColumn { 
        title: "RAM"
        delegate: Text {
            anchors.fill: parent
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter 
            anchors.rightMargin: 10
            color: PlasmaCore.Theme.textColor
            text: (model !== null) ? model.ram : ""
        }
        width: 60
    }
    TableViewColumn { 
        title: "Download"
        delegate: Text {
            anchors.fill: parent
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter 
            anchors.rightMargin: 10
            color: PlasmaCore.Theme.textColor
            text: (model !== null) ? model.download : ""
        }
        width: 90
    }
    TableViewColumn { 
        title: "Upload"
        delegate: Text {
            anchors.fill: parent
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter 
            anchors.rightMargin: 10
            color: PlasmaCore.Theme.textColor
            text: (model !== null) ? model.upload : ""
        }
        width: 90
    }
}*/


