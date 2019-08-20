// @ts-check
// Protractor configuration file, see link for more information
// https://github.com/angular/protractor/blob/master/lib/config.ts

const process = require('process');
process.env.CHROME_BIN = require('puppeteer').executablePath();

const { SpecReporter } = require('jasmine-spec-reporter');

/**
 * @type { import("protractor").Config }
 */
exports.config = {
  allScriptsTimeout: 11000,
  specs: [
    './src/features/**/*.feature'
],
  capabilities: {
    'browserName': 'chrome',
    chromeOptions: {
      args: [
        '--no-sandbox',
        '--disable-dev-shm-usage',
        '--headless',
        '--disable-gpu',
        '--remote-debugging-port=9222',
        '--disable-extensions',
      ],
      binary: process.env.CHROME_BIN
    },
  },
  directConnect: true,
  baseUrl: 'http://localhost:4200/',
  framework: 'custom',
  frameworkPath: require.resolve('protractor-cucumber-framework'),
  cucumberOpts: {
    require: [ './src/features/**/*.e2e-spec.ts' ],
    strict: true,
    format: 'json:TestResults/result/cucumber_report.json',
    'dry-run': false
},
  jasmineNodeOpts: {
    showColors: true,
    defaultTimeoutInterval: 30000,
    print: function() {}
  },
  onPrepare() {
    require('ts-node').register({
      project: require('path').join(__dirname, './tsconfig.json')
    });
    jasmine.getEnv().addReporter(new SpecReporter({ spec: { displayStacktrace: true } }));
  }
};
