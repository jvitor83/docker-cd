import { Given, When, Then } from 'cucumber';
import * as chai from 'chai';
import * as chaiAsPromised from 'chai-as-promised';
import { AppPage } from '../../pages/app.po';
chai.use(chaiAsPromised);
const expect = chai.expect;


let page: AppPage;

Given(/^I am on the software$/, () => {
    page = new AppPage();
});

When(/^i go to the home page$/, () => {
    return page.navigateTo('/home');
});

Then(/^should have a title saying Home$/, () => {
    return page.getPageOneTitleText().then(title => expect('sistema-api:8081').to.be.equal(title));
});
