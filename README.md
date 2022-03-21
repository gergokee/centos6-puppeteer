# Centos 6 puppeteer docker image

docker image with  [Google Puppeteer](https://github.com/GoogleChrome/puppeteer) installed for **Centos 6 only**

If you can, please use Centos 7 or higher cause Centos 6 is EOL. Otherwise you can use this tool for Centos6.

Repo is based on [Google Puppeteer](https://github.com/GoogleChrome/puppeteer) and [docker-puppeteer](https://github.com/alekzonder/docker-puppeteer)

## before install
Make sure you upgraded your Centos 6 to latest:
```
rpm -Uvh https://www.elrepo.org/elrepo-release-6-8.el6.elrepo.noarch.rpm
yum clean all && yum update
reboot
```
After check version:
```
cat /etc/redhat-release
CentOS release 6.10 (Final)
```
Install Docker 1.7.1-1:
```
yum install https://get.docker.com/rpm/1.7.1/centos-6/RPMS/x86_64/docker-engine-1.7.1-1.el6.x86_64.rpm
```
Add docker to startup:
```
chkconfig docker on
```
## install

```
docker pull gergokee/centos6-puppeteer:latest

```

## before usage


1. You should **not** pass `--no-sandbox, --disable-setuid-sandbox` args when launching it, only if there is no other way, when you need to run it as **root** (which is not recommended).

```js
const puppeteer = require('puppeteer');

(async () => {

  console.info("Starting browser");

  let browser;

  try {

    browser = await puppeteer.launch({});

  } catch (e) {

    console.info("Unable to launch browser mode in sandbox mode. Lauching Chrome without sandbox.");
    browser = await puppeteer.launch({args:[
        '--no-sandbox',
        '--disable-setuid-sandbox'
        ]});

  }

  console.info("Browser successfully started");
  console.info("Closing browser");

  await browser.close();

  console.info("Done");
  
})();
```

2. If you see errors like "ERR_NETWORK_CHANGED", write your script to check the output of it and make a loop till the output is not generating errors. Unfortunately the problem is that IPV6 needs to be turned off. And because latest docker for Centos 6 is docker v1.7, you are unable to pass the necessary flag: **--sysctl net.ipv6.conf.all.disable_ipv6=1**


3. add `--enable-logging` for chrome debug logging http://www.chromium.org/for-testers/enable-logging

```js
const puppeteer = require('puppeteer');

(async() => {

    const browser = await puppeteer.launch({args: [
        '--no-sandbox',
        '--disable-setuid-sandbox',

        // debug logging
        '--enable-logging', '--v=1'
    ]});
    (async () => {

  console.info("Starting browser");

  let browser;

  try {

    browser = await puppeteer.launch({args: [
        '--enable-logging', '--v=1'
    ]});

  } catch (e) {

    console.info("Unable to launch browser mode in sandbox mode. Lauching Chrome without sandbox.");
    browser = await puppeteer.launch({args:[
        '--no-sandbox',
        '--disable-setuid-sandbox',
        '--enable-logging', '--v=1'
        ]});

  }

  console.info("Browser successfully started");
  console.info("Closing browser");

  await browser.close();

  console.info("Done");
  
})();


```

## usage

### mount your script to /app/index.js

```bash
docker run --rm -v <path_to_script>:/app/index.js gergokee/centos6-puppeteer:latest
```

### custom script from dir

```bash
docker run --rm \
 -v <path_to_dir>:/app \
 gergokee/centos6-puppeteer:latest \
 node my_script.js
```
