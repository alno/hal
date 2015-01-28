#= require foundation/foundation
#= require foundation/foundation.section
#= require foundation/foundation.reveal
#= require highstock

$(document).foundation()

Highcharts.setOptions
  global:
    useUTC: false

$('#gauge_chart').each ->
  container = $(@)

  loadData = (e) ->
    chart = container.highcharts()
    chart.showLoading('Loading data from server...')

    $.getJSON container.data('url'), from: Math.round(e.min), to: Math.round(e.max), nodes: (s.path for s in container.data('series')), (data) ->
      for serieData, i in data
        chart.series[i].setData(serieData)
      chart.hideLoading()

  seriesConfig = for serie in container.data('series')
    name: serie.name
    data: serie.data
    type: 'spline'
    tooltip:
      valueDecimals: 2


  container.highcharts 'StockChart',

    rangeSelector:
      selected: 4
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
      text: container.data('title')

    series: seriesConfig

    navigator:
      adaptToUpdatedData: false

    scrollbar:
      liveRedraw: false

    xAxis:
      events:
        afterSetExtremes: loadData
      minRange: 3600 * 1000
