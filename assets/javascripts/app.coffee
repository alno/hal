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
      buttons: [{
        type: 'hour',
        count: 1,
        text: '1h'
      }, {
        type: 'day',
        count: 1,
        text: '1d'
      }, {
        type: 'week',
        count: 1,
        text: '1w'
      }, {
        type: 'month',
        count: 1,
        text: '1m'
      }, {
        type: 'year',
        count: 1,
        text: '1y'
      }, {
        type: 'all',
        text: 'All'
      }]

    title:
      text: chart.data('title')

    series: [{
      name: chart.data('title'),
      data: chart.data('values'),
      type: 'spline',
      tooltip:
        valueDecimals: 2
    }]
