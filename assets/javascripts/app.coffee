#= require foundation/foundation
#= require foundation/foundation.section
#= require foundation/foundation.reveal
#= require highstock

$(document).foundation()

Highcharts.setOptions
  global:
    useUTC: false

$('#gauge_chart').each ->
  chart = $(@)

  chart.highcharts 'StockChart',

    rangeSelector:
      selected: 1

    title:
      text: chart.data('title')

    series: [{
      name: chart.data('title'),
      data: chart.data('values'),
      tooltip:
        valueDecimals: 2
    }]
