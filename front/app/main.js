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
        nodes: (function() {
          var ref = container.data('series');
          var results = [];
          for (j = 0, len = ref.length; j < len; j++) {
            var s = ref[j];
            results.push(s.path);
          }
          return results;
        })()
      }, function(data) {
        var i;
        for (i = j = 0, len = data.length; j < len; i = ++j) {
          var serieData = data[i];
          chart.series[i].setData(serieData);
        }
        return chart.hideLoading();
      });
    };

    var seriesConfig = (function() {
      var ref = container.data('series');
      var results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        var serie = ref[j];
        results.push({
          name: serie.name,
          data: serie.data,
          type: 'spline',
          tooltip: {
            valueDecimals: 2
          }
        });
      }
      return results;
    })();

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
