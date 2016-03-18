require('./main.css');

var Highcharts = require('highcharts/highstock');

Highcharts.setOptions({
  global: {
    useUTC: false
  }
});


$(function() {
  $('#gauge_chart').each(function() {
    var container = $(this);

    var loadData = function(e) {
      var chart = container.highcharts();
      chart.showLoading('Loading data from server...');
      return $.getJSON(container.data('url'), {
        from: Math.round(e.min),
        to: Math.round(e.max),
        nodes: container.data('series').map(function(s) { return s.path; })
      }, function(data) {
        for (var i = 0; i < data.length; ++i)
          chart.series[i].setData(data[i]);

        return chart.hideLoading();
      });
    };

    var seriesConfig = container.data('series').map(function(serie) {
      return {
        name: serie.title,
        data: serie.data,
        type: 'spline',
        tooltip: {
          valueDecimals: 2
        }
      };
    });

    Highcharts.stockChart(this, {
      rangeSelector: {
        selected: 4,
        buttons: [
          {
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
          }
        ]
      },
      title: {
        text: container.data('title')
      },
      series: seriesConfig,
      navigator: {
        adaptToUpdatedData: false
      },
      scrollbar: {
        liveRedraw: false
      },
      xAxis: {
        events: {
          afterSetExtremes: loadData
        },
        minRange: 3600 * 1000
      }
    });
  });

  $('.ui.accordion').accordion();
});
