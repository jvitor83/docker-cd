// Karma configuration file, see link for more information
// https://karma-runner.github.io/1.0/config/configuration-file.html

const process = require('process');
process.env.CHROME_BIN = require('puppeteer').executablePath();

module.exports = function (config) {
  config.set({
    basePath: '',
    frameworks: ['jasmine', '@angular-devkit/build-angular'],
    plugins: [
      require('karma-jasmine'),
      require('karma-chrome-launcher'),
      require('karma-jasmine-html-reporter'),
      require('karma-coverage-istanbul-reporter'),
      require('karma-junit-reporter'),
      require('@angular-devkit/build-angular/plugins/karma')
    ],
    client: {
      clearContext: false // leave Jasmine Spec Runner output visible in browser
    },
    coverageIstanbulReporter: {
      dir: require('path').join(__dirname, './TestResults/codecoverage'),
      reports: ['html', 'lcovonly', 'cobertura', 'text-summary'],
      fixWebpackSourcePaths: true
    },
    customLaunchers: {
      ChromeHeadlessNoSandbox:  {
              base:   'ChromeHeadless',
              flags:  [
                '--no-sandbox',
                '--disable-dev-shm-usage',
                '--headless',
                '--disable-gpu',
                '--remote-debugging-port=9222',
                '--disable-extensions',
                '--disable-web-security',
                '--shm-size=1gb',
              ],
            }
      },
    reporters: ['progress', 'kjhtml', 'junit'],
    junitReporter: {
      outputDir: './TestResults/result/junit' // results will be saved as $outputDir/$browserName.xml
    },
    failOnEmptyTestSuite: false,
    port: 9876,
    colors: true,
    logLevel: config.LOG_INFO,
    autoWatch: true,
    browsers: ['Chrome', 'ChromeHeadlessNoSandbox'],
    captureTimeout: 210000,
    browserDisconnectTolerance: 3,
    browserDisconnectTimeout: 210000,
    browserNoActivityTimeout: 210000,
    singleRun: false,
    restartOnFileChange: true
  });
};
