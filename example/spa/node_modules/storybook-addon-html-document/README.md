# Storybook Addon HTML DOCUMENT

A Storybook addon that extracts and displays compiled syntax-highlighted HTML, and can load html documents.
It uses [highlight.js](https://highlightjs.org/) for syntax highlighting.

## Source of ideas

Expand [@whitespace-se/storybook-addon-html](https://github.com/whitespace-se/storybook-addon-html)

## Getting Started

```sh
npm i --save-dev storybook-addon-html-document
```

### Register addon

Create a file called `main.js` inside the `.storybook` directory and add the
following content:

```js
// .storybook/main.js
module.exports = {
    addons: [
        'storybook-addon-html-document'
    ],
}
```

## Usage

Add `withHTMLDOC` as a global decorator inside `.storybook/preview.js`:

```js
// .storybook/preview.js
// if you use @storybook/html.
//import { addDecorator } from '@storybook/html';
//import { withHTMLDOC } from 'storybook-addon-html-document/html';
import { addDecorator } from '@storybook/react';
import { withHTMLDOC } from 'storybook-addon-html-document/react';

addDecorator(withHTMLDOC);
```

The HTML is formatted with Prettier. You can override the Prettier config
(except `parser` and `plugins`) by providing an object following the
[Prettier API override format](https://prettier.io/docs/en/options.html):

```js
// .storybook/preview.js
// if you use @storybook/html.
//import { addDecorator } from '@storybook/html';
//import { withHTMLDOC } from 'storybook-addon-html-document/html';
import { addDecorator } from '@storybook/react';
import { withHTML } from 'storybook-addon-html-document/react';

addDecorator(
  withHTML({
    prettier: {
      tabWidth: 4,
      useTabs: false,
      htmlWhitespaceSensitivity: 'strict',
    },
  }),
);
```

## Matters need attention
- Html-loader need to be included in your webpack configuration.
- When the resource needs included in your html docments code are babel excluded, Or you can create a directory that is not hit by babel.

```js
//Suggest moving to move stories native html resources outside the project.
baseConfig.module.rules.push({
    test: /\.(html)$/,
    include:[path.join(appPath,'/.storybook/resource')],
    exclude: path.join(appPath,'/public/index.html'),
    use: [{
        loader:'html-loader',
        options:{
            minimize:false
        }
    }]
})
//Setup file-loader Ensure that html native resources are properly loaded
baseConfig.module.rules.push({
    include:function(url){
        //排除loader注入文件
        if(!/node\_modules\/.*?\-loader/.test(url)){
            return true
        }else{
            // console.log(url)
        }
    },
    issuer:function(url){
        if(/\.storybook\/resource.+\.html/.test(url)){
            // console.log(url)
            return true
        }
    },
    loader:'file-loader',
    options: {
        name: 'static/media/[name].[hash:8].[ext]'
    }
})
```

## Supported frameworks

When importing the decorator, use the correct path for your framework, e.g. `storybook-addon-html-document/react` for React or `storybook-addon-html-document/html` for HTML.

Right now, the addon can be used with these frameworks:

- HTML
- React

