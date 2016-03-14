var webpack = require('webpack');
var path = require('path');

var config = {
  entry: path.resolve(__dirname, 'app/main.js'),
  output: {
    path: path.resolve(__dirname, '../public'),
    filename: 'bundle.js'
  },

  module: {
    loaders: [{
      test: /\.jsx?/,
      loader: 'babel'
    }, {
      test:   /\.css$/,
      loader: 'style-loader!css-loader'
    }]
  }

};

module.exports = config;
