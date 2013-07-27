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

    $.getJSON "#{container.data('url')}?from=#{Math.round(e.min)}&to=#{Math.round(e.max)}", (data) ->
      chart.series[0].setData(data)
      chart.hideLoading()

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

    series: [{
      name: container.data('title'),
      data: container.data('values'),
      type: 'spline',
      tooltip:
        valueDecimals: 2
    }]

    chart:
      zoomType: 'x'

    navigator:
      adaptToUpdatedData: false
      series:
        data: container.data('values')

    scrollbar:
      liveRedraw: false

    xAxis:
      events:
        afterSetExtremes: loadData
      minRange: 3600 * 1000
