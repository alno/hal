var webpack = require('webpack');
var path = require('path');

var node_modules_dir = path.join(__dirname, 'node_modules');

var config = {
  entry: path.resolve(__dirname, 'app/main.js'),
  output: {
    path: path.resolve(__dirname, '../public'),
    filename: 'bundle.js'
  },

  module: {
    loaders: [{
      test: /\.jsx?/,
      loader: 'babel',
      exclude: [node_modules_dir]
    }, {
      test:   /\.css$/,
      loader: 'style-loader!css-loader'
    }]
  }

};

module.exports = config;
