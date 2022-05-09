const path = require("path");
const HtmlWebpackPlugin = require("html-webpack-plugin");
const ModuleFederationPlugin = require("webpack/lib/container/ModuleFederationPlugin");

const PORT = 3000;

module.exports = {
  entry: path.resolve(__dirname, "./src/index.js"),
  devServer: {
    port: PORT,
    allowedHosts: [
      'notification.lvh.me'
    ]
  },
  output: {
    publicPath: "auto",
  },
  resolve: {
    extensions: [".js", ".jsx"],
  },
  module: {
    rules: [
      {
        test: /\.(js|jsx)$/,
        exclude: /node_modules/,
        use: ["babel-loader"],
      },
    ],
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: "./public/index.html",
    }),
    new ModuleFederationPlugin({
      name: "notification",
      filename: "remoteEntry.js",
      exposes: {
        "./Notifications": "./src/components/Notifications.js",
      },
    }),
  ],
};
