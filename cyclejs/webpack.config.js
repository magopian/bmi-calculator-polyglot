module.exports = {
  entry: "./scripts.es6/index.js",
  output: {
    path: "./scripts/",
    filename: "bundle.js"
  },
  module: {
    loaders: [
      { test: /\.js$/, exclude: /node_modules/, loader: "babel-loader" }
    ]
  }
};
