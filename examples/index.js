'use strict';
const puppeteer = require('puppeteer');
const fs = require('fs');
(async () => {
  console.info("Starting browser");
  let browser;
  try {
    browser = await puppeteer.launch({});
  } catch (e) {
    console.info("Unable to launch browser mode in sandbox mode. Lauching Chrome without sandbox.");
    browser = await puppeteer.launch({args:['--no-sandbox','--disable-setuid-sandbox']});
  }
  console.info("Browser successfully started");
  console.info("Closing browser");
  await browser.close();
  console.info("Done");
})();